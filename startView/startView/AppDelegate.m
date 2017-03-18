//
//  AppDelegate.m
//  startView
//
//  Created by 孙承秀 on 16/12/6.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "AppDelegate.h"
#import "DPStartVierw.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DPStartVierw *startView = [[DPStartVierw alloc]initWIthWindow:self.window andADType:ADTypeSmall];
    
    // 加载本地图片
    startView.localImageName = @"qidong.gif";
    
    // 加载网络图片
    //startView.imageUrl = @"http://pic33.nipic.com/20130916/3420027_192919547000_2.jpg";
    startView.clickBlock = ^(ClickType type){
    
        switch (type) {
            case ClickTypeTimeOut:
                NSLog(@"广告业超时结束了");
                break;
                case ClickTypeSkip:
                NSLog(@"点击跳过了");
                break;
                case ClickTypeClickAD:
                NSLog(@"点击广告了");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
            default:
                break;
        }
    };
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
