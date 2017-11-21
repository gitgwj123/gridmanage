//
//  TLLoginViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLLoginViewController.h"
#import "TLLoginConfigViewController.h"
#import "TLTabBarController.h"
#import "TLAccountPwdManager.h"
#import "AccountPwdTableViewCell.h"

static NSInteger const userLabelWidth = 70;
static NSInteger const displayTableViewHeight = 150;

@interface TLLoginViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

{
    BOOL _isFromTextField;
}

@property (nonatomic, strong) UIView      *headView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView      *inputView;
@property (nonatomic, strong) UITextField *userField;
@property (nonatomic, strong) UITextField *pwdField;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *loginConfigBtn;

@property (nonatomic, strong) UIButton *chooseAccountBtn;
@property (nonatomic, strong) NSMutableArray *accountPwdArray;

@end

@implementation TLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    _isFromTextField = YES;
    [self setNavigationBarTitleColor:SYSTEM_COLOR fontSize:18];
    
    if (![TLStorage getbase_URL]) {
        [TLStorage setbase_URL:@"http://172.16.6.11:9611"];
    }
    
    [self headView];
    [self inputView];
    [self loginBtn];
    [self loginConfigBtn];
    
    [self configDisplayTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    NSString *userPhoto = [TLStorage getUserPhoto];
    UIImage *image = [UIImage imageNamed:@"ic_default"];
    if (userPhoto) {
        [self.headImageView yy_setImageWithURL:[NSURL URLWithString:userPhoto] placeholder:image options:YYWebImageOptionUseNSURLCache progress:nil transform:nil completion:nil];
        self.headView.backgroundColor = RGBColor(3, 29, 64, 1);
    } else {
        self.headImageView.image = image;
        self.headView.backgroundColor = RGBColor(37, 37, 37, 1);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (![[touches anyObject].view isKindOfClass:[self.displayTableView class]]) {
        if (self.displayTableView.hidden == NO) {
            [self.displayTableView setHidden:YES];
            return;
        }
    }
    
    if (![[touches anyObject].view isKindOfClass:[UITextField class]]) {
        if (self.userField.editing == YES) {
            [self.userField resignFirstResponder];
            return;
        }
        
        if (self.pwdField.editing == YES) {
            [self.pwdField resignFirstResponder];
            return;
        }
    }
}

#pragma mark - action
- (void)loginBtnAction:(UIButton *)sender {
    
    if (!self.displayTableView.hidden) {
        [self hideDisPlayTableView];
    }
    
    [self requestLogin];
}


- (void)loginConfigBtnAction:(UIButton *)sender {
    
    if (!self.displayTableView.hidden) {
        [self hideDisPlayTableView];
    }
    
    TLLoginConfigViewController *loginConfigvc = [[TLLoginConfigViewController alloc] init];
    [self.navigationController pushViewController:loginConfigvc animated:YES];
}

- (void)chooseAccountBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.userField.editing ==YES) {
        [self.userField resignFirstResponder];
    }
    if (self.pwdField.editing == YES) {
        [self.pwdField resignFirstResponder];
    }
    NSArray *array = [[TLAccountPwdManager sharedManager] getAllAccountPwd];
    if (array.count == 0) {
        return;
    }
    
    if (sender.selected) {
        [sender setImage:[[UIImage imageNamed:@"ic_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [self showdisplayTableViewWithAccountAccountPwd:array];
        
    } else {
        [sender setImage:[[UIImage imageNamed:@"ic_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.displayTableView setHidden:YES];
    }
}

- (void)showdisplayTableViewWithAccountAccountPwd:(NSArray *)array {
    if (self.accountPwdArray.count > 0) {
        [self.accountPwdArray removeAllObjects];
    }
    
    self.accountPwdArray = [NSMutableArray arrayWithArray:array];
    NSInteger height = self.accountPwdArray.count * 40;
    if (height > displayTableViewHeight) {
        height = displayTableViewHeight;
    }
    self.displayTableView.frame = CGRectMake(CGRectGetMinX(self.userField.frame) - paddingK, CGRectGetMinY(self.inputView.frame) + 38, screenWidth - CGRectGetMinX(self.userField.frame) - paddingK, height);
    
    [self.displayTableView setHidden:NO];
    [self.displayTableView reloadData];

}

#pragma mark - private methods

- (void)configDisplayTableView {
    
    self.displayTableView.frame = CGRectMake(CGRectGetMinX(self.userField.frame) - paddingK, CGRectGetMinY(self.inputView.frame) + 38, screenWidth - CGRectGetMinX(self.userField.frame) - paddingK, 150);
    self.displayTableView.backgroundColor = SYSTEM_TabBar_COLOR;
    self.displayTableView.hidden = YES;
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    [self.displayTableView registerClass:[AccountPwdTableViewCell class] forCellReuseIdentifier:AccountPwdTableViewCellIdentifier];
}

- (void)hideDisPlayTableView {
    
    [self.chooseAccountBtn setImage:[[UIImage imageNamed:@"ic_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.displayTableView setHidden:YES];
}

- (void)storageUserInfoWithData:(NSDictionary *)data {

    [TLStorage setUserId:data[@"userId"]];
    [TLStorage setToken:data[@"token"]];
    [TLStorage setTeamId:data[@"teamId"]];
    [TLStorage setUsername:data[@"user"][@"username"]];
    [TLStorage setUserPhoto:data[@"user"][@"photo"]];
}

- (void)updateAccountPwdAndReloadTableViewWithAccount:(NSString *)account {

    [[TLAccountPwdManager sharedManager] deleteAccountPwdWithAccount:account];
    [self.accountPwdArray removeAllObjects];
    
    NSArray *result = [[TLAccountPwdManager sharedManager] getAllAccountPwd];
    self.displayTableView.frame = CGRectMake(CGRectGetMinX(self.userField.frame) - paddingK, CGRectGetMinY(self.inputView.frame) + 38, screenWidth - CGRectGetMinX(self.userField.frame) - paddingK, 40 * result.count);
    if (result.count == 0) {
        [self hideDisPlayTableView];
    } else {
        self.accountPwdArray = [NSMutableArray arrayWithArray:result];
        [self.displayTableView reloadData];
    }
}


#pragma mark delegate
//textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
    _isFromTextField = YES;
    
    if (!self.displayTableView.hidden) {
        [self hideDisPlayTableView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //    if (textField == self.userField && range.location >= 11) {
    //        return NO;
    //    } else if (textField == self.pwdField && range.location >= 16) {
    //        return NO;
    //    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.userField]) {
        [self.pwdField becomeFirstResponder];
    }
    
    if ([textField isEqual:self.pwdField]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountPwdArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountPwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountPwdTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[AccountPwdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AccountPwdTableViewCellIdentifier];
    }
    NSDictionary *dic = self.accountPwdArray[indexPath.row];
    [cell setupAccountPwdTableViewCellWithImageUrl:dic[@"imageUrl"] accountName:dic[@"account"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.accountPwdDeleteActionblock = ^(NSString *accountName) {
      //delete account
        [weakSelf updateAccountPwdAndReloadTableViewWithAccount:accountName];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hideDisPlayTableView];
    
    NSDictionary *dic = self.accountPwdArray[indexPath.row];
    self.userField.text = dic[@"account"];
    self.pwdField.text = dic[@"pwd"];
    _isFromTextField = NO;
}


#pragma mark - network
- (void)requestLogin {
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:@{@"account":self.userField.text, @"pwd":self.pwdField.text, @"ssId":@"66666", @"device":@"1"} withURL:TLRequestUrlUserLogin responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
 
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            TLTabBarController *tabBarController = [[TLTabBarController alloc] init];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = tabBarController;
            
            [TLStorage setHash:hash];
            [strongSelf storageUserInfoWithData:(NSDictionary *)data];
            if (_isFromTextField) {
                [[TLAccountPwdManager sharedManager] saveAccountPwdWithAccountPwdDictionary:@{@"account":self.userField.text, @"pwd":self.pwdField.text, @"imageUrl":data[@"user"][@"photo"]}];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.headView.backgroundColor = RGBColor(3, 29, 64, 1);
                [strongSelf.headImageView yy_setImageWithURL:[NSURL URLWithString:data[@"user"][@"photo"]] options:YYWebImageOptionUseNSURLCache];
            });
            
        } else {
            [TLAlert showMessage:@"登录失败" hideDelay:2 inView:strongSelf.view];
        }
        
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
         [TLAlert showMessage:@"登录失败，请稍后重试" hideDelay:2 inView:strongSelf.view];
        
    }];
}



#pragma  mark - lazy loading
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 50)/2, 150, 60, 60)];
        [self.view addSubview:_headView];
        _headView.backgroundColor = RGBColor(37, 37, 37, 1);//灰色
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 30;
        
        [self headImageView];
    }
    return _headView;
}

- (UIImageView *)headImageView {

    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -5, 50, 70)];
        _headImageView.clipsToBounds = YES;
        [self.headView addSubview:_headImageView];
    }
    
    return _headImageView;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) + 30, screenWidth, 100)];
        [self.view addSubview:_inputView];
        
        [self userField];
        [self pwdField];
        [self chooseAccountBtn];
        
        [self addLabels];
    }
    return _inputView;
}

