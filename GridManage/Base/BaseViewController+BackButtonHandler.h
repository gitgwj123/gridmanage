//
//  BaseViewController+BackButtonHandler.h
//  GridManage
//
//  Created by gwj on 2017/11/17.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController.h"


@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;

@end

@interface BaseViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
