//
//  TLAttachmentViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLAttachmentViewController.h"
#import "TLPhotoViewController.h"

#import "WorkDetailTableViewCell.h"
#import "TLPhotoModel.h"


@interface TLAttachmentViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_taskId;
    NSString *_jobsid;
    NSString *_joboperatorsid;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *publishView;//问题发布人上传附件 view
@property (nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, strong) NSMutableArray *publishPhotoArray;
@property (nonatomic, strong) UIImageView *publishShadowView;

@property (nonatomic, strong) UIView *operateView;//问题执行人上传附件 view
@property (nonatomic, strong) UITableView *operateTableView;
@property (nonatomic, strong) NSMutableArray *operatePhotoArray;
@property (nonatomic, strong) UIImageView *operateShadowView;

@end

@implementation TLAttachmentViewController

-(instancetype)initWithTaskId:(NSString *)taskId {
    
    self = [super init];
    if (self) {
        _taskId = taskId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"附件列表";
    [self scrollView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attachmentVcDownloadNotification:) name:@"WorkDetailCellDownloadNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self requestJobsid];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - actions
- (void)attachmentVcDownloadNotification:(NSNotification *)noti {
    TLPhotoModel *notiModel = noti.object;
    if (notiModel.photoType == photoType_publish) {
        for (NSInteger i = 0; i < self.publishPhotoArray.count; i++) {
            TLPhotoModel *model = self.publishPhotoArray[i];
            if ([model.filePath isEqualToString:notiModel.filePath]) {
                [self.publishPhotoArray replaceObjectAtIndex:i withObject:notiModel];
            }
        }
        [self.publishTableView reloadData];
    } else {
        for (NSInteger i = 0; i < self.operatePhotoArray.count; i++) {
            TLPhotoModel *model = self.operatePhotoArray[i];
            if ([model.filePath isEqualToString:notiModel.filePath]) {
                [self.operatePhotoArray replaceObjectAtIndex:i withObject:notiModel];
            }
        }
        
        [self.operateTableView reloadData];
    }
}

#pragma mark - private

#pragma mark - delegate
//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.publishTableView]) {
        return self.publishPhotoArray.count;
    } else {
        return self.operatePhotoArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkDetailTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[WorkDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WorkDetailTableViewCellIdentifier];
    }
    
    TLPhotoModel *model;
    if ([tableView isEqual:self.publishTableView]) {
        model = self.publishPhotoArray[indexPath.row];
    } else {
        model = self.operatePhotoArray[indexPath.row];
    }
    
    [cell setupWorkDetailCellWithPhotoModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLPhotoModel *model;
    if ([tableView isEqual:self.publishTableView]) {
        model = self.publishPhotoArray[indexPath.row];
    } else {
        model = self.operatePhotoArray[indexPath.row];
    }
    
    if (model.type == loadSuccessType) {
        NSString *imageFilePath;
        NSString *imageFileName;
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        imageFileName = [[model.filePath componentsSeparatedByString:@"/"] lastObject];
        imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, imageFileName];
        TLPhotoViewController *photoVc = [[TLPhotoViewController alloc] initWithImageFilePath:model.filePath];
        
        [self.navigationController pushViewController:photoVc animated:YES];
    }
}

#pragma mark - network
- (void)requestJobsid {
    
    NSString *dataStr = [[RequestManager sharedManager] getJobsidDataParameterWithTaskId:_taskId];
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
                [strongSelf requestMonitorfiles];
                [strongSelf requestOperatorfiles];
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
    
}

- (void)requestMonitorfiles {
    NSString *dataStr = [[RequestManager sharedManager] getMonitorfilesDataParameterWithJobsid:_jobsid];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            
            if (strongSelf.publishPhotoArray.count > 0) {
                [strongSelf.publishPhotoArray removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    TLPhotoModel *model = [[TLPhotoModel alloc] init];
                    model.filePath = dic[@"filepath"];
                    model.type = loadingType;
                    [strongSelf.publishPhotoArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.publishTableView.hidden = NO;
                    [strongSelf.publishView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.width.equalTo(@(screenWidth));
                        make.top.offset(20);
                        make.height.equalTo(@(40 + 50 * dataList.count));
                    }];
                    [strongSelf.publishTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.top.offset(30);
                        make.width.equalTo(@(screenWidth));
                        make.height.equalTo(@(50 * dataList.count));
                    }];
                    [strongSelf.publishShadowView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.width.equalTo(@(screenWidth));
                        make.height.equalTo(@(paddingK));
                        make.top.offset(30 + 50 * dataList.count);
                    }];
                    
                    strongSelf.scrollView.contentSize = CGSizeMake(screenWidth, 20 + CGRectGetHeight(self.publishView.frame) + 40 + ScrollViewContentSize_MoreHeight);
                    [strongSelf.publishTableView reloadData];
                });
            } else {
                strongSelf.publishTableView.hidden = YES;
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.publishTableView.hidden = YES;
    }];
}

