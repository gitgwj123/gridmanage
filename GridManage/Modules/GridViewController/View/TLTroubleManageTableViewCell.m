//
//  TLTroubleManageTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLTroubleManageTableViewCell.h"

NSString *TLTroubleManageTableViewCellIdentifier = @"TLTroubleManageTableViewCellIdentifier";
static NSInteger const deviceNameLabelWidth = 70;
static NSInteger const contentViewHeight = 250;


@interface TLTroubleManageTableViewCell ()

{
    UIColor *_bgViewColor;
    UIColor *_btnColor;
    TroubleManageModel *_troubleManageModel;
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *deviceNameLabel;//设备名称
@property (nonatomic, strong) UILabel *submitTimeLabel;//提交时间
@property (nonatomic, strong) UILabel *areaNameLabel;//地点
@property (nonatomic, strong) UILabel *taktypeLabel;//等级
@property (nonatomic, strong) UILabel *subclassLabel;//子类
@property (nonatomic, strong) UILabel *notesLabel;//描述
@property (nonatomic, strong) UILabel *taskstatusLabel;//任务状态

@property (nonatomic, strong) UIButton *notPassBtn;
@property (nonatomic, strong) UIButton *passBtn;


@end

@implementation TLTroubleManageTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self initUI];
    }
    return self;
}

#pragma mark - UI
- (void)initUI {
    
    //阴影
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, contentViewHeight - paddingK, screenWidth, paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(0, 0, 5, contentViewHeight - paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(screenWidth - 5, 0, 5, contentViewHeight - paddingK)]];
    
    [self bgView];
    
}


- (void)setupTroubleManageCellWithTroubleManageModel:(TroubleManageModel *)troubleManageModel {
    _troubleManageModel = troubleManageModel;
    NSArray *tasknameArr = [_troubleManageModel.taskname componentsSeparatedByString:@" "];
    if (tasknameArr.count >= 2) {
        self.deviceNameLabel.text = tasknameArr[0];
        self.subclassLabel.text = tasknameArr[1];
    }
    
    self.submitTimeLabel.text = [self getSubmitTimeLabelTextWithTime:_troubleManageModel.planstarttime];
    self.areaNameLabel.text = _troubleManageModel.areaname;
    self.taktypeLabel.text = _troubleManageModel.taktype;
    self.notesLabel.text = _troubleManageModel.notes;
    
    self.taskstatusLabel.attributedText = [self getTaskstatusLabelTextWithStatus:_troubleManageModel.taskstatus];
    
    self.bgView.backgroundColor = _bgViewColor;
    self.notPassBtn.backgroundColor = _btnColor;
    self.passBtn.backgroundColor = _btnColor;

}

- (NSAttributedString *)getTaskstatusLabelTextWithStatus:(NSString *)status {

    NSString *taskstatus = @"";
    UIColor *textColor;
    if ([status isEqualToString:@"0"]) {
        taskstatus = @"未开始";
        textColor = RGBColor(277, 36, 36, 1);
        _bgViewColor = RGBColor(90, 27, 34, 1);
        _btnColor = [UIColor grayColor];
    } else if ([status isEqualToString:@"2"]) {
        taskstatus = @"待验收";
        textColor = SYSTEM_COLOR;
        _bgViewColor = SYSTEM_Background_COLOR;
        _btnColor = Saffron_Yellow_COLOR;
    } else if ([status isEqualToString:@"4"]) {
        taskstatus = @"验收未通过";
        textColor = RGBColor(212, 202, 34, 1);
        _bgViewColor = RGBColor(86, 56, 15, 1);
        _btnColor = [UIColor grayColor];
    }
    
    NSAttributedString *taskstatusAttributedString = [NSString getNewStringWithRange:NSMakeRange(0, taskstatus.length) string:taskstatus color:textColor];
    
    return taskstatusAttributedString;
}

- (NSString *)getSubmitTimeLabelTextWithTime:(NSString *)time {

    //  planstarttime = "2017-11-08 10:37:06.0";
    NSString *submitTime = @"";
    if (![time isEqualToString:@""]) {
        submitTime = [time substringToIndex:16];
    }
    return submitTime;
}

#pragma mark - actions
- (void)notPassBtnAction:(UIButton *)sender {

    if (self.troubleManageCellBtnBlock && [_troubleManageModel.taskstatus isEqualToString:@"2"]) {
        self.troubleManageCellBtnBlock(_troubleManageModel, @"3");
    }
}

- (void)passBtnAction:(UIButton *)sender {
    
    if (self.troubleManageCellBtnBlock && [_troubleManageModel.taskstatus isEqualToString:@"2"]) {
        self.troubleManageCellBtnBlock(_troubleManageModel, @"5");
    }
}

