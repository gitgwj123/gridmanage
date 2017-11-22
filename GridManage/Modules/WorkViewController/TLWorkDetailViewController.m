//
//  TLWorkDetailViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLWorkDetailViewController.h"
#import "TLPhotoViewController.h"
#import "WorkDetailTableViewCell.h"
#import "TLPhotoTableViewCell.h"
#import "TLPhotoModel.h"
#import "RequestManager+UploadImage.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
//获取相机权限
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "RequestManager+UploadImage.h"


static NSInteger const TOPView_Height = 180;
static NSInteger const CameraView_Height = 60;


@interface TLWorkDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    MyTaskModel *_myTaskModel;
    NSString *_changedTaskStutas;
    NSString *_imageFileName;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) YFRollingLabel *taskNameLabel;
@property (nonatomic, strong) UILabel *carryoutTimeLabel;
@property (nonatomic, strong) UILabel *operateLabel;
@property (nonatomic, strong) UILabel *planTimeLabel;
@property (nonatomic, strong) UILabel *realTimeLabel;

@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *imageLinkArray;
@property (nonatomic, strong) UITableView *photoTableView;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UIView *publishView;//问题发布人上传附件 view
@property (nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, strong) NSMutableArray *publishPhotoArray;
@property (nonatomic, strong) UIImageView *publishShadowView;

@property (nonatomic, strong) UIView *operateView;//问题执行人上传附件 view
@property (nonatomic, strong) UITableView *operateTableView;
@property (nonatomic, strong) NSMutableArray *operatePhotoArray;
@property (nonatomic, strong) UIImageView *operateShadowView;

@end

@implementation TLWorkDetailViewController

- (instancetype)initWithMyTaskModel:(MyTaskModel *)model {

    self = [super init];
    if (self) {
        _myTaskModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"作业详情";
 
    [self scrollView];
    [self configTopView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workDetailCellDownloadNotification:) name:@"WorkDetailCellDownloadNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestMonitorfiles];
    [self requestOperatorfiles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - actions
- (void)workDetailCellDownloadNotification:(NSNotification *)noti {

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

- (void)operateLabelTapAction:(UITapGestureRecognizer *)tap {
    
    if (![_myTaskModel.taskstatus isEqualToString:@"2"]) {
    
        NSString *title = @"";
        if ([_myTaskModel.taskstatus isEqualToString:@"0"] || [_myTaskModel.taskstatus isEqualToString:@"4"]) {
            title = @"确定要开始吗？";
        } else if ([_myTaskModel.taskstatus isEqualToString:@"1"]) {
            title = @"确定要完成吗？";
        }
        
        [TLAlert setAlertControllerWithController:self Title:title message:nil cancelActionTitle:@"取消" okActionTitle:@"确定" cancelActionHandler:^(UIAlertAction *action) {
            
        } okActionHandler:^(UIAlertAction *action) {
            if ([_myTaskModel.taskstatus isEqualToString:@"0"] || [_myTaskModel.taskstatus isEqualToString:@"4"]) {
                _changedTaskStutas = @"0";
                
            } else if ([_myTaskModel.taskstatus isEqualToString:@"1"]) {
                _changedTaskStutas = @"2";
            }
            
            //发布操作
            [self requestPublishTaskCommand];
        }];
    }
}

- (void)workDetailCameraBtnAction:(UIButton *)sender {
   
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
            [TLAlert setAlertControllerWithController:self Title:@"提示" message:@"请前往设置->隐私->相机授权应用拍照权限" okActionTitle:@"确定" okActionHandler:^(UIAlertAction *action) {
            }];
            return ;
        }
    }
    
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else {
        [TLAlert showMessage:@"没有相机" hideDelay:2 inView:self.view];
    }

}

#pragma mark - private methods
- (void)updatePhotoTableViewFromImagePickerWithData:(NSString *)imageFile {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.operateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.top.equalTo(self.publishView.mas_bottom).offset(paddingK);
            make.height.equalTo(@(40 + 50 * (self.operatePhotoArray.count+self.photoArray.count)));
        }];
        [self.operateTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(30);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(50 * self.operatePhotoArray.count));
        }];
        [self.photoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(30);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(50 * self.photoArray.count));
        }];
        [self.operateShadowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(paddingK));
            make.top.offset(30 + 50 * (self.operatePhotoArray.count + self.photoArray.count));
        }];
        
        self.scrollView.contentSize = CGSizeMake(screenWidth, TOPView_Height + CameraView_Height + CGRectGetHeight(self.publishView.frame) + CGRectGetHeight(self.operateView.frame) + ScrollViewContentSize_MoreHeight);
        self.photoTableView.hidden = NO;
        [self.photoTableView reloadData];
    });

    //上传图片
    [self uploadImageWithImageFilePath:imageFile];
}

