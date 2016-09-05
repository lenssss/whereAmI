//
//  PhotoEditingViewController.m
//  MyImageFilter
//
//  Created by jiang on 15/6/8.
//  Copyright (c) 2015年 jiangshiyong. All rights reserved.
//

#import "PhotoEditingViewController.h"
#import "UIImage+Mark.h"
#import "SVProgressHUD.h"
#import "Whereami-Swift.h"

@interface PhotoEditingViewController ()<CustomFilterButtonViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myPhotoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *filterScrollView;

@property (nonatomic, strong) UIImageView *markImageView;

@property (strong, nonatomic) NSArray *filters;
//@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) NSArray *filteredImages;
@property (strong, nonatomic) CIImage *inputImage;

@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGRect oldFrame;    //保存图片原来的大小
@property (nonatomic) CGRect largeFrame;  //确定图片放大最大的程度
@end

@implementation PhotoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     NSString *kCICategoryDistortionEffect;
     NSString *kCICategoryGeometryAdjustment;
     NSString *kCICategoryCompositeOperation;
     NSString *kCICategoryHalftoneEffect;
     NSString *kCICategoryColorAdjustment;
     NSString *kCICategoryColorEffect;
     NSString *kCICategoryTransition;
     NSString *kCICategoryTileEffect;
     NSString *kCICategoryGenerator;
     NSString *kCICategoryReduction;
     NSString *kCICategoryGradient;
     NSString *kCICategoryStylize;
     NSString *kCICategorySharpen;
     NSString *kCICategoryBlur;
     NSString *kCICategoryVideo;
     NSString *kCICategoryStillImage;
     NSString *kCICategoryInterlaced;
     NSString *kCICategoryNonSquarePixels;
     NSString *kCICategoryHighDynamicRange ;
     NSString *kCICategoryBuiltIn;
     NSString *kCICategoryFilterGenerator;
     */
    
    //[self showAllFilters];
    
    //_filters = [NSArray arrayWithArray:[CIFilter filterNamesInCategories:@[kCICategoryColorEffect]]];
    /*
     CIColorClamp,
     CIColorCrossPolynomial,
     CIColorCube,
     CIColorCubeWithColorSpace,
     CIColorInvert,
     CIColorMap,
     CIColorMonochrome,
     CIColorPolynomial,
     CIColorPosterize,
     CIFalseColor,
     CIMaskToAlpha,
     CIMaximumComponent,
     CIMinimumComponent,
     CIPhotoEffectChrome,
     CIPhotoEffectFade,
     CIPhotoEffectInstant,
     CIPhotoEffectMono,
     CIPhotoEffectNoir,
     CIPhotoEffectProcess,
     CIPhotoEffectTonal,
     CIPhotoEffectTransfer,
     CISepiaTone,
     CIVignette,
     CIVignetteEffect
     */
    
    NSLog(@"_filters=========%@",_filters);
    _filters = @[@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant",
                 @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess",
                 @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer",@"CIPhotoEffectFade"];
    _inputImage = [CIImage imageWithCGImage:[self.photoImage CGImage]];

    [self initContentView];
}

- (void)showAllFilters{
    
    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"filterNames count=======%lu",(unsigned long)[filterNames count]);
    for (NSString *filterName in filterNames) {
        CIFilter *filter=[CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)initContentView {
    
    UIView *rightMenuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 44)];
    rightMenuBgView.backgroundColor = [UIColor clearColor];
    
    UIButton *rightMenuButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightMenuButton.frame = CGRectMake(15, (rightMenuBgView.frame.size.height-44)/2, rightMenuBgView.frame.size.width, 44);
    rightMenuButton.backgroundColor = [UIColor clearColor];
    rightMenuButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightMenuButton setTitle:@"Next" forState:UIControlStateNormal];
    [rightMenuButton setTitle:@"Next" forState:UIControlStateHighlighted];
    [rightMenuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightMenuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightMenuButton addTarget:self action:@selector(rightMenuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightMenuBgView addSubview:rightMenuButton];
    
    UIBarButtonItem *rightmenuBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightMenuBgView];
    self.navigationItem.rightBarButtonItem = rightmenuBarItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.bounds = CGRectMake(0, 0, 30, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarIem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarIem;
    
    self.myPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myPhotoImageView.image = self.photoImage;
    
    //self.markImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.myPhotoImageView.frame.size.width-80)/2, (self.myPhotoImageView.frame.size.height-80)/2, 80, 80)];
    
    UIView *bgPhotoImageView = [[UIView alloc]initWithFrame:self.myPhotoImageView.frame];
    bgPhotoImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgPhotoImageView];
    
