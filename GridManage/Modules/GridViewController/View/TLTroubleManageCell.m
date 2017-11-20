//
//  TLTroubleManageCell.m
//  GridManage
//
//  Created by gwj on 2017/11/20.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLTroubleManageCell.h"

NSString *TLTroubleManageCellIdentifier = @"TLTroubleManageCellIdentifier";

@interface TLTroubleManageCell ()

{
    UIColor *_bgViewColor;
    UIColor *_btnColor;
}


@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taktypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subclassLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@property (weak, nonatomic) IBOutlet UILabel *taskstatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *notPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;

@end


@implementation TLTroubleManageCell

- (void)setModel:(TroubleManageModel *)model {

    _model = model;
    
    NSArray *tasknameArr = [model.taskname componentsSeparatedByString:@" "];
    if (tasknameArr.count >= 2) {
        self.deviceNameLabel.text = tasknameArr[0];
        self.subclassLabel.text = tasknameArr[1];
    }
    
    self.submitTimeLabel.text = [self getSubmitTimeLabelTextWithTime:model.planstarttime];
    self.areaNameLabel.text = model.areaname;
    self.taktypeLabel.text = model.taktype;
    self.notesLabel.text = model.notes;
    
    self.taskstatusLabel.attributedText = [self getTaskstatusLabelTextWithStatus:model.taskstatus];
    
    self.notPassBtn.layer.masksToBounds = YES;
    self.notPassBtn.layer.cornerRadius = 5;
    self.passBtn.layer.masksToBounds = YES;
    self.passBtn.layer.cornerRadius = 5;
    
    self.backgroundColor = _bgViewColor;
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
    } else if ([status isEqualToString:@"1"]) {
        taskstatus = @"进行中";
        textColor = [UIColor greenColor];
        _bgViewColor = RGBColor(25, 66, 50, 1);
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
- (IBAction)notPassBtnAction:(UIButton *)sender {
    
    if (self.troubleManageCellBtnBlock && [_model.taskstatus isEqualToString:@"2"]) {
        self.troubleManageCellBtnBlock(_model, @"3");
    }
}
- (IBAction)passBtnAction:(UIButton *)sender {

    if (self.troubleManageCellBtnBlock && [_model.taskstatus isEqualToString:@"2"]) {
        self.troubleManageCellBtnBlock(_model, @"5");
    }
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
