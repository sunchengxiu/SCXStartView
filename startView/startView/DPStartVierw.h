//
//  DPStartVierw.h
//  startView
//
//  Created by 孙承秀 on 16/12/6.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger , ADType) {

    ADTypeSmall = 0,// 局部广告
    ADTypeFull // 全屏广告

};
typedef NS_ENUM(NSInteger , ClickType) {

    ClickTypeClickAD = 0,
    ClickTypeSkip ,
    ClickTypeTimeOut

};
typedef void (^clickADView)(ClickType index);
@interface DPStartVierw : UIView
/******  广告时间 *****/
@property(nonatomic,assign)NSInteger timerCount;
/******  背景图片 *****/
@property(nonatomic,strong)UIImageView *backImageView;
/******  网络图片URl *****/
@property(nonatomic,copy)NSString *imageUrl;
/******  跳过按钮 *****/
@property(nonatomic,strong)UIButton *skipButton;
/******  本地图片名字 *****/
@property(nonatomic,copy)NSString *localImageName;
/******  点击广告Block *****/
@property(nonatomic,copy)clickADView clickBlock;
/******  定时器 *****/
@property(nonatomic,strong)NSTimer *timer;
/******  广告结束种类 *****/
@property(nonatomic,assign)ClickType adEndType;
- (instancetype)initWIthWindow:(UIWindow *)window andADType:(ADType)adtype;
@end