- (void)requestOperatorfiles {
    
    NSString *dataStr = [[RequestManager sharedManager] getOperatorfilesDataParameterWithJoboperatorsid:_joboperatorsid];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.operatePhotoArray.count > 0) {
                [strongSelf.operatePhotoArray removeAllObjects];
            }
            //此处返回data 为json字符串 需要转换为字典
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:dataDic[@"dataList"]];
            if (dataList.count > 0) {
                for (NSDictionary *dic in dataList) {
                    TLPhotoModel *model = [[TLPhotoModel alloc] init];
                    model.filePath = dic[@"filepath"];
                    model.type = loadingType;
                    [strongSelf.operatePhotoArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.operateTableView.hidden = NO;
                    [strongSelf.operateView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.width.equalTo(@(screenWidth));
                        make.top.equalTo(self.publishView.mas_bottom).offset(paddingK);
                        make.height.equalTo(@(40 + 50 * dataList.count));
                    }];
                    [strongSelf.operateTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.top.offset(30);
                        make.width.equalTo(@(screenWidth));
                        make.height.equalTo(@(50 * dataList.count));
                    }];
                    [strongSelf.operateShadowView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.width.equalTo(@(screenWidth));
                        make.height.equalTo(@(paddingK));
                        make.top.offset(30 + 50 * dataList.count);
                    }];
                    
                    strongSelf.scrollView.contentSize = CGSizeMake(screenWidth, 20 + CGRectGetHeight(self.publishView.frame) + CGRectGetHeight(self.operateView.frame) + ScrollViewContentSize_MoreHeight);
                    [strongSelf.operateTableView reloadData];
                });
            } else {
                strongSelf.operateTableView.hidden = YES;
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        strongSelf.operateTableView.hidden = YES;
    }];
}

#pragma mark - lazy loading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, screenHeight - statusBarAndNavBarHeight)];
        [self.view addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth, screenHeight - statusBarAndNavBarHeight);
        
        [_scrollView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, 0, screenWidth, paddingK)]];
        
        [self publishView];
        [self operateView];
    }
    return _scrollView;
}

//
- (UIView *)publishView {
    
    if (!_publishView) {
        _publishView = [[UIView alloc] init];
        _publishView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_publishView];
        
        [_publishView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.top.offset(20);
            make.height.equalTo(@(40));
        }];
        
        [_publishView addSubview:[UILabel addLabelWithText:@"问题发布人上传附件" textColor:[UIColor whiteColor] frame:CGRectMake(15, 0, 230, 20) font:FONT(18) alignment:NSTextAlignmentLeft]];
        [self publishShadowView];
        
    }
    return _publishView;
}

- (UIImageView *)publishShadowView {
    
    if (!_publishShadowView) {
        _publishShadowView = [[UIImageView alloc] init];
        _publishShadowView.image = [UIImage imageNamed:@"bg_shadow"];
        [self.publishView addSubview:_publishShadowView];
        
        [_publishShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(paddingK));
            make.top.offset(30);
        }];
    }
    return _publishShadowView;
}

- (UITableView *)publishTableView {
    if (!_publishTableView) {
        _publishTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, screenWidth, 0) style:UITableViewStylePlain];
        _publishTableView.backgroundColor = [UIColor clearColor];
        _publishTableView.hidden = YES;
        _publishTableView.scrollEnabled = NO;
        _publishTableView.showsVerticalScrollIndicator = NO;
        _publishTableView.showsHorizontalScrollIndicator = NO;
        _publishTableView.sectionFooterHeight = 0;
        _publishTableView.sectionHeaderHeight = 0;
        _publishTableView.rowHeight = 50;
        _publishTableView.delegate = self;
        _publishTableView.dataSource = self;
        [_publishTableView setSeparatorColor:[UIColor clearColor]];
        [_publishTableView registerClass:[WorkDetailTableViewCell class] forCellReuseIdentifier:WorkDetailTableViewCellIdentifier];
        [self.publishView addSubview:_publishTableView];
        
        [_publishTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(30);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(0));
        }];
    }
    return _publishTableView;
}


- (NSMutableArray *)publishPhotoArray {
    if (!_publishPhotoArray) {
        _publishPhotoArray = [[NSMutableArray alloc] init];
    }
    return _publishPhotoArray;
}

- (NSMutableArray *)operatePhotoArray {
    if (!_operatePhotoArray) {
        _operatePhotoArray = [[NSMutableArray alloc] init];
    }
    return _operatePhotoArray;
}

- (UIView *)operateView {
    
    if (!_operateView) {
        _operateView = [[UIView alloc] init];
        _operateView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_operateView];
        
        [_operateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.top.equalTo(self.publishView.mas_bottom).offset(20);
            make.height.equalTo(@(40));
        }];
        
        [_operateView addSubview:[UILabel addLabelWithText:@"问题执行人上传附件" textColor:[UIColor whiteColor] frame:CGRectMake(15, 0, 230, 20) font:FONT(18) alignment:NSTextAlignmentLeft]];
        [self operateShadowView];
    }
    return _operateView;
}

- (UITableView *)operateTableView {
    if (!_operateTableView) {
        _operateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, screenWidth, 0) style:UITableViewStylePlain];
        _operateTableView.backgroundColor = [UIColor clearColor];
        _operateTableView.hidden = YES;
        _operateTableView.scrollEnabled = NO;
        _operateTableView.showsVerticalScrollIndicator = NO;
        _operateTableView.showsHorizontalScrollIndicator = NO;
        _operateTableView.sectionFooterHeight = 0;
        _operateTableView.sectionHeaderHeight = 0;
        _operateTableView.rowHeight = 50;
        _operateTableView.delegate = self;
        _operateTableView.dataSource = self;
        [_operateTableView setSeparatorColor:[UIColor clearColor]];
        [_operateTableView registerClass:[ WorkDetailTableViewCell class] forCellReuseIdentifier:WorkDetailTableViewCellIdentifier];
        [self.operateView addSubview:_operateTableView];
        
        [_operateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(30);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(0));
        }];
    }
    return _operateTableView;
}

- (UIImageView *)operateShadowView {
    
    if (!_operateShadowView) {
        _operateShadowView = [[UIImageView alloc] init];
        _operateShadowView.image = [UIImage imageNamed:@"bg_shadow"];
        [self.operateView addSubview:_operateShadowView];
        
        [_operateShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(paddingK));
            make.top.offset(30);
        }];
    }
    return _operateShadowView;
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
