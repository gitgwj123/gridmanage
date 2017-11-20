//
//  BaseViewController.h
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 点击返回按钮跳转到指定的类
 如果 Class 类型为UINavigationController 则直接返回到Root
 注意： 如果设置该值 请勿在 <BackButtonProtocol> 中添加任何popViewController的方法
 */
@property (nonatomic, strong) Class backToClass;
@property (nonatomic, assign) BOOL isNOBackAnimation; //是否没有back Animation


@property (nonatomic, strong) UILabel *notiLabel;//无数据 显示label
@property (nonatomic, strong) UITableView *displayTableView;
@property (nonatomic, strong) UITableView *display2TableView;

/**
 MBProgressHUD
 
 @param view <#view description#>
 @param animated <#animated description#>
 */
- (void)networkStartLoad:(UIView *)view animated:(BOOL)animated;
- (void)networkStopLoad:(UIView *)view animated:(BOOL)animated;
- (void)networkStartLoad:(UIView *)view animated:(BOOL)animated descText:(NSString *)descText;


/**
 /无数据 显示label TapAction

 @param tap <#tap description#>
 */
- (void)notiLabelTapAction:(UITapGestureRecognizer *)tap;

@end