- (NSString *)getMonitorfilesDataParameter {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"jobmonitorfilesviewinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"jobsid", @"JoinKey":@"2", @"ValueKey":_myTaskModel.jobsid}];//传入的参数
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

- (NSString *)getOperatorfilesDataParameter {

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"joboperatorfilesinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"joboperatorsid", @"JoinKey":@"2", @"ValueKey":_myTaskModel.joboperatorsid}];//传入的参数
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

- (void)configTopView {
    
    [self setupImageViewAndOperateLabelWithStutas:_myTaskModel.taskstatus];
    
    self.carryoutTimeLabel.text = [NSString getCarryoutTimeWithRealstarttime:_myTaskModel.realstarttime realendtime:_myTaskModel.realendtime];
    
    self.planTimeLabel.text = [NSString getStartTimeAndEndTimeWithStarttime:_myTaskModel.planstarttime endtime:_myTaskModel.planendtime];
    self.realTimeLabel.text = [NSString getStartTimeAndEndTimeWithStarttime:_myTaskModel.realstarttime  endtime:_myTaskModel.realendtime];
}


- (void)setupImageViewAndOperateLabelWithStutas:(NSString *)status {
    
    if ([status isEqualToString:@"0"]) {
        //未开始
        self.statusImageView.image = [UIImage imageNamed:@"ic_not_start"];
        self.operateLabel.text = @"点击开始";
        self.operateLabel.backgroundColor = [UIColor whiteColor];
    } else if ([status isEqualToString:@"1"]) {
        //进行中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.statusImageView.image = image;
        self.operateLabel.text = @"点击完成";
        self.operateLabel.backgroundColor = SYSTEM_COLOR;
    } else if ([status isEqualToString:@"2"]) {
        //已完成/待验收
        self.statusImageView.image = [UIImage imageNamed:@"ic_wait_pass"];
        self.operateLabel.text = @"待验收";
        self.operateLabel.backgroundColor = TextColor_GRAY;
    } else if ([status isEqualToString:@"3"]) {
        //验收通过
    } else if ([status isEqualToString:@"4"]) {
        //验收未通过
        self.statusImageView.image = [UIImage imageNamed:@"ic_notPass"];
        self.operateLabel.text = @"重新开始";
        self.operateLabel.backgroundColor = Saffron_Yellow_COLOR;
    }
}


- (NSString *)getPublishTaskCommandDataParameter {
    
    NSDictionary *dataDic = @{@"jobsId":_myTaskModel.jobsid, @"note":_myTaskModel.note, @"opType":_changedTaskStutas, @"opormotId":_myTaskModel.joboperatorsid, @"ssId":@"", @"taskId":_myTaskModel.tasksid, @"usersId":[TLStorage getUserId]};
    
    NSString *dataStr = [[NSString convertToJSONData:dataDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return dataStr;
}

- (void)updateOperateLabel {

    if ([_changedTaskStutas isEqualToString:@"0"]) {
        self.operateLabel.text = @"点击完成";
        self.operateLabel.backgroundColor = SYSTEM_COLOR;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.statusImageView.image = image;

    } else if ([_changedTaskStutas isEqualToString:@"2"]) {
        self.operateLabel.text = @"待验收";
        self.operateLabel.backgroundColor = TextColor_GRAY;
        self.statusImageView.image = [UIImage imageNamed:@"ic_wait_pass"];
    }
    
    _myTaskModel.taskstatus = _changedTaskStutas;
}

- (void)updatePhotoArrayWithImageFilePath:(NSString *)path loadStatus:(TLloadImageType)status {
    
    for (NSInteger i = 0; i < self.photoArray.count; i++) {
        TLPhotoModel *model = self.photoArray[i];
        if ([model.filePath isEqualToString:path]) {
            TLPhotoModel *newModel = [[TLPhotoModel alloc] init];
            newModel.filePath = path;
            newModel.type = status;
            newModel.photoType = model.photoType;
            [self.photoArray replaceObjectAtIndex:i withObject:newModel];
            break;
        }
    }
}

#pragma mark - delegate
//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([tableView isEqual:self.publishTableView]) {
        return self.publishPhotoArray.count;
    } else if([tableView isEqual:self.operateTableView] ){
        return self.operatePhotoArray.count;
    } else {
        return self.photoArray.count;
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
    if ([tableView isEqual:self.publishTableView]) {
        
        WorkDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkDetailTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[WorkDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WorkDetailTableViewCellIdentifier];
        }
        TLPhotoModel *model = self.publishPhotoArray[indexPath.row];
        [cell setupWorkDetailCellWithPhotoModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([tableView isEqual:self.operateTableView]) {
    
        TLPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLPhotoTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[TLPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLPhotoTableViewCellIdentifier];
        }
        
        TLPhotoModel *model = self.operatePhotoArray[indexPath.row];
        [cell setupPhotoTableViewCellWithImageFilePath:model.filePath loadStatusType:model.type];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.loadStatusViewTapBlock = ^(NSString *imageFilePath) {
                [self uploadImageWithImageFilePath:imageFilePath];
            };
        return cell;
    } else {
        
        WorkDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkDetailTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[WorkDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WorkDetailTableViewCellIdentifier];
        }
        
        TLPhotoModel *model = self.photoArray[indexPath.row];
        [cell setupWorkDetailCellWithPhotoModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TLPhotoModel *model;
    NSString *imageFilePath;
    NSString *imageFileName;
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([tableView isEqual:self.publishTableView]) {
        model = self.publishPhotoArray[indexPath.row];
        imageFileName = [[model.filePath componentsSeparatedByString:@"/"] lastObject];
        imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, imageFileName];
    } else if ([tableView isEqual:self.operateTableView]) {
        model = self.operatePhotoArray[indexPath.row];
        imageFileName = [[model.filePath componentsSeparatedByString:@"/"] lastObject];
        imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, imageFileName];
    }
    else {
        model = self.photoArray[indexPath.row];
        imageFilePath = model.filePath;
    }
    
    if (model.type == loadSuccessType) {
        TLPhotoViewController *photoVc = [[TLPhotoViewController alloc] initWithImageFilePath:imageFilePath];
        
        [self.navigationController pushViewController:photoVc animated:YES];
    }
}


//imagePikerControlelr delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (photo != nil) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                _imageFileName = [NSString getFilePath];
                NSString *imageFile = [NSString getImageFileWithImage:photo fileName:_imageFileName];
                TLPhotoModel *model = [[TLPhotoModel alloc] init];
                model.filePath = imageFile;
                model.type = loadingType;
                model.photoType = photoType_opreator;
                [self.photoArray addObject:model];
                [self updatePhotoTableViewFromImagePickerWithData:imageFile];
            }
        }
    } else {
        MyLog(@"该资源不是图片");
        [TLAlert showMessage:@"暂不支持非图片资源" hideDelay:2 inView:self.view];
    }
}

