//
//  TLSettingViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLSettingViewController.h"
#import "TLChangePwdViewController.h"
#import "TLLoginViewController.h"

@interface TLSettingViewController ()

@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) UIView *changePwdView;

@end

@implementation TLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {

    [self.view addSubview: [UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, 10)]];
    
    //高度间距15 左边间距15
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(15, statusBarAndNavBarHeight + 25, 50, 50)];
    [self.view addSubview:headView];
    headView.backgroundColor = RGBColor(3, 29, 64, 1);
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 25;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -5, 40, 56)];
    imageView.clipsToBounds = YES;
    [imageView yy_setImageWithURL:[NSURL URLWithString:[TLStorage getUserPhoto]] placeholder:[UIImage imageNamed:@"ic_default"] options:YYWebImageOptionUseNSURLCache progress:nil transform:nil completion:nil];
    [headView addSubview:imageView];
      
    [self.view addSubview: [UILabel addLabelWithText:[TLStorage getUsername] textColor:SYSTEM_COLOR frame:CGRectMake(80, statusBarAndNavBarHeight + 30, 160, 30)]];
    [self.view addSubview: [UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, statusBarAndNavBarHeight + 90, screenWidth, 10)]];
    [self changePwdView];
    [self.view addSubview: [UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, statusBarAndNavBarHeight + 150, screenWidth, 10)]];
    [self quitBtn];
    [self.view addSubview: [UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, statusBarAndNavBarHeight + 210, screenWidth, 10)]];
}

#pragma mark - private methods

#pragma mark - actions
- (void)changePwdViewTapAction:(UITapGestureRecognizer *)tap {

    TLChangePwdViewController *changePwdVc = [[TLChangePwdViewController alloc] init];
    [self.navigationController pushViewController:changePwdVc animated:YES];
}

- (void)quitBtnAction:(UIButton *)sender {
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:@{@"userId":[TLStorage getUserId]} withURL:TLRequestUrlUserLogout responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            MyLog(@"注销成功");
            TLLoginViewController *loginVc = [[TLLoginViewController alloc] init];
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
             [[[UIApplication sharedApplication] delegate] window].rootViewController = loginNav;
        } else {
            [TLAlert showMessage:@"注销失败" hideDelay:3 inView:strongSelf.view];
        }
        
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        [TLAlert showMessage:@"注销失败，请稍后重试" hideDelay:3 inView:strongSelf.view];
    }];
}

#pragma mark - lazy loading
- (UIView *)changePwdView {

    if (!_changePwdView) {
        _changePwdView = [[UIView alloc]initWithFrame:CGRectMake(0, statusBarAndNavBarHeight + 100, screenWidth, 50)];
        [self.view addSubview:_changePwdView];
        _changePwdView.userInteractionEnabled = YES;
        UITapGestureRecognizer *changePwdViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePwdViewTapAction:)];
        [_changePwdView addGestureRecognizer:changePwdViewTap];
        
        [_changePwdView addSubview:[UILabel addLabelWithText:@"修改密码" textColor:[UIColor whiteColor] frame:CGRectMake(paddingK, 10, 100, 30)]];
        [_changePwdView addSubview:[UIImageView addImageViewWithImageName:@"ic_right" frame:CGRectMake(screenWidth - 30, 15, 15, 20)]];
    }
    return _changePwdView;
}

- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _quitBtn.frame = CGRectMake(paddingK, statusBarAndNavBarHeight + 160, screenWidth - 20, 50);
        _quitBtn.titleLabel.font = FONT(18);
        _quitBtn.backgroundColor = [UIColor clearColor];
        _quitBtn.layer.masksToBounds = YES;
        _quitBtn.layer.cornerRadius = 5;
        [_quitBtn setTitle:@"注销" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:Saffron_Yellow_COLOR forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(quitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_quitBtn];
    }
    return _quitBtn;
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
