//
//  TLWorkViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLWorkViewController.h"
#import "TLSettingViewController.h"
#import "TLTaskDetailViewController.h"
#import "TLWorkDetailViewController.h"
#import "MyTaskModel.h"
#import "TLMyTaskTableViewCell.h"
#import "TaskMonitorModel.h"
#import "TaskMonitorTableViewCell.h"
#import "TLTaskStatusView.h"

@interface TLWorkViewController ()<UITableViewDelegate, UITableViewDataSource, TLTaskStatusViewDelegate>
{
    MyTaskModel *_publishTaskTaskModel;
    NSString *_changedTaskStutas;
}

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *stationView;
@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) UIImageView *upAndDown1ImageView;

@property (nonatomic, strong) UIView *stationListView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *upAndDown2ImageView;

@property (nonatomic, strong) TLTaskStatusView *statusListView;

@property (nonatomic, strong) NSMutableArray *taskMonitorArray;//保存请求的数据
@property (nonatomic, strong) NSMutableArray *myTasksArray;

@property (nonatomic, strong) NSMutableArray *finialTaskMonitorArray;//保存匹配状态的数据
@property (nonatomic, strong) NSMutableArray *finialmyTasksArray;

@property (nonatomic, assign) BOOL isDisplayTableView;

@end

@implementation TLWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentItems = @[@"我的任务", @"任务监控"];
    self.navigationItem.titleView = self.titleView;
    
    [self configNavBarRightItem];
    
    _isDisplayTableView = YES;
    self.notiLabel.text = work_notiLabelText_nottask;
    
    [self topView];
    
    [self configDisplayTableView];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (_isDisplayTableView) {
        [self requestMyWorkTasks];
    } else {
        [self requestWorkMonitor];
    }
    
}

#pragma mark - action
- (void)segmentControlAction:(UISegmentedControl *)segmentControl {

    if (!self.stationListView.hidden) {
        [self.stationListView setHidden:YES];
        self.upAndDown1ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }
    
    if (!self.statusListView.hidden) {
        [self.statusListView setHidden:YES];
        self.upAndDown2ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }
    
    if (segmentControl.selectedSegmentIndex == 0) {
        self.isDisplayTableView = YES;
        
        self.display2TableView.hidden = YES;
        [self requestMyWorkTasks];
    } else {
        self.isDisplayTableView = NO;
        
        self.displayTableView.hidden = YES;
        [self requestWorkMonitor];
    }
}

- (void)headViewTapAction:(UITapGestureRecognizer *)tap {

    TLSettingViewController *settingVc = [[TLSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notiLabelTapAction:(UITapGestureRecognizer *)tap {

    if (self.isDisplayTableView) {
        [self requestMyWorkTasks];
    } else {
        [self requestWorkMonitor];
    }

}

- (void)stationViewTapAction:(UITapGestureRecognizer *)tap {

    if (self.stationListView.hidden) {
        [self.stationListView setHidden:NO];
        self.upAndDown1ImageView.image = [UIImage imageNamed:@"ic_chose_up"];
    } else {
        [self.stationListView setHidden:YES];
        self.upAndDown1ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }
    
    if (!self.statusListView.hidden) {
        [self.statusListView setHidden:YES];
        self.upAndDown2ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }
    
}

- (void)statusViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.statusListView.hidden) {
        [self.statusListView setHidden:NO];
        self.upAndDown2ImageView.image = [UIImage imageNamed:@"ic_chose_up"];
    } else {
        [self.statusListView setHidden:YES];
        self.upAndDown2ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }
    
    if (!self.stationListView.hidden) {
        [self.stationListView setHidden:YES];
        self.upAndDown1ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    }

}

- (void)stationListViewTapAction:(UITapGestureRecognizer *)tap {
    
    [self.stationListView setHidden:YES];
    self.upAndDown1ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    
    if (_isDisplayTableView) {
        [self requestMyWorkTasks];
    } else {
        [self requestWorkMonitor];
    }
}

#pragma mark - private methods
- (void)configNavBarRightItem {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
    headView.backgroundColor = RGBColor(3, 29, 64, 1);
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 15;
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTapAction:)];
    [headView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, -3, 25, 35)];
    imageView.clipsToBounds = YES;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[TLStorage getUserPhoto]]];
    UIImage *image = [UIImage imageWithData:data];
    imageView.image = image;
    [headView addSubview:imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headView];
}

