//
//  TLMyTaskTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLMyTaskTableViewCell.h"

NSString *TLMyTaskTableViewCellIdentifier = @"TLMyTaskTableViewCellIdentifier";

@interface TLMyTaskTableViewCell ()

{
    MyTaskModel *_myTaskModel;
}

@property (nonatomic, strong) UIImageView *taskstatusImageView;
@property (nonatomic, strong) UILabel *tasknameLabel;
@property (nonatomic, strong) UILabel *carryoutTimeLabel;//执行时间
@property (nonatomic, strong) UILabel *planstarttimeLabel;
@property (nonatomic, strong) UILabel *planendtimeLabel;
@property (nonatomic, strong) UILabel *operateLabel;//ex:点击开始 点击完成、重新开始、待验收



@end

@implementation TLMyTaskTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}


- (void)initUI {
    
    CGFloat contentViewHeight = 200;
    
    //阴影
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, contentViewHeight - paddingK, screenWidth, paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(0, 0, 5, contentViewHeight - paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(screenWidth - 5, 0, 5, contentViewHeight - paddingK)]];
    
    //横线
    [self.contentView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(5, 115, (screenWidth - 130)/2, 1)]];
    [self.contentView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(screenWidth - (screenWidth - 130)/2 - 5, 115, (screenWidth - 130)/2, 1)]];
    
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"ic_loca" frame:CGRectMake((screenWidth - 90)/2, 15, 20, 20)]];
    [self.contentView addSubview:[UILabel addLabelWithText:@"网格任务" textColor:Work_label_textColor frame:CGRectMake((screenWidth - 90)/2 + 25, 15, 70, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
    [self.contentView addSubview:[UILabel addLabelWithText:@"执行时间" textColor:Work_label_textColor frame:CGRectMake(screenWidth - 10 - 80, 15, 80, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
    
    [self taskstatusImageView];
    [self tasknameLabel];
    [self carryoutTimeLabel];
    [self operateLabel];
    
    [self.contentView addSubview:[UILabel addLabelWithText:@"计划时间" textColor:Work_label_textColor frame:CGRectMake(120, CGRectGetMaxY(self.operateLabel.frame) + 15, screenWidth - 240, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
    
    [self planstarttimeLabel];
    [self planendtimeLabel];
    
}

- (void)setupMyTaskCellWithMyTaskModel:(MyTaskModel *)model {

    _myTaskModel = model;
    self.tasknameLabel.text = model.taskname;
    [self setupImageViewAndOperateLabelWithStutas:model.taskstatus];
    [self setupCarryoutTime];
    
    self.planstarttimeLabel.text = [self monthAndDayAndHourAndMinWithDate:model.planstarttime];
    self.planendtimeLabel.text = [self monthAndDayAndHourAndMinWithDate:model.planendtime];
    
    if ([model.taskstatus isEqualToString:@"0"]) {
        self.backgroundColor = RGBColor(153, 102, 0, 1);
    } else {
        self.backgroundColor = SYSTEM_TabBar_COLOR;
    }
}

- (void)setupCarryoutTime {
    
    NSString *realstarttime = _myTaskModel.realstarttime;
    if ([realstarttime isEqualToString:@"-- --"] || [realstarttime isEqualToString:@""]) {
        self.carryoutTimeLabel.text = @"0分";
        self.carryoutTimeLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSInteger realstarttimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:realstarttime] inFormat:IIDateFormat2] integerValue];
    NSInteger carryoutTimeTimeStamp = 0;
    
    if ([_myTaskModel.taskstatus isEqualToString:@"1"]) {
        NSString *currentTime = [IIDate getStringFromDate:[NSDate new] ofFormat:IIDateFormat2 timeZone:[NSTimeZone localTimeZone]];
        carryoutTimeTimeStamp = [[IIDate getTimestampFromString:currentTime inFormat:IIDateFormat2] integerValue];
    } else if ([_myTaskModel.taskstatus isEqualToString:@"2"] ) {
        carryoutTimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:_myTaskModel.realendtime] inFormat:IIDateFormat2] integerValue];
    }
    
    NSString *carryoutTime = [NSString stringWithFormat:@"%ld分", (carryoutTimeTimeStamp - realstarttimeTimeStamp)/60];
    
    self.carryoutTimeLabel.text = carryoutTime;
    self.carryoutTimeLabel.textColor = SYSTEM_COLOR;
    
}

- (NSString *)yearToSecendWithDate:(NSString *)date {
    //2017-11-14 16:13:00.0
    NSString *timeStr = @"0";
    NSArray *timeArray = [date componentsSeparatedByString:@"."];
    if (timeArray.count == 2) {
        timeStr = [timeArray firstObject];
    }
    return timeStr;
}

- (NSString *)monthAndDayAndHourAndMinWithDate:(NSString *)date {
    
    //2017-11-14 16:13:00.0 截取第5位到15位
    NSString *timeStr = @"";
    if (date && date.length > 15) {
        timeStr = [date substringWithRange:NSMakeRange(5, 11)];
    }
    return timeStr;
}

- (void)setupImageViewAndOperateLabelWithStutas:(NSString *)status {
    
    if ([status isEqualToString:@"0"]) {
        //未开始
        self.taskstatusImageView.image = [UIImage imageNamed:@"ic_timeout_notyetstart"];
        self.operateLabel.text = @"点击开始";
        self.operateLabel.backgroundColor = [UIColor whiteColor];
    } else if ([status isEqualToString:@"1"]) {
        //进行中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.taskstatusImageView.image = image;
        self.operateLabel.text = @"点击完成";
        self.operateLabel.backgroundColor = SYSTEM_COLOR;
    } else if ([status isEqualToString:@"2"]) {
        //已完成/待验收
        self.taskstatusImageView.image = [UIImage imageNamed:@"ic_wait_pass"];
        self.operateLabel.text = @"待验收";
        self.operateLabel.backgroundColor = TextColor_GRAY;
    } else if ([status isEqualToString:@"3"]) {
        //验收通过
    } else if ([status isEqualToString:@"4"]) {
        //验收未通过
        self.taskstatusImageView.image = [UIImage imageNamed:@"ic_notPass"];
        self.operateLabel.text = @"重新开始";
        self.operateLabel.backgroundColor = Saffron_Yellow_COLOR;
    }
}

- (NSComparisonResult)currentDateCompareTime:(NSString *)time {
    
    NSString *date = [IIDate getStringFromDate:[NSDate new] ofFormat:IIDateFormat2 timeZone:[NSTimeZone localTimeZone]];
    NSComparisonResult result = [date compare:time];
    
    return result;
}

#pragma mark - actions
- (void)operateLabelTapAction:(UITapGestureRecognizer *)tap {

    if (![_myTaskModel.taskstatus isEqualToString:@"2"] && self.OperateLabelTapActionBlock) {
        NSString *changedStatus = @"0";
        if ([_myTaskModel.taskstatus isEqualToString:@"0"] || [_myTaskModel.taskstatus isEqualToString:@"4"]) {
            changedStatus = @"0";
        } else if ([_myTaskModel.taskstatus isEqualToString:@"1"]) {
            changedStatus = @"2";
        } 
        self.OperateLabelTapActionBlock(_myTaskModel, changedStatus);
    }
}

#pragma mark - lazy loading
- (UIImageView *)taskstatusImageView {
    
    if (!_taskstatusImageView) {
        _taskstatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 45, 45)];
        _taskstatusImageView.layer.masksToBounds = YES;
        _taskstatusImageView.layer.cornerRadius = 22.5;
        [self.contentView addSubview:_taskstatusImageView];
    }
    
    return _taskstatusImageView;
}

- (UILabel *)tasknameLabel {
    if (!_tasknameLabel) {
        _tasknameLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(90, 50, screenWidth - 180, 30) font:[UIFont boldSystemFontOfSize:22] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_tasknameLabel];
    }
    
    return _tasknameLabel;
}

