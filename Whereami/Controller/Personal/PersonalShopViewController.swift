//
//  PersonalShopViewController.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import StoreKit
import MaterialControls
//import MBProgressHUD
import SVProgressHUD

class PersonalShopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,MDTabBarDelegate {
    
    private let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
    private var productArray:[SKProduct]? = nil
    
    var tableView:UITableView? = nil
    var tabbar:MDTabBar? = nil
    var buyType:Int? = nil
    var items:[ItemsModel]? = nil
    
    private let currentUser = UserModel.getCurrentUser()?.id
//    var productModel:ProductModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.title = NSLocalizedString("shop",tableName:"Localizable", comment: "")
        
        buyType = 0
        self.setUI()
        self.getDataSource()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    deinit{
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: false)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .None
        self.view.addSubview(tableView!)
        self.tableView?.registerClass(PersonalShopTableViewCell.self, forCellReuseIdentifier: "PersonalShopTableViewCell")
        
        let bottomImage = UIImageView()
//        bottomImage.backgroundColor = UIColor.redColor()
        self.view.addSubview(bottomImage)
        
        tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 50, 0))
        
        bottomImage.autoPinEdgeToSuperviewEdge(.Left)
        bottomImage.autoPinEdgeToSuperviewEdge(.Right)
        bottomImage.autoPinEdgeToSuperviewEdge(.Bottom)
        bottomImage.autoSetDimension(.Height, toSize: 50)
        
        self.setTabbar()
        tableView?.tableHeaderView = tabbar
        
        if SKPaymentQueue.canMakePayments() {
            self.requestProductData()
            print("允许程序内付费购买")
        }
        else{
            print("不允许程序内付费购买")
        }
    }
    
    func getDataSource(){
        let dic = [String:AnyObject]()
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SocketManager.sharedInstance.sendMsg("queryItems", data: dic, onProto: "queryItemsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                print("=====================")
                let arr = objs[0]["items"] as? [AnyObject]
                let models = ItemsModel.getModelFromArray(arr!)
                self.items = models
                self.requestProductData()
                print(models)
                print("=====================")
            }
        }
    }
    
    func setTabbar(){
        tabbar = MDTabBar()
        tabbar?.frame = CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 44)
        tabbar?.delegate = self
        tabbar?.setItems([NSLocalizedString("live",tableName:"Localizable", comment: ""),NSLocalizedString("gem",tableName:"Localizable", comment: ""),NSLocalizedString("spin",tableName:"Localizable", comment: ""),NSLocalizedString("coin",tableName:"Localizable", comment: "")])
        tabbar?.textColor = UIColor.grayColor()
        tabbar?.textFont = UIFont.systemFontOfSize(12.0)
        tabbar?.backgroundColor = UIColor.whiteColor()
        tabbar?.indicatorColor = UIColor(red: 81/255.0, green: 136/255.0, blue: 199/255.0, alpha: 1.0)
        tabbar?.rippleColor = UIColor.whiteColor()
    }
    
    func tabBar(tabBar: MDTabBar!, didChangeSelectedIndex selectedIndex: UInt) {
        switch selectedIndex {
        case 0:
            buyType = 0
            
        case 1:
            buyType = 1
            
        case 2:
            buyType = 2
            
        default:
            buyType = 3
        }
        SVProgressHUD.show()
        self.requestProductData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productArray != nil {
            return (productArray?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonalShopTableViewCell", forIndexPath: indexPath)  as! PersonalShopTableViewCell
        cell.selectionStyle = .None
        let product = productArray![indexPath.row]
        let item = filterItemByCode(product.productIdentifier)
        cell.itemName?.text = "\(product.localizedTitle)"
        cell.priceBtn?.setTitle("\(product.price)", forState: .Normal)
        if cell.itemLogo != nil {
            cell.itemLogo?.image = UIImage.string2Image(item!.icons!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            let product = productArray![indexPath.row]
            SVProgressHUD.setDefaultMaskType(.Gradient)
            SVProgressHUD.show()
            self.purchase(product)
        }
        else{
            self.restorePurchase()
        }
    }
    
    func requestProductData(){
        guard items != nil else {
            return
        }
        var product = NSArray()
        switch(buyType!){
        case 0:
            product = filterItemsByType("life")
            
        case 1:
            product = filterItemsByType("diamond")
        
        case 2:
            product = filterItemsByType("chance")
            
        default:
            product = filterItemsByType("gold")
        }
        let nsset = NSSet(array: product as [AnyObject])
        let request = SKProductsRequest(productIdentifiers: nsset as! Set<String>)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
//        MBProgressHUD.hideHUDForView(self.view, animated: true)
        SVProgressHUD.dismiss()
        if response.products.count == 0 {
            print("无法获取产品信息，购买失败")
            return
        }
        if productArray == nil {
            productArray = [SKProduct]()
        }
        else{
            productArray?.removeAll()
        }
        for product in response.products  {
            // 激活了对应的销售操作按钮，相当于商店的商品上架允许销售
            print("product loaded")
            print("Product id:\(product.productIdentifier)")
            print("产品标题:\(product.localizedTitle)")
            print("产品描述信息:\(product.localizedDescription)")
            print("价格: \(product.price)")
            // 填充商品字典
            productArray!.append(product)
        }
        tableView?.reloadData()
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("错误信息")
    }
    
    func requestProUpgradeProductData(){
        print("请求升级数据")
        let productIdentifiers = NSSet(object: "com.productid")
        let productsRequest = SKProductsRequest.init(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func requestDidFinish(request: SKRequest) {
        print("反馈信息结束")
    }
    
    func purchase(product:SKProduct){
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func PurchasedTransaction(transaction:SKPaymentTransaction){
        print("PurchasedTransaction")
        let transactions = NSArray(objects: transaction)
        self.paymentQueue(SKPaymentQueue.defaultQueue(), updatedTransactions: transactions as! [SKPaymentTransaction])
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        SVProgressHUD.dismiss()
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                print("transactionIdentifier = \(transaction.transactionIdentifier)")
                print("交易完成")
//                self.verifyPruchase()
                self.verifyPruchase({
                    self.completeTransaction(transaction)
                    self.runInMainQueue({
                        self.presentAlertView(true)
                    })
                })
                
            case .Failed:
                print("交易失败")
                self.failedTransaction(transaction)
                self.presentAlertView(false)
                
            case .Restored:
                self.restoreTransaction(transaction)
                
            case .Purchasing:
                print("商品添加进列表")
                
            case .Deferred:
                print("内购延迟")
            }
        }
    }
    
    func completeTransaction(transaction:SKPaymentTransaction){
//        print("成功")
        let productId = transaction.payment.productIdentifier
        if (productId.length > 0){
            //记录购买
            //对购买记录进行本地存储，以应对网络不佳的情况，发送成功则删除
            var dict = [String: AnyObject]()
            dict["accountId"] = currentUser
            print(dict["accountId"])
            dict["code"] = productId
            dict["itemNum"] = 1
            
            var arr = NSUserDefaults.standardUserDefaults().objectForKey("gainItems") as? [AnyObject]
            if arr == nil {
                arr = [AnyObject]()
            }
            
            var json:NSData? = nil
            do {
                json = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
                arr!.append(json!)
                NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "gainItems")
            }catch{
                
            }
            
            self.runInMainQueue({
                SVProgressHUD.show()
            })
            SocketManager.sharedInstance.sendMsg("gainItems", data: dict, onProto: "gainItemsed") { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    for (index, value) in arr!.enumerate() {
                        if value.isEqual(json!) {
                            arr?.removeAtIndex(index)
                            NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "gainItems")
                            break
                        }
                    }
                    self.runInMainQueue({ 
                        SVProgressHUD.showSuccessWithStatus("success")
                    })
                    self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                }else{
                    self.runInMainQueue({ 
                        SVProgressHUD.showErrorWithStatus("error")
                    })
                    self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                }
            }
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func failedTransaction(transaction:SKPaymentTransaction){
        print(transaction.error)
        let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: transaction.error?.localizedDescription, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (action) in
            SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        })
        alertController.addAction(confirmAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func restoreTransaction(transaction:SKPaymentTransaction){
        
    }
    
    private func restorePurchase(){
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        // 恢复购买失败，比如用户未曾购买过该商品
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {

        // 完成恢复购买
    }
    
    private func verifyPruchase(completion:theCallback){
        // 验证凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOfURL: receiptURL!)
        // 发送网络POST请求，对购买凭据进行验证
        let url = NSURL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        let request = NSMutableURLRequest(URL: url!, cachePolicy:      NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        // 传输的是BASE64编码的字符串
        let encodeStr = receiptData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}")
        print(payload)
        let payloadData = payload.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = payloadData;
        
        // 发送同步请求
        let session = NSURLSession.sharedSession()
        // 创建同步信号量
        let semaphore = dispatch_semaphore_create(0)
        
        let dataTask = session.dataTaskWithRequest(request,completionHandler: {(data, response, error) -> Void in
            if error != nil{
                // 访问错误
                print(error?.code)
                print(error?.description)
            }
            else{
                if (data==nil) {
                    // 验证失败
                    print("验证失败")
                    return
                }
                do{
                    print("验证成功")
                    // 验证成功后返回json数据转化为字典
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if (jsonResult.count != 0) {
                        // 凭证验证成功
                        let receipt = jsonResult["receipt"] as! NSDictionary
                        print(receipt["bundle_id"])
                        // 比对字典信息保证数据安全，以下是部分可验证信息：receipt["bundle_id"] & receipt["application_version"] & receipt["product_id"] & receipt["transaction_id"]
                        completion()
                    }
                }
                catch{
                    print("验证凭证出错")
                }
            }
            // 释放信号量
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        //使用resume方法启动任务
        dataTask.resume()
        // 等待信号量直到请求完成后恢复
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func presentAlertView(isComplete:Bool){
        var alertController:UIAlertController? = nil
        switch isComplete {
        case true:
            alertController = UIAlertController(title: "", message: "－－purchase success－－", preferredStyle: .Alert)
        default:
            alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: "－－purchase fail－－", preferredStyle: .Alert)
        }
        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
        alertController!.addAction(confirmAction)
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func SVProgressDismiss(){
        SVProgressHUD.dismiss()
    }
    
    func filterItemsByType(type:String) -> [String] {
        var ids = [String]()
        for item in items! {
            if item.type == type {
                let models = item.items
                for model in models! {
                    ids.append(model.code!)
                }
            }
        }
        return ids
    }
    
    func filterItemByCode(code:String) -> ItemModel? {
        let items = filterItemsByTabbarIndex()!.items
        var item:ItemModel? = nil
        guard items != nil else{
            return item
        }
        for i in items! {
            if i.code == code {
                item = i
            }
        }
        return item
    }
    
    func filterItemsByTabbarIndex() -> ItemsModel? {
        var type:String? = nil
        let index = tabbar?.selectedIndex
        switch index! {
        case 0:
            type = "life"
            
        case 1:
            type = "diamond"
            
        case 2:
            type = "chance"
            
        default:
            type = "gold"
        }
        var item:ItemsModel? = nil
        for i in items! {
            if i.type == type {
                item = i
            }
        }
        return item
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
