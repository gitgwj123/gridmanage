//
//  TLGridViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/2.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLGridViewController.h"
#import "TLPatrolItemViewController.h"
#import "TLAttachmentViewController.h"

#import "TLPatrolTableViewCell.h"
#import "PatrolModel.h"

#import "TLTroubleManageTableViewCell.h"
#import "TLTroubleManageCell.h"
#import "TroubleManageModel.h"


static NSString  *notiLabelText_notdata = @"没有数据，点击重新获取";
static NSString  *notiLabelText_loadfailure = @"加载失败，点击重试";

@interface TLGridViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    TroubleManageModel *_troubleManageModel;
    NSString *_changedTaskStutas;
    NSString *_taskId;
    NSString *_jobsid;
    NSString *_joboperatorsid;
}


@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) NSMutableArray *allTasksArray;
@property (nonatomic, strong) NSMutableArray *pointTasksArray;
@property (nonatomic, strong) NSMutableArray *troubleList;

@property (nonatomic, assign) BOOL isDisplayTableView;

@end

@implementation TLGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [self setTitleViewWithItems:@[@"巡视计划", @"问题管理"]];
    self.isDisplayTableView = YES;
    self.notiLabel.text = notiLabelText_notdata;
    
    [self descriptionView];
    
    [self configDisplayTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isDisplayTableView) {
        [self requestBaseCondition];
    } else {
        [self requestTroubleMamage];
    }
    
}

#pragma mark - action
- (void)segmentControlAction:(UISegmentedControl *)segmentControl {
    
    if (segmentControl.selectedSegmentIndex == 0) {
        self.descriptionLabel.text = [self getCurrentDayDateDescription];
        self.isDisplayTableView = YES;
        
        self.display2TableView.hidden = YES;
        [self requestBaseCondition];
        
    } else {
        self.descriptionLabel.text = @"问题列表";
        self.isDisplayTableView = NO;
        
        self.displayTableView.hidden = YES;
        [self requestTroubleMamage];
    }
}

- (void)notiLabelTapAction:(UITapGestureRecognizer *)tap {

    if (self.isDisplayTableView) {
        [self requestBaseCondition];
    } else {
        [self requestTroubleMamage];
    }
}


#pragma mark - private methods
- (NSString *)getCurrentDayDateDescription {

    NSString *str = [IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat1 timeZone:[NSTimeZone localTimeZone]];
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    NSString *currentDay = [NSString stringWithFormat:@"%@年%@月%@日巡视计划", arr[0], arr[1], arr[2]];
    
    return currentDay;
}

- (void)configDisplayTableView {
    
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    self.displayTableView.rowHeight = 140;
    [self.displayTableView registerClass:[TLPatrolTableViewCell class] forCellReuseIdentifier:TLPatrolTableViewCellIdentifier];
    //下拉刷新
    self.displayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBaseCondition];
    }];
    
    self.display2TableView.delegate = self;
    self.display2TableView.dataSource = self;
    self.display2TableView.estimatedRowHeight = 250;
    self.display2TableView.rowHeight = UITableViewAutomaticDimension;
    [self.display2TableView registerNib:[UINib nibWithNibName:NSStringFromClass([TLTroubleManageCell class]) bundle:nil] forCellReuseIdentifier:TLTroubleManageCellIdentifier];
    //下拉刷新
    self.display2TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestTroubleMamage];
    }];

    self.display2TableView.hidden = YES;
}