- (void)configDisplayTableView {
    
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    [self.displayTableView registerClass:[TLMyTaskTableViewCell class] forCellReuseIdentifier:TLMyTaskTableViewCellIdentifier];
    //下拉刷新
    self.displayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMyWorkTasks];
    }];
    self.displayTableView.hidden = YES;
    
    self.display2TableView.delegate = self;
    self.display2TableView.dataSource = self;
    self.display2TableView.rowHeight = 200;
    [self.display2TableView registerClass:[TaskMonitorTableViewCell class] forCellReuseIdentifier:TLTaskMonitorTableViewCellIdentifier];
    //下拉刷新
    self.display2TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestWorkMonitor];
    }];
    self.display2TableView.hidden = YES;
}

- (void)publishAlert {

    NSString *title = @"";
    if ([_changedTaskStutas isEqualToString:@"0"]) {
        title = @"确定要开始吗？";
    } else if ([_changedTaskStutas isEqualToString:@"2"]) {
        title = @"确定要完成吗？";
    }
    
    [TLAlert setAlertControllerWithController:self Title:title message:nil cancelActionTitle:@"取消" okActionTitle:@"确定" cancelActionHandler:^(UIAlertAction *action) {
        
    } okActionHandler:^(UIAlertAction *action) {
        [self requestPublishTaskCommand];
    }];
}

- (void)matchMyTaskWithStatus:(NSString *)status {

    if ([status isEqualToString:@"全部"]) {
        [self.displayTableView reloadData];
        return;
    }
    
    NSString *taskStatus = @"0";
    if ([status isEqualToString:@"未开始"]) {
        taskStatus = @"0";
    } else if ([status isEqualToString:@"进行中"]) {
        taskStatus = @"1";
    } else if ([status isEqualToString:@"已完成"]) {
        taskStatus = @"2";
    }
    
    [self.finialmyTasksArray removeAllObjects];
    for (TaskMonitorModel *model in self.myTasksArray) {
        if ([model.taskstatus isEqualToString:taskStatus]) {
            [self.finialmyTasksArray addObject:model];
        }
    }
    [self.displayTableView reloadData];
}

- (void)matchTaskMonitorWithStatus:(NSString *)status {
    if ([status isEqualToString:@"全部"]) {
        [self.display2TableView reloadData];
        return;
    }
    
    NSString *taskStatus = @"0";
    if ([status isEqualToString:@"未开始"]) {
        taskStatus = @"0";
    } else if ([status isEqualToString:@"进行中"]) {
        taskStatus = @"1";
    } else if ([status isEqualToString:@"已完成"]) {
        taskStatus = @"2";
    }
    
    [self.finialTaskMonitorArray removeAllObjects];
    for (TaskMonitorModel *model in self.taskMonitorArray) {
        if ([model.taskstatus isEqualToString:taskStatus]) {
            [self.finialTaskMonitorArray addObject:model];
        }
    }
    [self.display2TableView reloadData];
}