- (UITextField *)userField {

    if (!_userField) {
        _userField = [[UITextField alloc] initWithFrame:CGRectMake(paddingK + userLabelWidth, 0, screenWidth - paddingK - userLabelWidth - 60, 30)];
        _userField.delegate = self;
        _userField.backgroundColor = [UIColor clearColor];
        _userField.font = FONT(20);
        _userField.textColor = [UIColor whiteColor];
        [self.inputView addSubview:self.userField];
    }
    return _userField;
}


- (UITextField *)pwdField {
    
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(paddingK + userLabelWidth, 50, screenWidth - paddingK - userLabelWidth - 60, 30)];
        _pwdField.delegate = self;
        _pwdField.backgroundColor = [UIColor clearColor];
        _pwdField.secureTextEntry = YES;
        _pwdField.font = FONT(20);
        _pwdField.textColor = [UIColor whiteColor];
        [self.inputView addSubview:self.pwdField];
    }
    return _pwdField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginBtn.frame = CGRectMake(paddingK, CGRectGetMaxY(self.inputView.frame) + 20, screenWidth - 20, 44);
        _loginBtn.titleLabel.font = FONT(18);
        _loginBtn.backgroundColor = SYSTEM_COLOR;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 5;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
    }
    
    return _loginBtn;
}

