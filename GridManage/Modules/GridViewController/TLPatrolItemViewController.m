//
//  TLPatrolItemViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPatrolItemViewController.h"
#import "TLAddTroubleViewController.h"

#import "TLPatrolItemTableViewCell.h"
#import "PatrolItemModel.h"


static NSInteger const space_key = 30;
static NSInteger const commitWidth = 60;
static NSInteger const startLabelWidth = 50;


@interface TLPatrolItemViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *_deviceState;
    NSString *_patrolDetailId;
    
}

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *finishLabel;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *patrolId;
@property (nonatomic, assign) NSInteger finishCount;
@property (nonatomic, assign) NSInteger itemsCount;

@end

@implementation TLPatrolItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"巡视项目";
    
    [self descriptionView];
    [self configTableView];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
   
    [self setPatrolTime];
    
    [self requestPatrolIdItems];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init
- (instancetype)initWithPatrolId:(NSString *)patrolId finishCount:(NSString *)finishCount itemsCount:(NSString *)itemsCount {

    self = [super init];
    if (self) {
        self.patrolId = patrolId;
        self.finishCount = [finishCount integerValue];
        self.itemsCount = [itemsCount integerValue];
    }
    
    return self;
}

#pragma mark - private methods 
- (void)configTableView {

    self.displayTableView.frame = CGRectMake(0, statusBarAndNavBarHeight + 40, screenWidth, screenHeight - statusBarAndNavBarHeight - 40);
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    [self.displayTableView registerClass:[TLPatrolItemTableViewCell class] forCellReuseIdentifier:TLPatrolItemTableViewCellIdentifier];
    
    //下拉刷新
    self.displayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestPatrolIdItems];
    }];
}

- (void)setPatrolTime {

    NSDictionary * patrolTimeDic = [[TLPatrolTimeManager sharedManager] getPatrolTimeWithPatrolId:self.patrolId];
    
    if (patrolTimeDic.count > 0) {
        self.startLabel.text = patrolTimeDic[@"startTime"];
        self.finishLabel.text = patrolTimeDic[@"finishTime"];
    } else {
        self.startLabel.text = @"--:--";
        self.finishLabel.text = @"--:--";
    }
}

- (void)submitSuccessSetPatrolTime {

    NSInteger i = [self completePatrolItemsNum];
    if (self.finishCount == 0 && i == 0)  {
        //提交完成第一项后 记录到位时间
        NSString *startTime = [IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat5 timeZone:[NSTimeZone localTimeZone]];
        self.startLabel.text = startTime;
        [[TLPatrolTimeManager sharedManager] savePatrolTimeWithpatrolTimeDictionary:@{@"patrolId":self.patrolId,  @"startTime":startTime, @"finishTime":@"--:--"}];
    } else if (i == self.itemsCount - 1) {
        //提交完成最后一项后 记录完成时间
        NSString *finishTime = [IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat5 timeZone:[NSTimeZone localTimeZone]];
        self.finishLabel.text = finishTime;
        [[TLPatrolTimeManager sharedManager] savePatrolTimeWithpatrolTimeDictionary:@{@"patrolId":self.patrolId,  @"startTime":self.startLabel.text, @"finishTime":finishTime}];
    }
}

- (NSInteger)completePatrolItemsNum {
    NSInteger i = 0;//记录进入巡视项目界面后 提交成功前的已巡视项目数
    for (PatrolItemModel *model in self.dataList) {
        if (![model.devicestate isEqualToString:@"未操作"]) {
            i++;
        }
    }
    return i;
}


#pragma mark - delegate
//tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
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
        
    TLPatrolItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLPatrolItemTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[TLPatrolItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLPatrolItemTableViewCellIdentifier];
    }

    [cell setupPatrolCellWithPatrolItemModel:self.dataList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.deviceStateImageViewBlock = ^(NSString *patrolDetailId, BOOL isNormal) {
        
        PatrolItemModel *model = self.dataList[indexPath.row];
        if ([model.devicestate isEqualToString:@"未操作"]) {
            _patrolDetailId = patrolDetailId;
            [self setDeviceStateWithState:isNormal];
        }
    };
    
    return cell;
}

