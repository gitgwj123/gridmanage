//
//  AppDelegate.h
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFNetworkReachabilityManager *reqachabilityManager;
@property (assign, nonatomic) BOOL isNetworkReachable;

@end

