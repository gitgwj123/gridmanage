//
//  TLTaskStatusView.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLTaskStatusView.h"

@interface TLTaskStatusView ()

{
    NSString *_choosedText;
}
@property (nonatomic, strong) UIView *status_all_View;
@property (nonatomic, strong) UILabel *status_all_Label;
@property (nonatomic, strong) UIImageView *choose1ImageView;

@property (nonatomic, strong) UIView *status_notstart_View;
@property (nonatomic, strong) UILabel *status_notstart_Label;
@property (nonatomic, strong) UIImageView *choose2ImageView;

@property (nonatomic, strong) UIView *status_going_View;
@property (nonatomic, strong) UILabel *status_going_Label;
@property (nonatomic, strong) UIImageView *choose3ImageView;

@property (nonatomic, strong) UIView *status_finish_View;
@property (nonatomic, strong) UILabel *status_finish_Label;
@property (nonatomic, strong) UIImageView *choose4ImageView;

@end

@implementation TLTaskStatusView

-(instancetype)initWithFrame:(CGRect)frame choosedText:(NSString *)text {

    self = [super initWithFrame:frame];
    if (self) {
        _choosedText = text;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    [self status_all_View];
    [self addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(15, CGRectGetMaxY(self.status_all_View.frame), screenWidth - 15, 1)]];
   
    [self status_notstart_View];
    [self addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(15, CGRectGetMaxY(self.status_notstart_View.frame), screenWidth - 15, 1)]];
   
    [self status_going_View];
    [self addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(15, CGRectGetMaxY(self.status_going_View.frame), screenWidth - 15, 1)]];
   
    [self status_finish_View];
    
}

#pragma mark - private methods
- (void)showChoose1ImageView {

    self.status_all_Label.textColor = [UIColor whiteColor];
    self.status_notstart_Label.textColor = [UIColor grayColor];
    self.status_going_Label.textColor = [UIColor grayColor];
    self.status_finish_Label.textColor = [UIColor grayColor];
    
    self.choose1ImageView.hidden = NO;
    self.choose2ImageView.hidden = YES;
    self.choose3ImageView.hidden = YES;
    self.choose4ImageView.hidden = YES;
}

- (void)showChoose2ImageView {
    
    self.status_all_Label.textColor = [UIColor grayColor];
    self.status_notstart_Label.textColor = [UIColor whiteColor];
    self.status_going_Label.textColor = [UIColor grayColor];
    self.status_finish_Label.textColor = [UIColor grayColor];
    
    self.choose1ImageView.hidden = YES;
    self.choose2ImageView.hidden = NO;
    self.choose3ImageView.hidden = YES;
    self.choose4ImageView.hidden = YES;
}

- (void)showChoose3ImageView {
    
    self.status_all_Label.textColor = [UIColor grayColor];
    self.status_notstart_Label.textColor = [UIColor grayColor];
    self.status_going_Label.textColor = [UIColor whiteColor];
    self.status_finish_Label.textColor = [UIColor grayColor];
    
    self.choose1ImageView.hidden = YES;
    self.choose2ImageView.hidden = YES;
    self.choose3ImageView.hidden = NO;
    self.choose4ImageView.hidden = YES;
}

- (void)showChoose4ImageView {
    
    self.status_all_Label.textColor = [UIColor grayColor];
    self.status_going_Label.textColor = [UIColor grayColor];
    self.status_notstart_Label.textColor = [UIColor grayColor];
    self.status_finish_Label.textColor = [UIColor whiteColor];
    
    self.choose1ImageView.hidden = YES;
    self.choose2ImageView.hidden = YES;
    self.choose3ImageView.hidden = YES;
    self.choose4ImageView.hidden = NO;
}

#pragma mark - action
- (void)status_all_ViewTapAction:(UITapGestureRecognizer *)tap {

    if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusViewTapWithStatus:)]) {
        [self.delegate taskStatusViewTapWithStatus:self.status_all_Label.text];
    }
    
    [self showChoose1ImageView];
}

- (void)status_notstart_ViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusViewTapWithStatus:)]) {
        [self.delegate taskStatusViewTapWithStatus:self.status_notstart_Label.text];
    }
    
    [self showChoose2ImageView];
}

- (void)status_going_ViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusViewTapWithStatus:)]) {
        [self.delegate taskStatusViewTapWithStatus:self.status_going_Label.text];
    }
    
    [self showChoose3ImageView];
}

- (void)status_finish_ViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusViewTapWithStatus:)]) {
        [self.delegate taskStatusViewTapWithStatus:self.status_finish_Label.text];
    }
    
    [self showChoose4ImageView];
}

