//
//  TLTaskDetailViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLTaskDetailViewController.h"


static NSInteger const btnWidth_Work_key = 90;

@interface TLTaskDetailViewController ()

{
    NSString *_taskId;
    NSString *_taskName;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) YFRollingLabel *taskNameLabel;
@property (nonatomic, strong) UILabel *carryoutTimeLabel;
@property (nonatomic, strong) UILabel *teamLabel;
@property (nonatomic, strong) UILabel *planTimeLabel;
@property (nonatomic, strong) UILabel *realTimeLabel;

@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *broadcastBtn;
@property (nonatomic, strong) UIButton *interPhoneBtn;//对讲
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *callBtn;//呼叫

@end

@implementation TLTaskDetailViewController

- (instancetype)initWithTaskId:(NSString *)taskId{

    self = [super init];
    if (self) {
        _taskId = taskId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"任务详情";

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestWorkTaskDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions
- (void)videoBtnAction:(UIButton *)sender {

    
}

- (void)broadcastBtnAction:(UIButton *)sender {
    
    
}

- (void)interPhoneBtnAction:(UIButton *)sender {
    
    
}

- (void)messageBtnAction:(UIButton *)sender {
    
    
}

- (void)callBtnAction:(UIButton *)sender {
    
    
}



#pragma mark - private
- (void)configTopViewWithData:(NSDictionary *)dataDic {
 
    _taskName = dataDic[@"taskname"];
    
    [self topView];
    [self interPhoneBtn];
    [self messageBtn];
    [self callBtn];
    
    [self setupStatusImageViewWithStatus:dataDic[@"taskstatus"]];
    
    self.carryoutTimeLabel.text = [NSString getCarryoutTimeWithRealstarttime:dataDic[@"realstarttime"] realendtime:dataDic[@"realendtime"]];
    self.teamLabel.text = dataDic[@"opteamname"];
    
    self.planTimeLabel.text = [NSString getStartTimeAndEndTimeWithStarttime:dataDic[@"planstarttime"] endtime:dataDic[@"planendtime"]];
    self.realTimeLabel.text = [NSString getStartTimeAndEndTimeWithStarttime:dataDic[@"realstarttime"]  endtime:dataDic[@"realendtime"]];
}


- (void)setupStatusImageViewWithStatus:(NSString *)status {

    if ([status isEqualToString:@"0"]) {
        self.statusImageView.image = [UIImage imageNamed:@"ic_not_start"];
    } else if ([status isEqualToString:@"1"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.statusImageView.image = image;
    } else if ([status isEqualToString:@"2"]) {
        self.statusImageView.image = [UIImage imageNamed:@"ic_wait_pass"];
    }
}

#pragma mark - network
//请求监控数据
- (void)requestWorkTaskDetail {
    
    NSString *dataStr = [[RequestManager sharedManager] getWorkTaskDetailDataParameterWithTaskId:_taskId];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                [strongSelf configTopViewWithData:[dataList firstObject]];
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
}


#pragma mark - lazy loading
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, 180)];
        _topView.backgroundColor = RGBColor(33, 33, 9, 1);
        [self.view addSubview:_topView];

        [self statusImageView];
        [_topView addSubview:[UILabel addLabelWithText:@"作业名称" textColor:TextColor_GRAY frame:CGRectMake((screenWidth - 80)/2, paddingK, 80, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
        [_topView addSubview:[UILabel addLabelWithText:@"执行时间" textColor:TextColor_GRAY frame:CGRectMake(screenWidth - 90, paddingK, 80, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
        [self taskNameLabel];
        [self carryoutTimeLabel];
        
        [self videoBtn];
        [self broadcastBtn];
        [self teamLabel];
        
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(self.videoBtn.frame), CGRectGetMidY(self.videoBtn.frame), (screenWidth - 100 - btnWidth_Work_key * 2)/2, 1)]];
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(self.teamLabel.frame), CGRectGetMidY(self.videoBtn.frame), (screenWidth - 100 - btnWidth_Work_key * 2)/2, 1)]];
       
        [_topView addSubview:[UILabel addLabelWithText:@"计划:" textColor:TextColor_GRAY frame:CGRectMake(10, CGRectGetMaxY(self.videoBtn.frame) + 15, 40, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(screenWidth/2, CGRectGetMaxY(self.videoBtn.frame) + 15, 1, 20)]];
        [_topView addSubview:[UILabel addLabelWithText:@"实际:" textColor:TextColor_GRAY frame:CGRectMake(screenWidth/2 + 5, CGRectGetMaxY(self.videoBtn.frame) + 15, 40, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
        
        [self planTimeLabel];
        [self realTimeLabel];
    }
    return _topView;
}

- (UIImageView *)statusImageView {
    
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, paddingK, 45, 45)];
        _statusImageView.layer.masksToBounds = YES;
        _statusImageView.layer.cornerRadius = 22.5;
        [self.topView addSubview:_statusImageView];
    }
    
    return _statusImageView;
}

- (YFRollingLabel *)taskNameLabel {
    if (!_taskNameLabel) {

        _taskNameLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(95, 50, screenWidth - 190, 30)  textArray:@[_taskName] font:[UIFont boldSystemFontOfSize:22] textColor:SYSTEM_COLOR];
        // _label.speed = 2;
        [_taskNameLabel setOrientation:RollingOrientationLeft];

        [self.topView addSubview:_taskNameLabel];
    }
    
    return _taskNameLabel;
}

