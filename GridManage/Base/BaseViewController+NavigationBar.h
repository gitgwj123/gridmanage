//
//  BaseViewController+NavigationBar.h
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (NavigationBar)


/**
 //修改导航栏 title 颜色 大小

 @param color <#color description#>
 @param size <#size description#>
 */
- (void)setNavigationBarTitleColor:(UIColor *)color fontSize:(NSUInteger)size;

/**
 添加右侧按钮

 @param image <#image description#>
 @return <#return value description#>
 */
- (UIBarButtonItem *)addRightBarButtonItemWithImage:(UIImage *)image;

- (UIBarButtonItem *)addRightBarButtonItemWithTitle:(NSString *)title;

- (UIBarButtonItem *)addRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color;

- (UIBarButtonItem *)addRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color offset:(CGFloat)offset;

- (void) rightNavigationBarItemAction:(UIButton *)sender;

@end
