//
//  DPStartVierw.m
//  startView
//
//  Created by 孙承秀 on 16/12/6.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPStartVierw.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation DPStartVierw

-(instancetype)initWIthWindow:(UIWindow *)window andADType:(ADType)adtype{

    self = [super init];
    if (self) {
        _timerCount = 6;
        [window makeKeyAndVisible];
        CGSize size = window.bounds.size;
        // 设置屏幕方向
        NSString *orientation = @"Portrait";
        NSArray *imagArr = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        NSString *launchImageName = nil;
        for (NSDictionary *dic in imagArr) {
            CGSize launchImageSIze = CGSizeFromString(dic[@"UILaunchImageSize"]) ;
            if (CGSizeEqualToSize(launchImageSIze, size)) {
                launchImageName = dic[@"UILaunchImageName"];
            }
        }
        UIImage *image = [UIImage imageNamed:launchImageName];
        // 用启动图片来作为背景 这样能做一个过度 界面看起来更美观
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backImageView = [[UIImageView alloc]init];
        // 设置背景的大小，全屏或者局部
        if (adtype == ADTypeSmall) {
            self.backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_HEIGHT/5);
        }
        else{
            self.backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        }
        //  添加跳过按钮
        [self.backImageView addSubview:self.skipButton];
        [self addSubview:self.backImageView];
        // 点击广告图片的时候，添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
        // 允许用户交互
        self.backImageView.userInteractionEnabled = YES;
        [self.backImageView addGestureRecognizer:tap];
        
        // 添加渐入动画
        CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        baseAnimation.duration = 0.8;
        baseAnimation.fromValue = [NSNumber numberWithInt:0];
        baseAnimation.toValue = [NSNumber numberWithFloat:0.8];
        baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.backImageView.layer addAnimation:baseAnimation forKey:@"animateOpacity"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimer:) userInfo:nil repeats:YES];
        [window addSubview:self];
    }
    return self;
}
#pragma mark --  懒加载

/**
 跳过按钮
 */
-(UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(SCREEN_WIDTH - 70, 20, 60, 30);
        _skipButton.backgroundColor = [UIColor brownColor];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_skipButton addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 让跳过按钮一半有圆滑的感觉
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_skipButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer * shapeLayer = [[CAShapeLayer alloc]init];
        shapeLayer.frame = _skipButton.bounds;
        shapeLayer.path = path.CGPath;
        _skipButton.layer.mask = shapeLayer;
    }
    return _skipButton;
}
#pragma  mark - 按钮点击事件

/**
 跳过按钮点击事件
 */
-(void)skipBtnClick{
    _adEndType = ClickTypeSkip;
    [self closeADView];
}
/**
 点击广告图响应事件
 */
- (void)activiTap:(UITapGestureRecognizer *)tap {
    _adEndType = ClickTypeClickAD;
    [self closeADView];
}
#pragma mark - 定时器计时
- (void)countTimer:(NSTimer *)timer {

    if (self.timerCount == 0) {
        [self.timer invalidate];
        self.timer = nil;
        _adEndType = ClickTypeTimeOut;
        [self closeADView];
    }
    else{
        [self.skipButton setTitle:[NSString stringWithFormat:@"%@ |跳过",@(_timerCount--)] forState:UIControlStateNormal];
        
    }
}
#pragma mark - 关闭广告业
- (void)closeADView {

    //  渐隐动画
    CABasicAnimation *baseaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    baseaAnimation.duration = 0.5;
    baseaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    baseaAnimation.toValue =[NSNumber numberWithFloat:0.3];
    baseaAnimation.removedOnCompletion = NO;
    baseaAnimation.fillMode = kCAFillModeForwards;
    [self.backImageView.layer addAnimation:baseaAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:baseaAnimation.duration target:self selector:@selector(closeAll) userInfo:nil repeats:NO];
}
- (void)closeAll{
    [self.timer invalidate];
    self.timer = nil;
    self.hidden = YES;
    self.backImageView.hidden = YES;
    [self removeFromSuperview];
    if (self.clickBlock) {
        self.clickBlock(_adEndType);
    }
}

#pragma mark - 设置本地图片
-(void)setLocalImageName:(NSString *)localImageName{
    _localImageName = localImageName;
    if (_localImageName) {
        // 加载Git , 因为Gif特殊，不能直接显示，需要用webview打开，所以在imageView上面就多了一个webView，所以就还需要在webView上面再添加一个Button
        if ([_localImageName rangeOfString:@".gif"].location != NSNotFound) {
            _localImageName = [_localImageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
            NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_localImageName ofType:@"gif"]];
            
            // 使用webView来打开Gif图片
            UIWebView *webview = [[UIWebView alloc]initWithFrame:self.backImageView.frame];
            webview.scalesPageToFit = YES;
            webview.backgroundColor = [UIColor clearColor];
            webview.scrollView.scrollEnabled = NO;
            [webview loadData:data MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            UIButton *button = [[UIButton alloc]initWithFrame:webview.frame];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(activiTap:) forControlEvents:UIControlEventTouchUpInside];
            [webview addSubview:button];
            [self.backImageView addSubview:webview];
            [self.backImageView bringSubviewToFront:self.skipButton];
             // 添加按钮，点击广告的时候调用的方法
        }
        // 加载普通图片
        else{
            self.backImageView.image = [UIImage imageNamed:localImageName];
        }
        
       
    }
}
#pragma mark - 加载本地图片
-(void)setImageUrl:(NSString *)imageUrl{

    _imageUrl = imageUrl;
    if (_imageUrl) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            self.backImageView.image = [self compressImageWithOriginImage:image andTargetWidth:SCREEN_WIDTH];
        }];
    }
}

#pragma mark - 处理图片，按照图片原比例进行缩放
- (UIImage *)compressImageWithOriginImage:(UIImage *)originImage andTargetWidth:(CGFloat )targetWidth{

    // 原始图片宽高
    CGSize originSize = originImage.size;
    CGFloat width = originImage.size.width;
    CGFloat height = originImage.size.height;
    
    // 目的高度
    CGFloat targetHeight = height / (width / targetWidth);
    
    // 目的size
    CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
    
    //缩放比例
    CGFloat scaleFactor = 0.0;
    
    // 裁剪位置
    CGPoint thumbnailPoint = CGPointMake(0, 0);
    
    CGFloat scaleHeight = targetHeight;
    CGFloat scaleWidth = targetWidth;
    
    // 确定最终的缩放
    if (CGSizeEqualToSize(originSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFacror = targetHeight / height;
        if (widthFactor > heightFacror) {
            scaleFactor = widthFactor;
        }
        else{
        
            scaleFactor = heightFacror;
        }
        scaleWidth = width * widthFactor;
        scaleHeight = height * heightFacror;
        if (widthFactor > heightFacror) {
            thumbnailPoint.y = (targetHeight - scaleHeight)*0.5;
        }
        else if (widthFactor < heightFacror){
        
            thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5;
            
        }
        
    }
    
    //开始裁剪图片
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaleWidth;
    thumbnailRect.size.height = scaleHeight;
    [originImage drawInRect:thumbnailRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
