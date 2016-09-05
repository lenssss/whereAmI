//
//  ProductModel.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/6/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    var lifeProductIds:[String]? = nil
    var gemProductIds:[String]? = nil
    var spinProductIds:[String]? = nil
    var coinProductIds:[String]? = nil
    
    var lifeIcons:[UIImage]? = nil
    var gemIcons:[UIImage]? = nil
    var spinIcons:[UIImage]? = nil
    var coinIcons:[UIImage]? = nil
    
    class func getProductModel() -> ProductModel{
        let model = ProductModel()
        model.lifeProductIds = ["com.ziang.travels.lives10","com.ziang.travels.lives30","com.ziang.travels.lives50","com.ziang.travels.lives"]
        model.gemProductIds = ["com.ziang.travels.gems3","com.ziang.travels.gems5","com.ziang.travels.gems12","com.ziang.travels.gems32","com.ziang.travels.gems135"]
        model.spinProductIds = ["com.ziang.travels.spins3","com.ziang.travels.spins18","com.ziang.travels.spins100"]
        model.coinProductIds = ["com.ziang.travels.coins10","com.ziang.travels.coins55","com.ziang.travels.coins120","com.ziang.travels.coins320","com.ziang.travels.coins1300"]
        
        return model
     }
}