#pragma mark - lazy loading
- (UIView *)status_all_View {
    
    if (!_status_all_View) {
        _status_all_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        _status_all_View.backgroundColor = [UIColor clearColor];
        [self addSubview:_status_all_View];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(status_all_ViewTapAction:)];
        [_status_all_View addGestureRecognizer:tap];
        
        [self status_all_Label];
        [self choose1ImageView];
    }
    return _status_all_View;
}

- (UILabel *)status_all_Label {

    if (!_status_all_Label) {
        _status_all_Label = [UILabel addLabelWithText:@"全部" textColor:[UIColor whiteColor] frame:CGRectMake(20, 15, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.status_all_View addSubview:_status_all_Label];
    }
    
    return _status_all_Label;
}
- (UIImageView *)choose1ImageView {
    
    if (!_choose1ImageView) {
        _choose1ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_right" frame:CGRectMake(screenWidth - 30, 15, 20, 20)];
        [self.status_all_View addSubview:_choose1ImageView];
    }
    return _choose1ImageView;
}

//
- (UIView *)status_notstart_View {
    
    if (!_status_notstart_View) {
        _status_notstart_View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.status_all_View.frame) + 1, screenWidth, 50)];
        _status_notstart_View.backgroundColor = [UIColor clearColor];
        [self addSubview:_status_notstart_View];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(status_notstart_ViewTapAction:)];
        [_status_notstart_View addGestureRecognizer:tap];
        
        [self status_notstart_Label];
        [self choose2ImageView];
    }
    return _status_notstart_View;
}

- (UILabel *)status_notstart_Label {
    
    if (!_status_notstart_Label) {
        _status_notstart_Label = [UILabel addLabelWithText:@"未开始" textColor:[UIColor grayColor] frame:CGRectMake(20, 15, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.status_notstart_View addSubview:_status_notstart_Label];
    }
    
    return _status_notstart_Label;
}
- (UIImageView *)choose2ImageView {
    
    if (!_choose2ImageView) {
        _choose2ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_right" frame:CGRectMake(screenWidth - 30, CGRectGetMinY(self.status_notstart_Label.frame), 20, 20)];
        _choose2ImageView.hidden = YES;
        [self.status_notstart_View addSubview:_choose2ImageView];
    }
    return _choose2ImageView;
}

//
- (UIView *)status_going_View {
    
    if (!_status_going_View) {
        _status_going_View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.status_notstart_View.frame) + 1, screenWidth, 50)];
        _status_going_View.backgroundColor = [UIColor clearColor];
        [self addSubview:_status_going_View];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(status_going_ViewTapAction:)];
        [_status_going_View addGestureRecognizer:tap];
        [self status_going_Label];
        [self choose3ImageView];
    }
    return _status_going_View;
}

- (UILabel *)status_going_Label {
    
    if (!_status_going_Label) {
        _status_going_Label = [UILabel addLabelWithText:@"进行中" textColor:[UIColor grayColor] frame:CGRectMake(20, 15, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.status_going_View addSubview:_status_going_Label];
    }
    
    return _status_going_Label;
}
- (UIImageView *)choose3ImageView {
    
    if (!_choose3ImageView) {
        _choose3ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_right" frame:CGRectMake(screenWidth - 30, CGRectGetMinY(self.status_going_Label.frame), 20, 20)];
        _choose3ImageView.hidden = YES;
        [self.status_going_View addSubview:_choose3ImageView];
    }
    return _choose3ImageView;
}

//
- (UIView *)status_finish_View {
    
    if (!_status_finish_View) {
        _status_finish_View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.status_going_View.frame) + 1, screenWidth, 200)];
        _status_finish_View.backgroundColor = [UIColor clearColor];
        [self addSubview:_status_finish_View];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(status_finish_ViewTapAction:)];
        [_status_finish_View addGestureRecognizer:tap];
        [self status_finish_Label];
        [self choose4ImageView];
    }
    return _status_finish_View;
}

- (UILabel *)status_finish_Label {
    
    if (!_status_finish_Label) {
        _status_finish_Label = [UILabel addLabelWithText:@"已完成" textColor:[UIColor grayColor] frame:CGRectMake(20, 15, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.status_finish_View addSubview:_status_finish_Label];
    }
    
    return _status_finish_Label;
}
- (UIImageView *)choose4ImageView {
    
    if (!_choose4ImageView) {
        _choose4ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_right" frame:CGRectMake(screenWidth - 30, CGRectGetMinY(self.status_finish_Label.frame), 20, 20)];
        _choose4ImageView.hidden = YES;
        [self.status_finish_View addSubview:_choose4ImageView];
    }
    return _choose4ImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