- (UILabel *)carryoutTimeLabel {
    if (!_carryoutTimeLabel) {
        _carryoutTimeLabel = [UILabel addLabelWithText:@"" textColor:SYSTEM_COLOR frame:CGRectMake(screenWidth - 90, CGRectGetMinY(self.taskNameLabel.frame), 90, 30) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        [self.topView addSubview:_carryoutTimeLabel];
    }
    return _carryoutTimeLabel;
}

- (UIButton *)videoBtn {

    if (!_videoBtn) {
        _videoBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [self.topView addSubview:_videoBtn];//一定要先添加到视图上
        _videoBtn.frame=CGRectMake(0, CGRectGetMaxY(self.taskNameLabel.frame) + 15, btnWidth_Work_key, 40);
        _videoBtn.backgroundColor = Saffron_Yellow_COLOR;
        
        [_videoBtn setImage:[[UIImage imageNamed:@"ic_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_videoBtn setImage:[[UIImage imageNamed:@"ic_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _videoBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 15, 7, btnWidth_Work_key - 15 - 22);
        [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _videoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_videoBtn addTarget:self action:@selector(videoBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_videoBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _videoBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _videoBtn.layer.mask = maskLayer;
    }
    return _videoBtn;
}

- (UIButton *)broadcastBtn {
    
    if (!_broadcastBtn) {
        _broadcastBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [self.topView addSubview:_broadcastBtn];//一定要先添加到视图上
        _broadcastBtn.frame=CGRectMake(screenWidth - btnWidth_Work_key, CGRectGetMaxY(self.taskNameLabel.frame) + 15, btnWidth_Work_key, 40);
        _broadcastBtn.backgroundColor = Saffron_Yellow_COLOR;
        
        [_broadcastBtn setImage:[[UIImage imageNamed:@"ic_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_broadcastBtn setImage:[[UIImage imageNamed:@"ic_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _broadcastBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 15, 7, btnWidth_Work_key - 15 - 22);
        [_broadcastBtn setTitle:@"广播" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _broadcastBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_broadcastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_broadcastBtn addTarget:self action:@selector(broadcastBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_broadcastBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _broadcastBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _broadcastBtn.layer.mask = maskLayer;
    }
    return _broadcastBtn;
}

- (UILabel *)teamLabel {
    if (!_teamLabel) {
        _teamLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake((screenWidth - 100)/2, CGRectGetMaxY(self.taskNameLabel.frame) + 15, 100, 40) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        _teamLabel.backgroundColor = [UIColor blackColor];
        _teamLabel.layer.masksToBounds = YES;
        _teamLabel.layer.cornerRadius = 20;
        [self.topView addSubview:_teamLabel];
    }
    return _teamLabel;
}

- (UILabel *)planTimeLabel {
    if (!_planTimeLabel) {
        _planTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(50, CGRectGetMaxY(self.videoBtn.frame) + 15, screenWidth/2 - 50, 20) font:FONT(16) alignment:NSTextAlignmentLeft];
        [self.topView addSubview:_planTimeLabel];
    }
    return _planTimeLabel;
}

- (UILabel *)realTimeLabel {
    if (!_realTimeLabel) {
        _realTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth/2 + 45, CGRectGetMaxY(self.videoBtn.frame) + 15, screenWidth/2 - 50, 20) font:FONT(16) alignment:NSTextAlignmentLeft];
        [self.topView addSubview:_realTimeLabel];
    }
    return _realTimeLabel;
}

- (UIButton *)interPhoneBtn {
    
    if (!_interPhoneBtn) {
        _interPhoneBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_interPhoneBtn];
        _interPhoneBtn.frame=CGRectMake(paddingK, CGRectGetMaxY(self.topView.frame) + paddingK, btnWidth_Work_key, 40);
        _interPhoneBtn.backgroundColor = Saffron_Yellow_COLOR;
        _interPhoneBtn.layer.masksToBounds = YES;
        _interPhoneBtn.layer.cornerRadius = 5;
        
        [_interPhoneBtn setImage:[[UIImage imageNamed:@"ic_interphone"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_interPhoneBtn setImage:[[UIImage imageNamed:@"ic_interphone"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _interPhoneBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 15, 7, btnWidth_Work_key - 15 - 22);
        [_interPhoneBtn setTitle:@"对讲" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _interPhoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_interPhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_interPhoneBtn addTarget:self action:@selector(interPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _interPhoneBtn;
}


- (UIButton *)messageBtn {
    
    if (!_messageBtn) {
        _messageBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_messageBtn];
        _messageBtn.frame = CGRectMake(paddingK + btnWidth_Work_key + (screenWidth - btnWidth_Work_key * 3 - 20)/2, CGRectGetMaxY(self.topView.frame) + paddingK, btnWidth_Work_key, 40);
        _messageBtn.backgroundColor = Saffron_Yellow_COLOR;
        _messageBtn.layer.masksToBounds = YES;
        _messageBtn.layer.cornerRadius = 5;
        
        [_messageBtn setImage:[[UIImage imageNamed:@"ic_work_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_messageBtn setImage:[[UIImage imageNamed:@"ic_work_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 15, 7, btnWidth_Work_key - 15 - 22);
        [_messageBtn setTitle:@"消息" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _messageBtn;
}

- (UIButton *)callBtn {
    
    if (!_callBtn) {
        _callBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_callBtn];
        _callBtn.frame = CGRectMake(screenWidth - paddingK - btnWidth_Work_key, CGRectGetMaxY(self.topView.frame) + paddingK, btnWidth_Work_key, 40);
        _callBtn.backgroundColor = Saffron_Yellow_COLOR;
        _callBtn.layer.masksToBounds = YES;
        _callBtn.layer.cornerRadius = 5;
        
        [_callBtn setImage:[[UIImage imageNamed:@"ic_call"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_callBtn setImage:[[UIImage imageNamed:@"ic_call"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _callBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 15, 7, btnWidth_Work_key - 15 - 22);
        [_callBtn setTitle:@"消息" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _callBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _callBtn;
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
