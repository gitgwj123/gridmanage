//
//  TLPatrolItemTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPatrolItemTableViewCell.h"

NSString *TLPatrolItemTableViewCellIdentifier = @"TLPatrolItemTableViewCellIdentifier";

static NSInteger const deviceNormalImageViewWidth = 46;

@interface TLPatrolItemTableViewCell ()

@property (nonatomic, strong) UILabel *itemdescribeLabel;
@property (nonatomic, strong) UILabel *deviceNormalTimeLabel;//设备正常的提交时间
@property (nonatomic, strong) UILabel *deviceAbnormalTimeLabel;//设备异常的提交时间
@property (nonatomic, strong) UIImageView *deviceNormalImageView;
@property (nonatomic, strong) UIImageView *deviceAbnormalImageView;

@property (nonatomic, strong) PatrolItemModel *patrolItemModel;

@end

@implementation TLPatrolItemTableViewCell


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

     CGFloat contentViewHeight = 110;
    //阴影
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, contentViewHeight - paddingK, screenWidth, paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(0, 0, 5, contentViewHeight - paddingK)]];
    [self.contentView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow_v" frame:CGRectMake(screenWidth - 5, 0, 5, contentViewHeight - paddingK)]];
    //竖线
    [self.contentView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(self.itemdescribeLabel.frame) + 1, 30, 1, 40)]];
  
    [self itemdescribeLabel];
    
    [self deviceNormalImageView];
    [self deviceNormalTimeLabel];
    
    [self deviceAbnormalImageView];
    [self deviceAbnormalTimeLabel];
}

- (void)setupPatrolCellWithPatrolItemModel:(PatrolItemModel *)patrolItemModel {

    self.patrolItemModel = patrolItemModel;
    self.itemdescribeLabel.text = patrolItemModel.itemdescribe;
    [self showImageViewWithDeviceState:patrolItemModel.devicestate];
    
    NSString *patroltimeStr = [IIDate getHourAndMinuteWithTime:patrolItemModel.patroltime];
    self.deviceNormalTimeLabel.text = patroltimeStr;
    self.deviceAbnormalTimeLabel.text = patroltimeStr;
}

#pragma mark - private methods
- (void)showImageViewWithDeviceState:(NSString *)state {

    if ([state isEqualToString:@"未操作"]) {
        self.deviceNormalImageView.hidden = NO;
        self.deviceAbnormalImageView.hidden = NO;
        
        self.deviceNormalTimeLabel.hidden = YES;
        self.deviceAbnormalTimeLabel.hidden = YES;
        
    } else if ([state isEqualToString:@"正常"]) {
        self.deviceNormalImageView.hidden = NO;
        self.deviceNormalTimeLabel.hidden = NO;
        
        self.deviceAbnormalImageView.hidden = YES;
        self.deviceAbnormalTimeLabel.hidden = YES;
        
    } else if ([state isEqualToString:@"异常"]) {
        self.deviceNormalImageView.hidden = YES;
        self.deviceNormalTimeLabel.hidden = YES;
        
        self.deviceAbnormalImageView.hidden = NO;
        self.deviceAbnormalTimeLabel.hidden = NO;
        
    } else if ([state isEqualToString:@"未知"]) {
        self.deviceNormalImageView.hidden = YES;
        self.deviceNormalTimeLabel.hidden = YES;
        
        self.deviceAbnormalImageView.hidden = NO;
        self.deviceAbnormalTimeLabel.hidden = NO;
    }
}

- (void)deviceNormalImageViewTapAction:(UITapGestureRecognizer *)tap {
  
    if (self.deviceStateImageViewBlock) {
        self.deviceStateImageViewBlock(self.patrolItemModel.patrolDetailId, YES);
    }
}

- (void)deviceAbnormalImageViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.deviceStateImageViewBlock) {
        self.deviceStateImageViewBlock(self.patrolItemModel.patrolDetailId, NO);
    }
}

#pragma mark - lazy loading
- (UILabel *)itemdescribeLabel {
    if (!_itemdescribeLabel) {
        _itemdescribeLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(paddingK, paddingK, screenWidth/2 + 2 * paddingK, 80) font:FONT(18) alignment:NSTextAlignmentCenter];
        _itemdescribeLabel.numberOfLines = 0;
        [self.contentView addSubview:_itemdescribeLabel];
    }
    
    return _itemdescribeLabel;
}

- (UIImageView *)deviceNormalImageView {

    if (!_deviceNormalImageView) {
        
        _deviceNormalImageView = [UIImageView addImageViewWithImageName:@"ic_ok" frame:CGRectMake(CGRectGetMaxX(self.itemdescribeLabel.frame) + 1 + paddingK, 15, deviceNormalImageViewWidth, deviceNormalImageViewWidth)];
        
        _deviceNormalImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceNormalImageViewTapAction:)];
        [_deviceNormalImageView addGestureRecognizer:tap];
        _deviceNormalImageView.hidden = YES;
        [self.contentView addSubview:_deviceNormalImageView];
        
    }
    
    return _deviceNormalImageView;
}

- (UILabel *)deviceNormalTimeLabel {
    if (!_deviceNormalTimeLabel) {
        _deviceNormalTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceNormalImageView.frame), CGRectGetMaxY(self.deviceNormalImageView.frame) + paddingK, deviceNormalImageViewWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        _deviceNormalTimeLabel.hidden = YES;
        [self.contentView addSubview:_deviceNormalTimeLabel];
    }
    
    return _deviceNormalTimeLabel;
}

- (UIImageView *)deviceAbnormalImageView {
    
    if (!_deviceAbnormalImageView) {
        
        _deviceAbnormalImageView = [UIImageView addImageViewWithImageName:@"ic_trouble" frame:CGRectMake(screenWidth - 2 * paddingK - deviceNormalImageViewWidth, 15, deviceNormalImageViewWidth, deviceNormalImageViewWidth)];
        
        _deviceAbnormalImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceAbnormalImageViewTapAction:)];
        [_deviceAbnormalImageView addGestureRecognizer:tap];
        _deviceAbnormalImageView.hidden = YES;
        [self.contentView addSubview:_deviceAbnormalImageView];
    }
    
    return _deviceAbnormalImageView;
}

- (UILabel *)deviceAbnormalTimeLabel {
    if (!_deviceAbnormalTimeLabel) {
        _deviceAbnormalTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.deviceAbnormalImageView.frame), CGRectGetMaxY(self.deviceAbnormalImageView.frame) + paddingK, deviceNormalImageViewWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        _deviceAbnormalTimeLabel.hidden = YES;
        [self.contentView addSubview:_deviceAbnormalTimeLabel];
    }
    
    return _deviceAbnormalTimeLabel;
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
