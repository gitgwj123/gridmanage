//
//  TLAlert.h
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAlert : NSObject

/**
 MBProgressHUD显示用户提示框
 
 @param message 提示语
 @param delay 自动消失时长
 @param superView 父视图
 */
+ (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay inView:(UIView *)superView;


+ (void)setAlertControllerWithController:(BaseViewController *)controller Title:(NSString *)title message:(NSString *)message okActionTitle:(NSString *)okActionTitle okActionHandler:(void (^)(UIAlertAction *action))handler;


+ (void)setAlertControllerWithController:(BaseViewController *)controller Title:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelTitle okActionTitle:(NSString *)okTitle cancelActionHandler:(void (^)(UIAlertAction *action))cancelHandler okActionHandler:(void (^)(UIAlertAction *action))okHandler;

@end