#pragma mark - lazy loading
- (UIView *)bgView {

    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, screenWidth - paddingK, contentViewHeight - paddingK)];
        _bgView.backgroundColor = RGBColor(145, 17, 31, 1);
        [self.contentView addSubview:_bgView];
        
        [_bgView addSubview:[UILabel addLabelWithText:@"设备名称:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        [_bgView addSubview:[UILabel addLabelWithText:@"提交时间:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, 20 + 2 * paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        [_bgView addSubview:[UILabel addLabelWithText:@"地        点:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, 20 * 2 + 3 * paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        [_bgView addSubview:[UILabel addLabelWithText:@"等        级:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, 20 * 3 + 4 * paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        [_bgView addSubview:[UILabel addLabelWithText:@"子        类:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, 20 * 4 + 5 * paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        [_bgView addSubview:[UILabel addLabelWithText:@"描        述:" textColor:TextColor_GRAY frame:CGRectMake(paddingK, 20 * 5 + 6 * paddingK, deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft]];
        
        [self deviceNameLabel];
        [self submitTimeLabel];
        [self areaNameLabel];
        [self taktypeLabel];
        [self subclassLabel];
        [self notesLabel];
        [self taskstatusLabel];
        
        [self notPassBtn];
        [self passBtn];

    }
    return _bgView;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(paddingK + deviceNameLabelWidth + paddingK, paddingK, screenWidth - 15 - deviceNameLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_deviceNameLabel];
    }
    
    return _deviceNameLabel;
}

- (UILabel *)submitTimeLabel {
    if (!_submitTimeLabel) {
        _submitTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNameLabel.frame), CGRectGetMaxY(self.deviceNameLabel.frame) + paddingK, CGRectGetWidth(self.deviceNameLabel.frame), 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_submitTimeLabel];
    }
    
    return _submitTimeLabel;
}

- (UILabel *)areaNameLabel {
    if (!_areaNameLabel) {
        _areaNameLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNameLabel.frame),CGRectGetMaxY(self.submitTimeLabel.frame) + paddingK, CGRectGetWidth(self.deviceNameLabel.frame), 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_areaNameLabel];
    }
    
    return _areaNameLabel;
}

- (UILabel *)taktypeLabel {
    if (!_taktypeLabel) {
        _taktypeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNameLabel.frame),CGRectGetMaxY(self.areaNameLabel.frame) + paddingK, CGRectGetWidth(self.deviceNameLabel.frame), 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_taktypeLabel];
    }
    
    return _taktypeLabel;
}

- (UILabel *)subclassLabel {
    if (!_subclassLabel) {
        _subclassLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNameLabel.frame),CGRectGetMaxY(self.taktypeLabel.frame) + paddingK, CGRectGetWidth(self.deviceNameLabel.frame), 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_subclassLabel];
    }
    
    return _subclassLabel;
}
- (UILabel *)notesLabel {
    if (!_notesLabel) {
        _notesLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNameLabel.frame),CGRectGetMaxY(self.subclassLabel.frame) + paddingK, CGRectGetWidth(self.deviceNameLabel.frame), 20) font:FONT(14) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_notesLabel];
    }
    
    return _notesLabel;
}
- (UILabel *)taskstatusLabel {
    if (!_taskstatusLabel) {
        _taskstatusLabel = [UILabel addLabelWithText:@"" textColor:RGBColor(277, 36, 36, 1) frame:CGRectMake(paddingK, CGRectGetMaxY(self.notesLabel.frame) + paddingK + 5, 110, 30) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.bgView addSubview:_taskstatusLabel];
    }
    
    return _taskstatusLabel;
}


- (UIButton *)notPassBtn {
    if (!_notPassBtn) {
        _notPassBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _notPassBtn.frame = CGRectMake(screenWidth - 3 * paddingK - 2 * 80, contentViewHeight - 2 * paddingK - 40, 80, 40);
        _notPassBtn.titleLabel.font = FONT(18);
        _notPassBtn.layer.masksToBounds = YES;
        _notPassBtn.layer.cornerRadius = 5;
        _notPassBtn.backgroundColor = [UIColor grayColor];//待验收时背景改为橘黄色
        [_notPassBtn setTitle:@"未通过" forState:UIControlStateNormal];
        [_notPassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_notPassBtn addTarget:self action:@selector(notPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_notPassBtn];
    }
    
    return _notPassBtn;
}

- (UIButton *)passBtn {
    if (!_passBtn) {
        _passBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _passBtn.frame = CGRectMake(screenWidth - 2 * paddingK - 80, contentViewHeight - 2 * paddingK - 40, 80, 40);
        _passBtn.titleLabel.font = FONT(18);
        _passBtn.layer.masksToBounds = YES;
        _passBtn.layer.cornerRadius = 5;
        _passBtn.backgroundColor = [UIColor grayColor];//待验收时背景改为橘黄色
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        [_passBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_passBtn addTarget:self action:@selector(passBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_passBtn];
    }
    
    return _passBtn;
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
