//
//  TaskMonitorTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TaskMonitorTableViewCell.h"

NSString *TLTaskMonitorTableViewCellIdentifier = @"TLTaskMonitorTableViewCellIdentifier";

@interface TaskMonitorTableViewCell ()

{
    TaskMonitorModel *_taskMonitorModel;
}

@property (nonatomic, strong) UIImageView *taskstatusImageView;
@property (nonatomic, strong) UILabel *tasknameLabel;
@property (nonatomic, strong) UILabel *carryoutTimeLabel;//执行时间
@property (nonatomic, strong) UILabel *planstarttimeLabel;
@property (nonatomic, strong) UILabel *planendtimeLabel;
@property (nonatomic, strong) UILabel *jobLabel;//1 ex:1个作业


@end

@implementation TaskMonitorTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBColor(146, 111, 39, 1);
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
    
    [self.contentView addSubview:[UILabel addLabelWithText:@"任务名称" textColor:Work_label_textColor frame:CGRectMake(100, 15, screenWidth - 200, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
    [self.contentView addSubview:[UILabel addLabelWithText:@"执行时间" textColor:Work_label_textColor frame:CGRectMake(screenWidth - 10 - 80, 15, 80, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
   
    [self taskstatusImageView];
    [self tasknameLabel];
    [self carryoutTimeLabel];
    [self jobLabel];
    
    [self.contentView addSubview:[UILabel addLabelWithText:@"计划时间" textColor:Work_label_textColor frame:CGRectMake(120, CGRectGetMaxY(self.jobLabel.frame) + 15, screenWidth - 240, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];

    [self planstarttimeLabel];
    [self planendtimeLabel];

}


- (void)setupPatrolCellWithTaskMonitorModel:(TaskMonitorModel *)model {

    _taskMonitorModel = model;
    
    [self setupImageViewWithStutas:model.taskstatus];
    
    NSString *taskName = model.taskname;
    NSArray *taskNameArr = [taskName componentsSeparatedByString:@" "];
    if (taskNameArr.count == 2) {
        self.tasknameLabel.text = [taskNameArr lastObject];
    }
    
    [self setupCarryoutTime];
    
    self.jobLabel.text = [NSString stringWithFormat:@"%@个作业", model.job];
    self.planstarttimeLabel.text = [self monthAndDayAndHourAndMinWithDate:model.planstarttime];
    self.planendtimeLabel.text = [self monthAndDayAndHourAndMinWithDate:model.planendtime];
    
}


- (void)setupCarryoutTime {

    NSString *realstarttime = _taskMonitorModel.realstarttime;
    if ([realstarttime isEqualToString:@"-- --"] || [realstarttime isEqualToString:@""]) {
        self.carryoutTimeLabel.text = @"0分";
        self.carryoutTimeLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSInteger realstarttimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:realstarttime] inFormat:IIDateFormat2] integerValue];
     NSInteger realendtimeTimeStamp = 0;
    
    NSString *realendtime = _taskMonitorModel.realendtime;
    if ([realendtime isEqualToString:@"-- --"] || [realendtime isEqualToString:@""] ) {
        realendtime = [IIDate getStringFromDate:[NSDate new] ofFormat:IIDateFormat2 timeZone:[NSTimeZone localTimeZone]];
        realendtimeTimeStamp = [[IIDate getTimestampFromString:realendtime inFormat:IIDateFormat2] integerValue];
    } else {
        realendtimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:realendtime] inFormat:IIDateFormat2] integerValue];
    }
    
    NSString *carryoutTime = [NSString stringWithFormat:@"%ld分", (realendtimeTimeStamp - realstarttimeTimeStamp)/60];
    
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

- (void)setupImageViewWithStutas:(NSString *)status {

    if ([status isEqualToString:@"0"]) {
        //未开始（判断超时、未超时）
        NSComparisonResult result = [self currentDateCompareTime:_taskMonitorModel.planstarttime];
        if (result == NSOrderedDescending) {
            //超时 当前时间大于计划开始时间
            self.taskstatusImageView.image = [UIImage imageNamed:@"ic_timeout_notyetstart"];
        } else {
            self.taskstatusImageView.image = [UIImage imageNamed:@"ic_not_start"];
        }
        
    } else if ([status isEqualToString:@"1"]) {
        //进行中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.taskstatusImageView.image = image;
    } else if ([status isEqualToString:@"2"]) {
        //已完成
        NSComparisonResult result = [self currentDateCompareTime:_taskMonitorModel.planendtime];
        if (result == NSOrderedDescending) {
            //超时 当前时间大于计划结束时间
            self.taskstatusImageView.image = [UIImage imageNamed:@"ic_timeout_finished"];
        } else {
            self.taskstatusImageView.image = [UIImage imageNamed:@"ic_finished"];
        }
    } else if ([status isEqualToString:@"3"]) {
        //验收通过
    } else if ([status isEqualToString:@"4"]) {
        //验收未通过
        self.taskstatusImageView.image = [UIImage imageNamed:@"ic_notPass"];
    }
}

- (NSComparisonResult)currentDateCompareTime:(NSString *)time {

    NSString *date = [IIDate getStringFromDate:[NSDate new] ofFormat:IIDateFormat2 timeZone:[NSTimeZone localTimeZone]];
    NSComparisonResult result = [date compare:time];
    
    return result;
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


- (UILabel *)jobLabel {
    if (!_jobLabel) {
        _jobLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 120)/2, CGRectGetMaxY(self.tasknameLabel.frame) + 15, 120, 40)];
        _jobLabel.backgroundColor = SYSTEM_COLOR;
        _jobLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _jobLabel.layer.borderWidth = 2;
        _jobLabel.layer.masksToBounds = YES;
        _jobLabel.layer.cornerRadius = 20;
        _jobLabel.font = [UIFont boldSystemFontOfSize:16];
        _jobLabel.textColor = [UIColor blackColor];
        _jobLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_jobLabel];
    }
    return _jobLabel;
}

- (UILabel *)planstarttimeLabel {
    if (!_planstarttimeLabel) {
        _planstarttimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(paddingK, CGRectGetMaxY(self.jobLabel.frame) + paddingK, 110, 20) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_planstarttimeLabel];
    }
    return _planstarttimeLabel;
}

- (UILabel *)planendtimeLabel {
    if (!_planendtimeLabel) {
        _planendtimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth - 120, CGRectGetMaxY(self.jobLabel.frame) + paddingK, 110, 20) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
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
