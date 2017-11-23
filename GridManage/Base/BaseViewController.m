//
//  BaseViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = SYSTEM_Background_COLOR;

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:SYSTEM_COLOR, NSFontAttributeName:FONT(18)};
    
    [self notiLabel];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self hideBackButtonTitle];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self networkStopLoad:self.view animated:YES]; //避免忘记移除 Loading HUD
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

//隐藏返回按钮的文字
- (void)hideBackButtonTitle {
    
    NSArray *viewControllerArr = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArr indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArr objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    self.navigationController.navigationBar.tintColor = SYSTEM_COLOR;
}


#pragma mark - Network Loading
- (void)networkStartLoad:(UIView *)view animated:(BOOL)animated {
    
    [self networkStartLoad:view animated:animated descText:nil];
}

- (void)networkStartLoad:(UIView *)view animated:(BOOL)animated descText:(NSString *)descText {
    
    [self networkStopLoad:view animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    if (descText) {
        hud.labelText = descText;
    }
}

- (void)networkStopLoad:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:view animated:animated];
}

#pragma mark - actions
- (void)notiLabelTapAction:(UITapGestureRecognizer *)tap {

    
}

- (void)segmentControlAction:(UISegmentedControl *)segmentControl {
    // [self setupSegmentBorder:segmentControl];
    
}

#pragma mark - lazy loading
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
        [self segmentedControl];
    }
    return _titleView;
}

- (UISegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:self.segmentItems];
        [self.titleView addSubview:segmentControl];
        [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
        [segmentControl setTintColor:SYSTEM_COLOR];
        [segmentControl setSelectedSegmentIndex:0];
        
        [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:SYSTEM_COLOR, NSFontAttributeName : FONT(18)}
                                      forState:UIControlStateNormal];
        NSDictionary *selectedAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIColor whiteColor],
                                                      NSForegroundColorAttributeName,
                                                      FONT(18), NSFontAttributeName,
                                                      nil];
        [segmentControl setTitleTextAttributes:selectedAttributesDictionary forState:UIControlStateSelected];
        
        [segmentControl setWidth:80 forSegmentAtIndex:0];
        [segmentControl setWidth:80 forSegmentAtIndex:1];
    }
    
    return _segmentedControl;
}

- (UILabel *)notiLabel {

    if (!_notiLabel) {
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.backgroundColor = [UIColor clearColor];
        _notiLabel.frame = CGRectMake(paddingK, (screenHeight - statusBarAndNavBarHeight - 40 )/2, screenWidth - 2 * paddingK, 40);
        _notiLabel.text = @"";
        _notiLabel.font = FONT(18);
        _notiLabel.textColor = [UIColor whiteColor];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.hidden = YES;
        _notiLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *notiLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notiLabelTapAction:)];
        [_notiLabel addGestureRecognizer:notiLabelTap];
        [self.view addSubview:_notiLabel];
    }
    
    return _notiLabel;
}

- (UITableView *)displayTableView {

    if (!_displayTableView) {
        
        _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight + 40, screenWidth, screenHeight - statusBarAndNavBarHeight - 40 - 49) style:UITableViewStylePlain];
        _displayTableView.backgroundColor = [UIColor clearColor];
        _displayTableView.showsVerticalScrollIndicator = NO;
        _displayTableView.showsHorizontalScrollIndicator = NO;
        _displayTableView.sectionFooterHeight = 0;
        [_displayTableView setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:_displayTableView];
    }
    
    return _displayTableView;
}

- (UITableView *)display2TableView {
    
    if (!_display2TableView) {
        
        _display2TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight + 40, screenWidth, screenHeight - statusBarAndNavBarHeight - 40 - 49) style:UITableViewStylePlain];
        _display2TableView.backgroundColor = [UIColor clearColor];
        _display2TableView.showsVerticalScrollIndicator = NO;
        _display2TableView.showsHorizontalScrollIndicator = NO;
        _display2TableView.sectionFooterHeight = 0;
        [_display2TableView setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:_display2TableView];
        
    }
    
    return _display2TableView;
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
