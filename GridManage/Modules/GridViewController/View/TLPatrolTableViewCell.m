//
//  TLPatrolTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPatrolTableViewCell.h"
#import "NSString+AttributeColor.h"

static NSInteger planLableWidth = 70;

NSString *TLPatrolTableViewCellIdentifier = @"TLPatrolTableViewCellIdentifier";

@interface TLPatrolTableViewCell ()

@property (nonatomic, strong) UILabel *pointnameLabel;
@property (nonatomic, strong) UILabel *planendtimeLabel;
@property (nonatomic, strong) UILabel *planstarttimeLabel;
@property (nonatomic, strong) UILabel *problemsAnditemscountLabel;

@end

@implementation TLPatrolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}


#pragma mark - UI
- (void)initUI {

    CGFloat contentViewHeight = 140;
    
    //阴影
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, contentViewHeight - paddingK, screenWidth, paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(0, 0, 5, contentViewHeight - paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(screenWidth - 5, 0, 5, contentViewHeight - paddingK)]];
    //竖线
    [self.contentView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(screenWidth/2 - paddingK, 40 + paddingK, 1, 50)]];
    [self.contentView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(screenWidth/2 + planLableWidth + paddingK, 40 + paddingK, 1, 50)]];
    //计划开始、计划结束
    [self.contentView addSubview:[UILabel addLabelWithText:@"计划开始" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth/2, 10, planLableWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter]];
    [self.contentView addSubview:[UILabel addLabelWithText:@"计划结束" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth/2, 70, planLableWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter]];
    
    //显示文本
    [self pointnameLabel];
    [self planstarttimeLabel];
    [self planendtimeLabel];
    [self problemsAnditemscountLabel];
    
}


#pragma mark - public methods
- (void)setupPatrolCellWithPatrolModel:(PatrolModel *)patrolModel {

    self.pointnameLabel.text = patrolModel.pointname;
    self.planstarttimeLabel.text = [IIDate getHourAndMinuteWithTime:patrolModel.planstarttime];
    self.planendtimeLabel.text = [IIDate getHourAndMinuteWithTime:patrolModel.planendtime];
    NSString *str = [NSString stringWithFormat:@"%@/%@", patrolModel.finishcount, patrolModel.itemscount];
    NSRange changeColorRange = NSMakeRange(str.length - patrolModel.itemscount.length, patrolModel.itemscount.length);
    self.problemsAnditemscountLabel.attributedText = [NSString getNewStringWithRange:changeColorRange string:str color:SYSTEM_COLOR];
}



#pragma mark - lazy loading
- (UILabel *)pointnameLabel {
    if (!_pointnameLabel) {
        _pointnameLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(paddingK, 50, screenWidth/2 - 2 * paddingK, 30) font:FONT(18) alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_pointnameLabel];
    }
    
    return _pointnameLabel;
}

- (UILabel *)planstarttimeLabel {
    if (!_planstarttimeLabel) {
        _planstarttimeLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(screenWidth/2, 40, planLableWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_planstarttimeLabel];
    }
    
    return _planstarttimeLabel;
}

- (UILabel *)planendtimeLabel {
    if (!_planendtimeLabel) {
         _planendtimeLabel = [UILabel addLabelWithText:@"" textColor:Saffron_Yellow_COLOR frame:CGRectMake(screenWidth/2, 100, planLableWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_planendtimeLabel];
    }
    
    return _planendtimeLabel;
}

- (UILabel *)problemsAnditemscountLabel {
    if (!_problemsAnditemscountLabel) {
         _problemsAnditemscountLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth/2 + planLableWidth + paddingK + 1, 50, (screenWidth/2  - planLableWidth -1 - 2 * paddingK), 30) font:FONT(18) alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_problemsAnditemscountLabel];
        
    }
    return _problemsAnditemscountLabel;
}


@end