- (UIButton *)loginConfigBtn {
    if (!_loginConfigBtn) {
        _loginConfigBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginConfigBtn.frame = CGRectMake(paddingK, screenHeight - 80, screenWidth - 20, 44);
        _loginConfigBtn.titleLabel.font = FONT(18);
        _loginConfigBtn.backgroundColor = [UIColor clearColor];
        [_loginConfigBtn setTitle:@"登录配置" forState:UIControlStateNormal];
        [_loginConfigBtn setTitleColor:RGBColor(246, 246, 246, 1) forState:UIControlStateNormal];
        [_loginConfigBtn addTarget:self action:@selector(loginConfigBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginConfigBtn];
    }
    
    return _loginBtn;
}


- (void)addLabels {
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, 0, userLabelWidth, 30)];
    userLabel.text = @"账号";
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.textColor = RGBColor(184, 184, 184, 1);
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.font = FONT(20);
    [self.inputView addSubview:userLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMinY(self.pwdField.frame), userLabelWidth, 30)];
    pwdLabel.text = @"密码";
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = RGBColor(184, 184, 184, 1);
    pwdLabel.textAlignment = NSTextAlignmentLeft;
    pwdLabel.font = FONT(20);
    [self.inputView addSubview:pwdLabel];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMaxY(self.userField.frame) + 5, screenWidth - paddingK, 1)];
    line1.text = @"";
    line1.backgroundColor = RGBColor(184, 184, 184, 1);
    [self.inputView addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMaxY(self.pwdField.frame) + 5, screenWidth - paddingK, 1)];
    line2.text = @"";
    line2.backgroundColor = RGBColor(184, 184, 184, 1);
    [self.inputView addSubview:line2];
}

- (UIButton *)chooseAccountBtn {
    if (!_chooseAccountBtn) {
        _chooseAccountBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _chooseAccountBtn.frame = CGRectMake(screenWidth - 50, 0, 30, 30);
        _chooseAccountBtn.backgroundColor = [UIColor clearColor];
        _chooseAccountBtn.tintColor = [UIColor clearColor];
        [_chooseAccountBtn setImage:[[UIImage imageNamed:@"ic_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_chooseAccountBtn addTarget:self action:@selector(chooseAccountBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.inputView addSubview:_chooseAccountBtn];
    }
    return _chooseAccountBtn;
    
}


- (NSMutableArray *)accountPwdArray {

    if (!_accountPwdArray) {
        _accountPwdArray = [[NSMutableArray alloc] init];
    }
    return _accountPwdArray;
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