- (void)setDeviceStateWithState:(BOOL)isNormal {
    
    if (isNormal) {
        _deviceState = @"WORK";
        [self requestSubmit];
    } else {
        _deviceState = @"FAILURE";
        [self addTroubleAlert];
    }
}

- (void)addTroubleAlert {
   
    [TLAlert setAlertControllerWithController:self Title:@"是否添加问题描述" message:@"" cancelActionTitle:@"取消" okActionTitle:@"确定" cancelActionHandler:^(UIAlertAction *action) {
        [self requestSubmit];
    } okActionHandler:^(UIAlertAction *action) {
        [self pushAddTroubleVc];
    }];
}

- (void)pushAddTroubleVc {

    self.hidesBottomBarWhenPushed = YES;
    TLAddTroubleViewController *addTroubleVc = [[TLAddTroubleViewController alloc] initWithPatrolDetailId:_patrolDetailId deviceState:_deviceState];
    addTroubleVc.patrolId = self.patrolId;
    addTroubleVc.finishCount = self.finishCount;
    addTroubleVc.itemsCount = self.itemsCount;
    addTroubleVc.completePatrolItemsNum = [self completePatrolItemsNum];
    [self.navigationController pushViewController:addTroubleVc animated:YES];
}

#pragma mark - network

- (void)requestSubmit {
    
    NSDictionary *finalParameters = @{@"patrolDetailId":_patrolDetailId, @"userId":[TLStorage getUserId], @"teamId":[TLStorage getTeamId], @"deviceState":_deviceState, @"problemTypeId":@"", @"problemImageLink":@"", @"comment":@"", @"deviceId":@"", @"deviceName":@""};
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:finalParameters withURL:TLRequestUrlPatrolSubmit responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            //提交成功 重新请求巡视项目 刷新列表
            [strongSelf submitSuccessSetPatrolTime];
            [strongSelf requestPatrolIdItems];
        }
        
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
}

//requestPatrolIdItems
- (void)requestPatrolIdItems {

     [self.displayTableView.mj_header endRefreshing];
    
    NSString *dataStr = [[RequestManager sharedManager] getItemsListDataParameterWithPatrolId:self.patrolId];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data" : dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.dataList.count > 0) {
                [strongSelf.dataList removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSArray *dataArr = dataDic[@"dataList"];
            if (dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    PatrolItemModel *model = [PatrolItemModel yy_modelWithDictionary:dic];
                    [strongSelf.dataList addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.displayTableView reloadData];
                });
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
}


#pragma mark - lazy loading
- (NSMutableArray *)dataList {

    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UIView *)descriptionView {
    
    if (!_descriptionView) {
        _descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, 40)];
        _descriptionView.backgroundColor = SYSTEM_TabBar_COLOR;
        
        [_descriptionView addSubview: [UILabel addLabelWithText:@"到位时间" textColor:[UIColor grayColor] frame:CGRectMake(space_key, paddingK, commitWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter]];
        [_descriptionView addSubview: [UILabel addLabelWithText:@"完成时间" textColor:[UIColor grayColor] frame:CGRectMake(screenWidth - space_key - startLabelWidth - paddingK - commitWidth, paddingK, commitWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter]];
        
        [self startLabel];
        [self finishLabel];
        [self.view addSubview:_descriptionView];
    }
    return _descriptionView;
}

- (UILabel *)startLabel {

    if (!_startLabel) {
        _startLabel = [UILabel addLabelWithText:@"--:--" textColor:[UIColor whiteColor] frame:CGRectMake(space_key + commitWidth + paddingK, paddingK, startLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        [self.descriptionView addSubview:_startLabel];
    }
    
    return _startLabel;
    
}

- (UILabel *)finishLabel {
    
    if (!_finishLabel) {
        _finishLabel = [UILabel addLabelWithText:@"--:--" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth - space_key - startLabelWidth, paddingK, startLabelWidth, 20) font:FONT(14) alignment:NSTextAlignmentCenter];
        [self.descriptionView addSubview:_finishLabel];
    }
    
    return _finishLabel;
    
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
