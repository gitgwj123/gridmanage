//
//  TLAlert.m
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLAlert.h"

@implementation TLAlert

+ (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay inView:(UIView *)superView {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView: superView];
    [superView addSubview:HUD];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = message;
    [HUD show:YES];
    [HUD hide:YES afterDelay: delay];
}

+ (void)setAlertControllerWithController:(BaseViewController *)controller Title:(NSString *)title message:(NSString *)message okActionTitle:(NSString *)okActionTitle okActionHandler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okActionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:okAction];
    
    [controller presentViewController:alertController animated:YES completion:nil];
    
}


+ (void)setAlertControllerWithController:(BaseViewController *)controller Title:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelTitle okActionTitle:(NSString *)okTitle cancelActionHandler:(void (^)(UIAlertAction *action))cancelHandler okActionHandler:(void (^)(UIAlertAction *action))okHandler; {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:okHandler];
    [alertController addAction:okAction];
    
    [controller presentViewController:alertController animated:YES completion:nil];

    
}

@end