//    self.markImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.myPhotoImageView.frame.size.width-80)/2, self.myPhotoImageView.frame.origin.y+(self.myPhotoImageView.frame.size.height-80)/2, 80, 80)];
//    self.markImageView.image = [UIImage imageNamed:@"loading1_ios"];
//    [bgPhotoImageView addSubview:self.markImageView];
    
    [self.markImageView setMultipleTouchEnabled:YES];
    [self.markImageView setUserInteractionEnabled:YES];
    
    self.oldFrame = self.markImageView.frame;
    //self.largeFrame = CGRectMake(0 - self.myPhotoImageView.frame.size.width, 0 - self.myPhotoImageView.frame.size.height, 3 * self.oldFrame.size.width, 3 * self.oldFrame.size.height);
    self.largeFrame = CGRectMake(0, 0 - self.myPhotoImageView.frame.size.height, 3 * self.oldFrame.size.width, 3 * self.oldFrame.size.height);
    [self addGestureRecognizerToView:self.markImageView];
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    __weak PhotoEditingViewController *weakSelf = self;
    //延后执行某个方法
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf layoutScorllViewSubViews];
    });
}

-(void)rightMenuButtonClicked {

    //[self saveImageToAlbum];
    
    PublishQuestionViewController *publishQuestionVC = [[PublishQuestionViewController alloc]init];
    publishQuestionVC.selectedImage = self.myPhotoImageView.image;
    [self.navigationController pushViewController:publishQuestionVC animated:YES];
}

-(void)leftButtonClicked {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)saveImageToAlbum{
    
    UIImageWriteToSavedPhotosAlbum(self.myPhotoImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];
    }
    //[SVProgressHUD showWithStatus:message];
    [SVProgressHUD showSuccessWithStatus:message];
    NSLog(@"message is %@",message);
}

#pragma mark - Utility Methods
- (NSArray *)preFilterImages
{
    NSMutableArray *images = [NSMutableArray new];
    for(NSString *filterName in _filters) {
        // Filter the image
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setValue:_inputImage forKey:kCIInputImageKey];
        
        // Create a CG-back UIImage
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        if (image) {
            [images addObject:image];
        }
    }
    return [images copy];
}

- (void)layoutScorllViewSubViews {

    _filteredImages = [self preFilterImages];
    
    for (CustomFilterButtonView *customView in self.filterScrollView.subviews) {
        
        [customView removeFromSuperview];
    }
    if ([_filteredImages count]>1) {
        
        self.filterScrollView.contentSize = CGSizeMake(100*([_filteredImages count]+1), self.filterScrollView.frame.size.height);
        
        for (int i=0; i<[_filteredImages count]; i++) {
            
            UIImage *image = _filteredImages[i];
            NSString *text = _filters[i];
            
            CustomFilterButtonView *customView = [[CustomFilterButtonView alloc]initWithFrame:CGRectMake(i*(100.0f+10), 0, 100, 120) withImage:image withType:text];
            customView.delegate = self;
            [self.filterScrollView addSubview:customView];
        }
    }
    [SVProgressHUD dismiss];
}

- (void)customFilterButtonView:(CustomFilterButtonView *)customFilterButtonView didSelectFilterImage:(UIImage *)filterImage {

    NSLog(@"self.markImageView.frame.origin.x====%f",self.markImageView.frame.origin.x);
    //添加图片水印 [UIImage imageNamed:@"loading1_ios"]
    //self.myPhotoImageView.image = [filterImage addUseImage:filterImage addWaterMarkImage:self.markImageView.image withMarkRect:CGRectMake((self.myPhotoImageView.frame.size.width-80)/2, (self.myPhotoImageView.frame.size.height-80)/2, 80, 80)];//filterImage;
    self.myPhotoImageView.image = [filterImage addUseImage:filterImage addWaterMarkImage:self.markImageView.image withMarkRect:CGRectMake(self.markImageView.frame.origin.x, self.markImageView.frame.origin.y, self.markImageView.frame.size.width, self.markImageView.frame.size.height)];//markImageView
    //self.myPhotoImageView.image = [filterImage addUseImage:filterImage addMarkText:@"易迅易选" withMarkRect:CGRectMake((self.myPhotoImageView.frame.size.width-80)/2, (self.myPhotoImageView.frame.size.height-80)/2+20, 80, 80)];
}

// 添加所有的手势
- (void)addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
//- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
//{
//    UIView *view = pinchGestureRecognizer.view;
//    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        pinchGestureRecognizer.scale = 1;
//    }
//}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        //self.markImageView.center = (CGPoint){view.center.x + translation.x, view.center.y + translation.y};
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (self.markImageView.frame.size.width < self.oldFrame.size.width) {
            self.markImageView.frame = self.oldFrame;
            //让图片无法缩得比原图小
        }
        if (self.markImageView.frame.size.width > 3 * self.oldFrame.size.width) {
            self.markImageView.frame = self.largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