- (void)pushTLPatrolItemViewControllerWithIndex:(NSInteger)index {
    PatrolModel *model = self.pointTasksArray[index];
    TLPatrolItemViewController *patrolItemVc = [[TLPatrolItemViewController alloc] initWithPatrolId:model.patrolId finishCount:model.finishcount itemsCount:model.itemscount];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:patrolItemVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//匹配蓝牙任务
- (void)matchBluetoothId {
    
    if (self.pointTasksArray.count > 0) {
        [self.pointTasksArray removeAllObjects];
    }
    
    NSString *bluetoothid = @"12:3B:6A:1A:C3:85";
    
    for (PatrolModel *model in self.allTasksArray) {
        if ([model.bluetoothid isEqualToString:bluetoothid]) {
            [self.pointTasksArray addObject:model];
        }
    }
}

//拼接问题管理 data参数
- (NSString *)getTroubleManageDataParameter {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"taskinfo" forKey:@"ViewName"];
    
    NSArray *orderByArr = @[@{@"Field":@"planstarttime", @"Mode":@"1"}];
    NSString *orderByArrStr = [NSString convertToJSONData:orderByArr];
    NSString *orderBy = [orderByArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:orderBy forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"monitorteamid", @"JoinKey":@"0", @"ValueKey":[TLStorage getTeamId]}];//传入的参数teamId
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"taktype", @"JoinKey":@"2", @"ValueKey":@"3"}];
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//拼接巡视计划 data参数
- (NSString *)getPatrolPlanDataParameter {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"patrolsviewinfo" forKey:@"ViewName"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@{@"FieldKey":@"0", @"Fields":@"teamid", @"JoinKey":@"0", @"ValueKey":[TLStorage getTeamId]}];//传入的参数teamId
    [dataArray addObject:@{@"FieldKey":@"0", @"Fields":@"createdate", @"JoinKey":@"2", @"ValueKey":[IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat1 timeZone:[NSTimeZone localTimeZone]]}];//传入的参数：年-月-日
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

- (NSString *)getPublishTaskCommandDataParameter {
    
    NSDictionary *dataDic = @{@"jobsId":_jobsid, @"note":_troubleManageModel.notes, @"opType":_changedTaskStutas, @"opormotId":_joboperatorsid, @"ssId":@"", @"taskId":_troubleManageModel.tasksid, @"usersId":[TLStorage getUserId]};
    
    NSString *dataStr = [[NSString convertToJSONData:dataDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return dataStr;
}

- (NSString *)getJobsidDataParameter {

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"joboperatorsviewinfo" forKey:@"ViewName"];
    
    NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"tasksid", @"JoinKey":@"2", @"ValueKey":_taskId}];//传入的参数tasksid
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [[NSString convertToJSONData:dataDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}


#pragma mark - delegate
//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDisplayTableView) {
        return self.pointTasksArray.count;
    } else {
        return self.troubleList.count;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isDisplayTableView) {
//        return 140;
//    } else {
//        return 250;
//    }
//}

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
        
        TLPatrolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLPatrolTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[TLPatrolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLPatrolTableViewCellIdentifier];
        }
        
        [cell setupPatrolCellWithPatrolModel:self.pointTasksArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
    
        TLTroubleManageCell *cell = [tableView dequeueReusableCellWithIdentifier:TLTroubleManageCellIdentifier];
        
        if (!cell) {
            cell = [[TLTroubleManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLTroubleManageCellIdentifier];
        }
        
        //[cell setupTroubleManageCellWithTroubleManageModel:self.troubleList[indexPath.row]];
        cell.model = self.troubleList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WeakSelf;
        cell.troubleManageCellBtnBlock = ^(TroubleManageModel *troubleManageModel, NSString *changedTaskStatus) {
            _troubleManageModel = troubleManageModel;
            _changedTaskStutas = changedTaskStatus;
            _taskId = troubleManageModel.tasksid;
            [weakSelf requestJobsid];
        };
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDisplayTableView) {
        PatrolModel *model = self.pointTasksArray[indexPath.row];
        [TLStorage setPointName:model.pointname];
        [self pushTLPatrolItemViewControllerWithIndex:indexPath.row];
    }
    
}


#pragma mark - network
- (void)requestJobsid {

    NSString *dataStr = [self getJobsidDataParameter];
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                NSDictionary *dataDic = [dataList firstObject];
                _jobsid = dataDic[@"jobsid"];
                _joboperatorsid = dataDic[@"joboperatorsid"];
                [strongSelf requestPublishTaskCommand];
            }
        } 
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];

}