- (UILabel *)carryoutTimeLabel {
    if (!_carryoutTimeLabel) {
        _carryoutTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor redColor] frame:CGRectMake(screenWidth - 10 - 80, 50, 80, 30) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_carryoutTimeLabel];
    }
    return _carryoutTimeLabel;
}


- (UILabel *)operateLabel {
    if (!_operateLabel) {
        _operateLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 120)/2, CGRectGetMaxY(self.tasknameLabel.frame) + 15, 120, 40)];
        _operateLabel.backgroundColor = [UIColor whiteColor];
        _operateLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _operateLabel.layer.borderWidth = 2;
        _operateLabel.layer.masksToBounds = YES;
        _operateLabel.layer.cornerRadius = 20;
        _operateLabel.font = [UIFont boldSystemFontOfSize:16];
        _operateLabel.textColor = [UIColor blackColor];
        _operateLabel.textAlignment = NSTextAlignmentCenter;
        
        _operateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operateLabelTapAction:)];
        [_operateLabel addGestureRecognizer:tap];
        [self.contentView addSubview:_operateLabel];
    }
    return _operateLabel;
}

- (UILabel *)planstarttimeLabel {
    if (!_planstarttimeLabel) {
        _planstarttimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(paddingK, CGRectGetMaxY(self.operateLabel.frame) + paddingK, 110, 20) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_planstarttimeLabel];
    }
    return _planstarttimeLabel;
}

- (UILabel *)planendtimeLabel {
    if (!_planendtimeLabel) {
        _planendtimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth - 120, CGRectGetMaxY(self.operateLabel.frame) + paddingK, 110, 20) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_planendtimeLabel];
    }
    return _planendtimeLabel;
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