//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - network
- (void)uploadImageWithImageFilePath:(NSString *)imageFilePath  {
    
    WeakSelf;
    [[RequestManager sharedManager] uploadImageWithImageFilePath:imageFilePath block:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        if (isSuccessful) {
            //上传成功 hud success
            [strongSelf updatePhotoArrayWithImageFilePath:imageFilePath loadStatus:loadSuccessType];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.photoTableView reloadData];
            });
            
        } else {
            //上传失败 hud fail
            [strongSelf updatePhotoArrayWithImageFilePath:imageFilePath loadStatus:loadFailureType];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.photoTableView reloadData];
            });
        }
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
            [self updateOperateLabel];
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


- (void)requestMonitorfiles {
    NSString *dataStr = [self getMonitorfilesDataParameter];
    
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
                    model.photoType = photoType_publish;
                    [strongSelf.publishPhotoArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.publishTableView.hidden = NO;
                    [strongSelf.publishView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.width.equalTo(@(screenWidth));
                        make.top.equalTo(self.cameraView.mas_bottom).offset(paddingK);
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
                    
                    strongSelf.scrollView.contentSize = CGSizeMake(screenWidth,TOPView_Height + CameraView_Height + CGRectGetHeight(self.publishView.frame) + 40 + ScrollViewContentSize_MoreHeight);
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
    
    NSString *dataStr = [self getOperatorfilesDataParameter];
    
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
                    model.photoType = photoType_opreator;
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
                    
                    strongSelf.scrollView.contentSize = CGSizeMake(screenWidth,TOPView_Height + CameraView_Height + CGRectGetHeight(self.publishView.frame) + CGRectGetHeight(self.operateView.frame) + ScrollViewContentSize_MoreHeight);
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
        
        [self topView];
        [self cameraView];
        [self publishView];
        [self operateView];
    }
    return _scrollView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, TOPView_Height)];
        _topView.backgroundColor = SYSTEM_TabBar_COLOR;
        [self.scrollView addSubview:_topView];
        
        [self statusImageView];
        [_topView addSubview:[UIImageView addImageViewWithImageName:@"ic_loca" frame:CGRectMake((screenWidth - 90)/2, 15, 20, 20)]];
        [_topView addSubview:[UILabel addLabelWithText:@"网格任务" textColor:TextColor_GRAY frame:CGRectMake((screenWidth - 90)/2 + 25, 15, 70, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
        [_topView addSubview:[UILabel addLabelWithText:@"执行时间" textColor:TextColor_GRAY frame:CGRectMake(screenWidth - 90, paddingK, 80, 20) font:FONT(16) alignment:NSTextAlignmentCenter]];
        
        [self taskNameLabel];
        [self carryoutTimeLabel];
        [self operateLabel];
        
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(0, CGRectGetMidY(self.operateLabel.frame), (screenWidth - 100)/2, 1)]];
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(self.operateLabel.frame), CGRectGetMidY(self.operateLabel.frame), (screenWidth - 100)/2, 1)]];
        
        [_topView addSubview:[UILabel addLabelWithText:@"计划:" textColor:TextColor_GRAY frame:CGRectMake(10, CGRectGetMaxY(self.operateLabel.frame) + 15, 40, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
        [_topView addSubview:[UILabel addLabelWithBgColor:[UIColor blackColor] frame:CGRectMake(screenWidth/2 - 3, CGRectGetMaxY(self.operateLabel.frame) + 15, 1, 20)]];
        [_topView addSubview:[UILabel addLabelWithText:@"实际:" textColor:TextColor_GRAY frame:CGRectMake(screenWidth/2 + 5, CGRectGetMaxY(self.operateLabel.frame) + 15, 40, 20) font:FONT(16) alignment:NSTextAlignmentLeft]];
        
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
        
        _taskNameLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(95, 50, screenWidth - 190, 30)  textArray:@[_myTaskModel.taskname] font:[UIFont boldSystemFontOfSize:22] textColor:SYSTEM_COLOR];
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


- (UILabel *)operateLabel {
    if (!_operateLabel) {
        _operateLabel = [UILabel addLabelWithText:@"" textColor:[UIColor blackColor] frame:CGRectMake((screenWidth - 100)/2, CGRectGetMaxY(self.taskNameLabel.frame) + 15, 100, 40) font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter];
        _operateLabel.backgroundColor = [UIColor whiteColor];
        _operateLabel.layer.masksToBounds = YES;
        _operateLabel.layer.cornerRadius = 20;
        [self.topView addSubview:_operateLabel];
        
        _operateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operateLabelTapAction:)];
        [_operateLabel addGestureRecognizer:tap];
    }
    return _operateLabel;
}