- (void)sortMyTasksArray {
 //按进行中、(未开始/重新开始)、待验收 排序
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    for (MyTaskModel *model in self.myTasksArray) {
        if ([model.taskstatus isEqualToString:@"1"]) {
            [sortArray addObject:model];
        }
    }
    
    for (MyTaskModel *model in self.myTasksArray) {
        if ([model.taskstatus isEqualToString:@"0"] || [model.taskstatus isEqualToString:@"4"]) {
            [sortArray addObject:model];
        }
    }

    for (MyTaskModel *model in self.myTasksArray) {
        if ([model.taskstatus isEqualToString:@"2"]) {
            [sortArray addObject:model];
        }
    }
   
    if (self.finialmyTasksArray.count > 0) {
        [self.finialmyTasksArray removeAllObjects];
    }
    self.finialmyTasksArray = [NSMutableArray arrayWithArray:sortArray];

}

- (NSArray *)sortTaskMonitorArray {
    //按进行中、未开始、已完成 排序
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    for (TaskMonitorModel *model in self.taskMonitorArray) {
        if ([model.taskstatus isEqualToString:@"1"]) {
            [sortArray addObject:model];
        }
    }
    for (TaskMonitorModel *model in self.taskMonitorArray) {
        if ([model.taskstatus isEqualToString:@"0"]) {
            [sortArray addObject:model];
        }
    }
    for (TaskMonitorModel *model in self.taskMonitorArray) {
        if ([model.taskstatus isEqualToString:@"2"]) {
            [sortArray addObject:model];
        }
    }
    
    return sortArray;
}


#pragma mark delegate
//TLTaskStatusViewDelegate
- (void)taskStatusViewTapWithStatus:(NSString *)status {

    self.statusLabel.text = status;
    [self.statusListView setHidden:YES];
    self.upAndDown2ImageView.image = [UIImage imageNamed:@"ic_chose_down"];
    
    if (_isDisplayTableView) {
         [self matchMyTaskWithStatus:status];
    } else {
        [self matchTaskMonitorWithStatus:status];
    }
}

//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDisplayTableView) {
        return self.finialmyTasksArray.count;
    } else {
        return self.finialTaskMonitorArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, 0, screenWidth, 10)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDisplayTableView) {
        TLMyTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLMyTaskTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[TLMyTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLMyTaskTableViewCellIdentifier];
        }
        
        [cell setupMyTaskCellWithMyTaskModel:self.finialmyTasksArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WeakSelf;
        cell.OperateLabelTapActionBlock = ^(MyTaskModel *myTaskModel, NSString *changedTaskStutas) {
            //发布命令与协作
            _publishTaskTaskModel = myTaskModel;
            _changedTaskStutas = changedTaskStutas;
            [weakSelf publishAlert];
        };
        return cell;
    } else {
        TaskMonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLTaskMonitorTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[TaskMonitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLTaskMonitorTableViewCellIdentifier];
        }
        
        [cell setupPatrolCellWithTaskMonitorModel:self.finialTaskMonitorArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDisplayTableView) {
        TLWorkDetailViewController *workDetailVc = [[TLWorkDetailViewController alloc] initWithMyTaskModel:self.finialmyTasksArray[indexPath.row]];
        [self.navigationController pushViewController:workDetailVc animated:YES];
    } else {
        TaskMonitorModel *model = self.finialTaskMonitorArray[indexPath.row];
        TLTaskDetailViewController *detailVc = [[TLTaskDetailViewController alloc] initWithTaskId:model.tasksid];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - network
- (void)requestPublishTaskCommand {
    
    NSString *dataStr = [[RequestManager sharedManager] getPublishTaskCommandDataParameterWithJobsId:_publishTaskTaskModel.jobsid note:_publishTaskTaskModel.note opType:_changedTaskStutas joboperatorsid:_publishTaskTaskModel.joboperatorsid tasksid:_publishTaskTaskModel.tasksid usersId:[TLStorage getUserId]];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:@{@"token":[TLStorage getToken], @"time":@"1",@"data":dataStr,  @"hash":[TLStorage getHash], @"opeCode":@"202"} withURL:TLRequestUrlPublishTaskCommand responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            //提交成功 刷新界面
            [strongSelf requestMyWorkTasks];
        } else {
            //提交失败
            [TLAlert showMessage:@"提交失败，请重试" hideDelay:2 inView:strongSelf.view];
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        //请求失败
        [TLAlert showMessage:@"加载失败，请重试" hideDelay:2 inView:strongSelf.view];
    }];
}

