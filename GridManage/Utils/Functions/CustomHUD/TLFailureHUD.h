//
//  TLFailureHUD.h
//  GridManage
//
//  Created by gwj on 2017/11/12.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLLoadingHeader.h"

@interface TLFailureHUD : UIView<CAAnimationDelegate>

-(void)start;

-(void)hide;

+(TLFailureHUD *)showIn:(UIView*)view;

+(TLFailureHUD *)hideIn:(UIView*)view;

@end