- (UILabel *)planTimeLabel {
    if (!_planTimeLabel) {
        _planTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(50, CGRectGetMaxY(self.operateLabel.frame) + 15, screenWidth/2 - 55, 20) font:FONT(16) alignment:NSTextAlignmentLeft];
        [self.topView addSubview:_planTimeLabel];
    }
    return _planTimeLabel;
}

- (UILabel *)realTimeLabel {
    if (!_realTimeLabel) {
        _realTimeLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(screenWidth/2 + 45, CGRectGetMaxY(self.operateLabel.frame) + 15, screenWidth/2 - 55, 20) font:FONT(16) alignment:NSTextAlignmentLeft];
        [self.topView addSubview:_realTimeLabel];
    }
    return _realTimeLabel;
}

- (UIView *)cameraView {

    if (!_cameraView) {
        _cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + paddingK, screenWidth, 60)];
        _cameraView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_cameraView];
        
        [self cameraBtn];
        [_cameraView addSubview:[UIImageView addImageViewWithImageName:@"bg_shadow" frame:CGRectMake(0, 50, screenWidth, paddingK)]];
    }
    return _cameraView;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cameraView addSubview:_cameraBtn];
        _cameraBtn.frame = CGRectMake(30, 0, screenWidth - 60, 40);
        _cameraBtn.titleLabel.font = FONT(18);
        _cameraBtn.layer.masksToBounds = YES;
        _cameraBtn.layer.cornerRadius = 5;
        _cameraBtn.backgroundColor = Saffron_Yellow_COLOR;
        
        [_cameraBtn setTitle:@"拍照>>" forState:UIControlStateNormal];
    
        [_cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(workDetailCameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    return _cameraBtn;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;//可编辑
    }
    return _imagePickerController;
}


