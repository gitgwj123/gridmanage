//
//  BaseViewController+NavigationBar.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController+NavigationBar.h"

@implementation BaseViewController (NavigationBar)


//修改导航栏 title 颜色 大小
- (void)setNavigationBarTitleColor:(UIColor *)color fontSize:(NSUInteger)size {

     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size],NSForegroundColorAttributeName: color}];
}

//添加右侧按钮
- (UIBarButtonItem *)addRightBarButtonItemWithImage:(UIImage *)image {
    return [self addRightBarButtonItemWithImage: image
                                         offset: -10];
}

- (UIBarButtonItem *) addRightBarButtonItemWithImage:(UIImage *)image offset:(CGFloat)offset {
    
    // custom button
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitleColor: [UIColor clearColor]
                 forState: UIControlStateNormal];
    [button setImage: image forState: UIControlStateNormal];
    [button setBackgroundColor: [UIColor clearColor]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15;
    [button addTarget: self
               action: @selector(rightNavigationBarItemAction:)
     forControlEvents: UIControlEventTouchUpInside];
    button.frame = CGRectMake(20, 7, 30, 30);
    
    // space bar button item
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    placeHolderItem.width = -15 + offset*-1;
    
    // right bar button item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    self.navigationItem.rightBarButtonItems = @[placeHolderItem, rightItem];
    
    return rightItem;
}

- (UIBarButtonItem *) addRightBarButtonItemWithTitle:(NSString *)title {
    return [self addRightBarButtonItemWithTitle: title titleColor:[UIColor whiteColor]
                                         offset: -10];
}

- (UIBarButtonItem *)addRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color {

    return [self addRightBarButtonItemWithTitle: title titleColor:color
                                         offset: -10];
}

- (UIBarButtonItem *)addRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color offset:(CGFloat)offset {
    
    // custom button
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitleColor: color
                 forState: UIControlStateNormal];
    [button setTitle: title
            forState: UIControlStateNormal];
    [button setBackgroundColor: [UIColor clearColor]];
    [button addTarget: self
               action: @selector(rightNavigationBarItemAction:)
     forControlEvents: UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(18);
    button.frame = CGRectMake(20, 0, [self widthWithFont:button.titleLabel.font title: title], 44);
    
    // space bar button item
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    placeHolderItem.width = -15 + offset*-1;
    
    // right bar button item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    self.navigationItem.rightBarButtonItems = @[placeHolderItem, backItem];
    
    return backItem;
}

#pragma mark - Actions
- (void) rightNavigationBarItemAction:(UIButton *)sender {
   
}

#pragma mark - prvate methods
- (CGFloat) widthWithFont:(UIFont *)font title:(NSString *)title {
    
    return [title boundingRectWithSize: CGSizeMake(200, 44)
                               options: NSStringDrawingUsesLineFragmentOrigin
                            attributes: @{NSFontAttributeName : font}
                               context: nil].size.width;
}

//- (void)segmentControlAction:(UISegmentedControl *)segmentControl {
//   // [self setupSegmentBorder:segmentControl];
//
//}

@end
