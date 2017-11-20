//
//  TLChangePwdViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLChangePwdViewController.h"

static NSInteger const pwdLabelWidth_ChangePwd = 80;

@interface TLChangePwdViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UITextField *orginalPwdField;
@property (nonatomic, strong) UITextField *changedPwdField;
@property (nonatomic, strong) UITextField *confirmPwdField;

@property (nonatomic, strong) UIButton *changeBtn;

@end

@implementation TLChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    
    [self inputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)changeBtnAction:(UIButton *)sender {

    [TLAlert showMessage:@"修改密码暂未开通" hideDelay:2 inView:self.view];
    
}

#pragma  mark - private methods

#pragma mark - lazy laoding
- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0,statusBarAndNavBarHeight, screenWidth, 100)];
        _inputView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_inputView];
       
        //阴影
        for (NSInteger i = 0; i < 5; i ++) {
            [_inputView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0,  paddingK + i * 50, screenWidth, paddingK)]];
        }
        
        NSArray *labelTextArray = @[@"原密码", @"新密码", @"确认密码"];
        for (NSInteger i = 0; i < 3; i ++) {
            [_inputView addSubview: [UILabel addLabelWithText:labelTextArray[i] textColor:TextColor_GRAY frame:CGRectMake(15, 25 + i * 60, pwdLabelWidth_ChangePwd, 20) font:FONT(18) alignment:NSTextAlignmentLeft]];
        }
        
        [self orginalPwdField];
        [self changedPwdField];
        [self confirmPwdField];
        [self changeBtn];
    }
    return _inputView;
}

- (UITextField *)orginalPwdField {
    
    if (!_orginalPwdField) {
        _orginalPwdField = [[UITextField alloc] initWithFrame:CGRectMake(15 + pwdLabelWidth_ChangePwd + paddingK, 25, screenWidth - pwdLabelWidth_ChangePwd - 25, 20)];
        _orginalPwdField.delegate = self;
        _orginalPwdField.backgroundColor = [UIColor clearColor];
        _orginalPwdField.font = FONT(20);
        _orginalPwdField.textColor = [UIColor whiteColor];
        [self.inputView addSubview:_orginalPwdField];
    }
    return _orginalPwdField;
}

- (UITextField *)changedPwdField {
    
    if (!_changedPwdField) {
        _changedPwdField = [[UITextField alloc] initWithFrame:CGRectMake(15 + pwdLabelWidth_ChangePwd + paddingK, CGRectGetMaxY(self.orginalPwdField.frame) + 40, screenWidth - pwdLabelWidth_ChangePwd - 25, 20)];
        _changedPwdField.delegate = self;
        _changedPwdField.backgroundColor = [UIColor clearColor];
        _changedPwdField.font = FONT(20);
        _orginalPwdField.textColor = [UIColor whiteColor];
        [self.inputView addSubview:_changedPwdField];
    }
    return _changedPwdField;
}

- (UITextField *)confirmPwdField {
    
    if (!_confirmPwdField) {
        _confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(15 + pwdLabelWidth_ChangePwd + paddingK, CGRectGetMaxY(self.changedPwdField.frame) + 40, screenWidth - pwdLabelWidth_ChangePwd - 25, 20)];
        _confirmPwdField.delegate = self;
        _confirmPwdField.backgroundColor = [UIColor clearColor];
        _confirmPwdField.font = FONT(20);
        _confirmPwdField.textColor = [UIColor whiteColor];
        [self.inputView addSubview:_confirmPwdField];
    }
    return _confirmPwdField;
}


- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeBtn.frame = CGRectMake(paddingK, CGRectGetMaxY(self.confirmPwdField.frame) + 30, screenWidth - 20, 40);
        _changeBtn.titleLabel.font = FONT(18);
        _changeBtn.backgroundColor = [UIColor clearColor];
        _changeBtn.layer.masksToBounds = YES;
        _changeBtn.layer.cornerRadius = 5;
        [_changeBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:Saffron_Yellow_COLOR forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.inputView addSubview:_changeBtn];
    }
    
    return _changeBtn;
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