//请求任务数据
- (void)requestMyWorkTasks {

    [self.displayTableView.mj_header endRefreshing];
    NSString *dataStr = [[RequestManager sharedManager] getMyWorkTasksDataParameterWithTeamsid:[TLStorage getTeamId]];
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.myTasksArray.count > 0) {
                [strongSelf.myTasksArray removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    MyTaskModel *model = [MyTaskModel yy_modelWithDictionary:dic];
                    [strongSelf.myTasksArray addObject:model];
                }
                
              [strongSelf sortMyTasksArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.notiLabel.hidden = YES;
                    strongSelf.displayTableView.hidden = NO;
                    [strongSelf.displayTableView reloadData];
                });
            } else {
                strongSelf.notiLabel.hidden = NO;
                strongSelf.notiLabel.text = work_notiLabelText_notmonitortask;
                strongSelf.displayTableView.hidden = YES;
            }
        } else {
            strongSelf.notiLabel.hidden = NO;
            strongSelf.notiLabel.text = work_notiLabelText_loadfailure;
            strongSelf.displayTableView.hidden = YES;
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.notiLabel.hidden = NO;
        strongSelf.notiLabel.text = work_notiLabelText_loadfailure;
        strongSelf.displayTableView.hidden = YES;
    }];
}

//请求监控数据
- (void)requestWorkMonitor {

    [self.display2TableView.mj_header endRefreshing];
    
    NSString *dataStr = [[RequestManager sharedManager] getWorkMonitorDataParameterWithTeamsid:[TLStorage getTeamId]];
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.taskMonitorArray.count > 0) {
                [strongSelf.taskMonitorArray removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    TaskMonitorModel *taskMonitorModel = [TaskMonitorModel yy_modelWithDictionary:dic];
                    [strongSelf.taskMonitorArray addObject:taskMonitorModel];
                }
                
                if (strongSelf.finialTaskMonitorArray.count > 0) {
                    [strongSelf.finialTaskMonitorArray removeAllObjects];
                }
                strongSelf.finialTaskMonitorArray = [NSMutableArray arrayWithArray:[strongSelf sortTaskMonitorArray]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.notiLabel.hidden = YES;
                    strongSelf.display2TableView.hidden = NO;
                    [strongSelf.display2TableView reloadData];
                });
            } else {
                strongSelf.notiLabel.hidden = NO;
                strongSelf.notiLabel.text = work_notiLabelText_notmonitortask;
                strongSelf.display2TableView.hidden = YES;
            }
        } else {
            strongSelf.notiLabel.hidden = NO;
            strongSelf.notiLabel.text = work_notiLabelText_loadfailure;
            strongSelf.display2TableView.hidden = YES;
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.notiLabel.hidden = NO;
        strongSelf.notiLabel.text = work_notiLabelText_loadfailure;
        strongSelf.display2TableView.hidden = YES;
    }];
}


#pragma mark - lazy loading
- (NSMutableArray *)taskMonitorArray {
    if (!_taskMonitorArray) {
        _taskMonitorArray = [[NSMutableArray alloc] init];
    }
    return _taskMonitorArray;
}

- (NSMutableArray *)finialTaskMonitorArray {
    if (!_finialTaskMonitorArray) {
        _finialTaskMonitorArray = [[NSMutableArray alloc] init];
    }
    return _finialTaskMonitorArray;
}

- (NSMutableArray *)myTasksArray {
    if (!_myTasksArray) {
        _myTasksArray = [[NSMutableArray alloc] init];
    }
    return _myTasksArray;
}

