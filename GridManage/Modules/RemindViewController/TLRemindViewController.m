//
//  TLRemindViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLRemindViewController.h"

@interface TLRemindViewController ()

@end

@implementation TLRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentItems = @[@"待办事项", @"系统提示"];
    self.navigationItem.titleView = self.titleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - action
- (void)segmentControlAction:(UISegmentedControl *)segmentControl {
    
    
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