- (NSMutableArray *)imageLinkArray {
    if (!_imageLinkArray) {
        _imageLinkArray = [[NSMutableArray alloc] init];
    }
    return _imageLinkArray;
}
- (UITableView *)photoTableView {
    if (!_photoTableView) {
        _photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.operateTableView.frame), screenWidth, 0) style:UITableViewStylePlain];
        _photoTableView.backgroundColor = [UIColor clearColor];
        _photoTableView.hidden = YES;
        _photoTableView.scrollEnabled = NO;
        _photoTableView.showsVerticalScrollIndicator = NO;
        _photoTableView.showsHorizontalScrollIndicator = NO;
        _photoTableView.sectionFooterHeight = 0;
        _photoTableView.sectionHeaderHeight = 0;
        _photoTableView.rowHeight = 50;
        _photoTableView.delegate = self;
        _photoTableView.dataSource = self;
        [_photoTableView setSeparatorColor:[UIColor clearColor]];
        [_photoTableView registerClass:[WorkDetailTableViewCell class] forCellReuseIdentifier:WorkDetailTableViewCellIdentifier];
        [self.operateView addSubview:_photoTableView];
        
        [_photoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.bottom.offset(paddingK);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(0));
        }];
    }
    return _photoTableView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
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
            make.top.equalTo(self.cameraView.mas_bottom).offset(paddingK);
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
            make.top.equalTo(self.publishView.mas_bottom).offset(paddingK);
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
        [_operateTableView registerClass:[TLPhotoTableViewCell class] forCellReuseIdentifier:TLPhotoTableViewCellIdentifier];
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
