//
//  TLLoginConfigViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLLoginConfigViewController.h"

static NSInteger const ipAddressLabelWidth = 80;

@interface TLLoginConfigViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView      *inputView;
@property (nonatomic, strong) UITextField *ipAddressField;
@property (nonatomic, strong) UITextField *portNUmField;
@property (nonatomic, strong) UIButton    *confirmBtn;

@end

@implementation TLLoginConfigViewController

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [self loginConfigVcPopViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录配置";
    
    [self inputView];
    [self confirmBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
#warning 检测IP 和端口号
- (void) loginConfigVcPopViewController {

    if (!self.ipAddressField.text) {
        //alert
        return;
    }
    
    
    if (!self.portNUmField.text) {
        //alert
        return;
    }
    
    NSString *base_url = [NSString stringWithFormat:@"http://%@:%@", self.ipAddressField.text, self.portNUmField.text];
    [TLStorage setbase_URL:base_url];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - actions
- (void)confirmBtnAction:(UIButton *)sender {

    [self loginConfigVcPopViewController];
    
}

#pragma  mark - lazy loading
- (UIView *)inputView {
    
    if (!_inputView) {
        
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, screenWidth, 100)];
        [self.view addSubview:_inputView];
        
        [_inputView addSubview:self.ipAddressField];
        [_inputView addSubview:self.portNUmField];
      
        [self addLabels];
    }
    return _inputView;
}

- (UITextField *)ipAddressField {
    
    if (!_ipAddressField) {
        _ipAddressField = [[UITextField alloc] initWithFrame:CGRectMake(paddingK + ipAddressLabelWidth, 0, screenWidth - paddingK - ipAddressLabelWidth, 30)];
        _ipAddressField.delegate = self;
        _ipAddressField.backgroundColor = [UIColor clearColor];
        _ipAddressField.font = FONT(20);
        _ipAddressField.placeholder = @"请输入IP地址";
        _ipAddressField.text = @"172.16.0.17";
        _ipAddressField.textColor = [UIColor whiteColor];
    }
    return _ipAddressField;
}


- (UITextField *)portNUmField {
    
    if (!_portNUmField) {
        _portNUmField = [[UITextField alloc] initWithFrame:CGRectMake(paddingK + ipAddressLabelWidth, 50, screenWidth - paddingK - ipAddressLabelWidth, 30)];
        _portNUmField.delegate = self;
        _portNUmField.backgroundColor = [UIColor clearColor];
        _portNUmField.font = FONT(20);
        _portNUmField.placeholder = @"请输入端口号";
        _portNUmField.text = @"9611";
        _portNUmField.textColor = [UIColor whiteColor];
    }
    return _portNUmField;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(paddingK, CGRectGetMaxY(self.inputView.frame) + 20, screenWidth - 20, 44);
        _confirmBtn.titleLabel.font = FONT(18);
        _confirmBtn.backgroundColor = Saffron_Yellow_COLOR;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmBtn];
    }
    
    return _confirmBtn;
}

- (void)addLabels {
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, 0, ipAddressLabelWidth, 30)];
    userLabel.text = @"IP地址";
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.textColor = RGBColor(184, 184, 184, 1);
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.font = FONT(20);
    [self.inputView addSubview:userLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMinY(self.portNUmField.frame), ipAddressLabelWidth, 30)];
    pwdLabel.text = @"端口号";
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = RGBColor(184, 184, 184, 1);
    pwdLabel.textAlignment = NSTextAlignmentLeft;
    pwdLabel.font = FONT(20);
    [self.inputView addSubview:pwdLabel];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMaxY(self.ipAddressField.frame) + 5, screenWidth - paddingK, 1)];
    line1.text = @"";
    line1.backgroundColor = RGBColor(184, 184, 184, 1);
    [self.inputView addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, CGRectGetMaxY(self.portNUmField.frame) + 5, screenWidth - paddingK, 1)];
    line2.text = @"";
    line2.backgroundColor = RGBColor(184, 184, 184, 1);
    [self.inputView addSubview:line2];
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
