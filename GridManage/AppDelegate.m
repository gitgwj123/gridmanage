//
//  AppDelegate.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "AppDelegate.h"
#import "TLLoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //初始化网络监听
    [self initNetworkMonitor];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    TLLoginViewController *loginVc = [[TLLoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    self.window.rootViewController = loginNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)initNetworkMonitor
{
    MyLog(@"initNetworkMonitor ");
    self.isNetworkReachable = YES;
    _reqachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [_reqachabilityManager startMonitoring];
    NSDate *date = [NSDate new];
    WeakSelf;
    [_reqachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        MyLog(@"network time interval : %@", @([[NSDate new] timeIntervalSinceDate:date]));
        MyLog(@"Network Reachable : %@", @(status));
        StrongSelf;
        if (status == AFNetworkReachabilityStatusNotReachable
            && strongSelf.isNetworkReachable
            ) {
            strongSelf.isNetworkReachable = NO;
            [strongSelf showNetWorkLost];
        }
        
    }];
}


- (void)showNetWorkLost
{
    MyLog(@"😂😂😂网络断开连接！！！！");
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"网络断开连接， 请稍后重试";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0f];
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
