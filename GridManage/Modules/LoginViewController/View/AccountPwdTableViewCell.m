//
//  AccountPwdTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/14.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "AccountPwdTableViewCell.h"

NSString *AccountPwdTableViewCellIdentifier = @"AccountPwdTableViewCellIdentifier";

@interface AccountPwdTableViewCell ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *accountNameLabel;
@property (nonatomic, strong) UIButton *deleteBtn;


@end

@implementation AccountPwdTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}


- (void)initUI {

    [self headView];
    [self accountNameLabel];
    [self deleteBtn];
    
}


- (void)setupAccountPwdTableViewCellWithImageUrl:(NSString *)imageUrl accountName:(NSString *)accountName {

    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"ic_default"]];
    self.accountNameLabel.text = accountName;
}


#pragma mark - action
- (void)deleteBtnAction:(UIButton *)sender {

    if (self.accountPwdDeleteActionblock) {
        self.accountPwdDeleteActionblock(self.accountNameLabel.text);
    }
}

#pragma mark - lazy loading

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(paddingK, 5, 30, 30)];
        [self.contentView addSubview:_headView];
        _headView.backgroundColor = RGBColor(3, 29, 64, 1);
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 15;
        
        [self headImageView];
    }
    return _headView;
}

- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, -3, 25, 35)];
        _headImageView.clipsToBounds = YES;
        [self.headView addSubview:_headImageView];
    }
    
    return _headImageView;
}

- (UILabel *)accountNameLabel {
    if (!_accountNameLabel) {
        _accountNameLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(CGRectGetMaxX(self.headView.frame) + paddingK, paddingK, 110, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_accountNameLabel];
    }
    
    return _accountNameLabel;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = CGRectMake(screenWidth - 120, 10, 20, 20);
        _deleteBtn.backgroundColor = [UIColor clearColor];
        [_deleteBtn setImage:[[UIImage imageNamed:@"ic_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
