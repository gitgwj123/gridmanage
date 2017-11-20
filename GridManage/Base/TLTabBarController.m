//
//  TLTabBarController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLTabBarController.h"

#import "TLWorkViewController.h"
#import "TLGridViewController.h"
#import "TLRemindViewController.h"

@interface TLTabBarController ()

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configTabBar];

}


- (void)configTabBar {

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(153, 153, 153, 1)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(255, 255, 255, 1)} forState:UIControlStateSelected];
    [[UITabBar appearance] setBarTintColor:SYSTEM_TabBar_COLOR];
    [UITabBar appearance].translucent = NO;

    
    TLWorkViewController *workVc     = [[TLWorkViewController alloc] init];
    TLGridViewController *gridVc     = [[TLGridViewController alloc] init];
    TLRemindViewController *remindVc = [[TLRemindViewController alloc] init];
    
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVc];
    UINavigationController *gridNav = [[UINavigationController alloc] initWithRootViewController:gridVc];
    UINavigationController *remindNav = [[UINavigationController alloc] initWithRootViewController:remindVc];
    
    workNav.tabBarItem.title   = @"作业";
    gridNav.tabBarItem.title   = @"网格";
    remindNav.tabBarItem.title = @"提醒";
    
    workNav.tabBarItem.image = [UIImage imageNamed:@"ic_work_normal"];
    workNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_work_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//始终绘制图片原始状态，不使用Tint Color
    gridNav.tabBarItem.image = [UIImage imageNamed:@"ic_grid_normal"];
    gridNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_grid_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    remindNav.tabBarItem.image = [UIImage imageNamed:@"ic_remind_normal"];
    remindNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_remind_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[workNav, gridNav, remindNav];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