- (NSMutableArray *)finialmyTasksArray {
    if (!_finialmyTasksArray) {
        _finialmyTasksArray = [[NSMutableArray alloc] init];
    }
    return _finialmyTasksArray;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, 40)];
        _topView.backgroundColor = SYSTEM_TabBar_COLOR;
        [self.view addSubview:_topView];

        [self stationView];
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(self.stationView.frame) + 20, paddingK, 1, 20)]];
        [self statusView];
    }
    return _topView;
}

//stationView
- (UIView *)stationView {
    if (!_stationView) {
        _stationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/3, 40)];
        _stationView.backgroundColor = [UIColor clearColor];
        _stationView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationViewTapAction:)];
        [_stationView addGestureRecognizer:tap];
        [self.topView addSubview:_stationView];
        
        [self stationLabel];
        [self upAndDown1ImageView];
    }
    return _stationView;
}

- (UILabel *)stationLabel {
    if (!_stationLabel) {
        _stationLabel = [UILabel addLabelWithText:@"北京西站" textColor:[UIColor whiteColor] frame:CGRectMake(20, paddingK, 80, 20) font:FONT(18) alignment:NSTextAlignmentCenter];
        [self.stationView addSubview:_stationLabel];
    }
    return _stationLabel;
}

- (UIImageView *)upAndDown1ImageView {
    if (!_upAndDown1ImageView) {
        _upAndDown1ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_down" frame:CGRectMake(CGRectGetMaxX(self.stationLabel.frame), 16, 6.5, 3)];
        [self.stationView addSubview:_upAndDown1ImageView];
    }
    return _upAndDown1ImageView;
}

- (UIView *)stationListView {
    if (!_stationListView) {
        _stationListView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight + 40, screenWidth, 50)];
        _stationListView.backgroundColor = SYSTEM_TabBar_COLOR;
        _stationListView.hidden = YES;
        [self.view addSubview:_stationListView];
        [_stationListView addSubview:[UILabel addLabelWithText:@"北京西站" textColor:[UIColor whiteColor] frame:CGRectMake(20, paddingK, 120, 30) font:FONT(23) alignment:NSTextAlignmentLeft]];
        [_stationListView addSubview:[UIImageView addImageViewWithImageName:@"ic_chose_right" frame:CGRectMake(screenWidth - paddingK - 15, 15, 15, 15)]];
        _stationListView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationListViewTapAction:)];
        [_stationListView addGestureRecognizer:tap];
    }
    return _stationListView;
}

//statusView
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stationView.frame) + 20, 0, 100, 40)];
        _statusView.backgroundColor = [UIColor clearColor];
        _statusView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusViewTapAction:)];
        [_statusView addGestureRecognizer:tap];
        [self.topView addSubview:_statusView];
        
        [self statusLabel];
        [self upAndDown2ImageView];
    }
    return _statusView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel addLabelWithText:@"全部" textColor:[UIColor whiteColor] frame:CGRectMake(20, paddingK, 80, 20) font:FONT(18) alignment:NSTextAlignmentCenter];
        [self.statusView addSubview:_statusLabel];
    }
    return _statusLabel;
}
- (UIImageView *)upAndDown2ImageView {
    if (!_upAndDown2ImageView) {
        _upAndDown2ImageView = [UIImageView addImageViewWithImageName:@"ic_chose_down" frame:CGRectMake(CGRectGetMaxX(self.statusLabel.frame), 16, 6.5, 3)];
        [self.statusView addSubview:_upAndDown2ImageView];
    }
    return _upAndDown2ImageView;
}

- (TLTaskStatusView *)statusListView {
    if (!_statusListView) {
        _statusListView = [[TLTaskStatusView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight + 40, screenWidth, 203) choosedText:@"全部"];
        _statusListView.backgroundColor = SYSTEM_TabBar_COLOR;
        _statusListView.delegate = self;
        _statusListView.hidden = YES;
        [self.view addSubview:_statusListView];
    }
    return _statusListView;
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