- (void)requestPublishTaskCommand {
    
    NSString *dataStr = [self getPublishTaskCommandDataParameter];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:@{@"token":[TLStorage getToken], @"time":@"1",@"data":dataStr,  @"hash":[TLStorage getHash], @"opeCode":@"202"} withURL:TLRequestUrlPublishTaskCommand responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            //提交成功 刷新界面
            [strongSelf requestTroubleMamage];
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


//拉取所有的基础任务
- (void)requestBaseCondition {

    [self.displayTableView.mj_header endRefreshing];
    NSString *dataStr = [self getPatrolPlanDataParameter];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            
            if (strongSelf.allTasksArray.count > 0) {
                [strongSelf.allTasksArray removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    PatrolModel *patrolModel = [PatrolModel yy_modelWithDictionary:dic];
                    [strongSelf.allTasksArray addObject:patrolModel];
                }
                
                [strongSelf matchBluetoothId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.notiLabel.hidden = YES;
                    strongSelf.displayTableView.hidden = NO;
                    [strongSelf.displayTableView reloadData];
                });
            } else {
                strongSelf.notiLabel.hidden = NO;
                strongSelf.notiLabel.text = notiLabelText_notdata;
                strongSelf.displayTableView.hidden = YES;
            }
        } else {
            strongSelf.notiLabel.hidden = NO;
            strongSelf.notiLabel.text = notiLabelText_loadfailure;
            strongSelf.displayTableView.hidden = YES;
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.notiLabel.hidden = NO;
        strongSelf.notiLabel.text = notiLabelText_loadfailure;
        strongSelf.displayTableView.hidden = YES;
    }];
}


//请求问题管理
- (void)requestTroubleMamage {

    [self.display2TableView.mj_header endRefreshing];
    
    NSString *dataStr = [self getTroubleManageDataParameter];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.troubleList.count > 0) {
                [strongSelf.troubleList removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    if (![dic[@"taskstatus"] isEqualToString:@"3"]) {
                        TroubleManageModel *troubleManageModel = [TroubleManageModel yy_modelWithDictionary:dic];
                        if ([troubleManageModel.notes isEqualToString:@""]) {
                            troubleManageModel.notes = @"      ";
                        }
                        [strongSelf.troubleList addObject:troubleManageModel];
                    }
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.notiLabel.hidden = YES;
                    strongSelf.display2TableView.hidden = NO;
                    [strongSelf.display2TableView reloadData];
                });
            } else {
                strongSelf.notiLabel.hidden = NO;
                strongSelf.notiLabel.text = notiLabelText_notdata;
                strongSelf.display2TableView.hidden = YES;
            }
        } else {
            strongSelf.notiLabel.hidden = NO;
            strongSelf.notiLabel.text = notiLabelText_loadfailure;
            strongSelf.display2TableView.hidden = YES;
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.notiLabel.hidden = NO;
        strongSelf.notiLabel.text = notiLabelText_loadfailure;
        strongSelf.display2TableView.hidden = YES;
    }];
}


#pragma mark - lazy loading
- (UIView *)descriptionView {

    if (!_descriptionView) {
        _descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, 40)];
        _descriptionView.backgroundColor = SYSTEM_TabBar_COLOR;
        [_descriptionView addSubview:[self descriptionLabel]];
        [self.view addSubview:_descriptionView];
    }
    return _descriptionView;
}

-(UILabel *)descriptionLabel {

    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingK, paddingK, screenWidth - 20, 20)];
        _descriptionLabel.text = [self getCurrentDayDateDescription];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = FONT(18);
    }
    
    return _descriptionLabel;
}


- (NSMutableArray *)allTasksArray {
    
    if (!_allTasksArray) {
        _allTasksArray = [[NSMutableArray alloc] init];
    }
    return _allTasksArray;
}

- (NSMutableArray *)pointTasksArray {
    
    if (!_pointTasksArray) {
        _pointTasksArray = [[NSMutableArray alloc] init];
    }
    return _pointTasksArray;
}

- (NSMutableArray *)troubleList {
    
    if (!_troubleList) {
        _troubleList = [[NSMutableArray alloc] init];
    }
    return _troubleList;
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
