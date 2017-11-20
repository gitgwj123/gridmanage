//
//  TLAddTroubleViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLAddTroubleViewController.h"
#import "TLScanQRCodeViewController.h"
#import "TLPhotoViewController.h"
#import "BaseViewController+BackButtonHandler.h"

#import "TroubleSubclassModel.h"

#import "UITextView+ZWPlaceHolder.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
//获取相机权限
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "RequestManager+UploadImage.h"

#import "TLPhotoTableViewCell.h"
#import "TLPhotoModel.h"

static NSInteger const labelWidth_KEY = 80;

@interface TLAddTroubleViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    NSString *_deviceState;
    NSString *_patrolDetailId;
    
    NSString *_classificationid;
    NSString *_problemTypeId;
    NSString *_deviceId;
    
    NSString *_imageFileName;
    
    NSInteger _pickerViewSelectedRow;
    TroubleSubclassModel *_troubleSubclassModel;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UILabel *areaNameLabel;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UIButton *scanQRCodeBtn;
@property (nonatomic, strong) UILabel *subclassLabel;
@property (nonatomic, strong) UILabel *priorityLabel;
@property (nonatomic, strong) UILabel *solveTimeLimitLabel;

@property (nonatomic, strong) UITextView *troubleDescriptionTextView;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIImagePickerController *imagePikerController;
@property (nonatomic, strong) NSMutableArray *imageLinkArray;

@property (nonatomic, strong) NSMutableArray *subclassArray;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *bgPickerView;
@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UITableView *photoTableView;
@property (nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation TLAddTroubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加问题";
    [self addRightBarButtonItemWithTitle:@"上报" titleColor:SYSTEM_COLOR];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
-(instancetype)initWithPatrolDetailId:(NSString *)patrolDetailId deviceState:(NSString *)deviceState {

    self = [super init];
    if (self) {
        _patrolDetailId = patrolDetailId;
        _deviceState = deviceState;
    }
    return self;
}

#pragma mark - private methods 
- (void)configUI {

    [self scrollView];

    [self coverView];
    [self bgPickerView];
    
}


//拼接设备ID data参数
- (NSString *)getDeviceNameParameterWithDeviceId:(NSString *)deviceId {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"deviceinfo" forKey:@"ViewName"];
    
    NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"id", @"JoinKey":@"2", @"ValueKey":deviceId}];//传入的参数deviceId
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//拼接设备子类 data参数
- (NSString *)getDeviceTroubleSubclassParameter {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"999999" forKey:@"PageSize"];
    [dataDic setObject:@"1" forKey:@"PageStart"];
    [dataDic setObject:@"problemtypeinfo" forKey:@"ViewName"];
    
     NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"classificationId", @"JoinKey":@"2", @"ValueKey":_classificationid}];//传入的参数classificationId

    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

- (NSString *)getProblemImageLink {

    if (!_imageFileName) {
        _imageFileName = @"";
    }
    NSDictionary *imageLinkDic = @{@"fileName":_imageFileName, @"fileType":@"0"};
    [self.imageLinkArray addObject:imageLinkDic];
    NSString *dataArrStr = [NSString convertToJSONData:self.imageLinkArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return dataArrSSS;
}

- (void)submitSuccessSetPatrolTime {
    
    if (self.finishCount == 0 && self.completePatrolItemsNum == 0)  {
        //提交完成第一项后 记录到位时间
        NSString *startTime = [IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat5 timeZone:[NSTimeZone localTimeZone]];
        [[TLPatrolTimeManager sharedManager] savePatrolTimeWithpatrolTimeDictionary:@{@"patrolId":self.patrolId,  @"startTime":startTime, @"finishTime":@"--:--"}];
    } else if (self.completePatrolItemsNum == self.itemsCount - 1) {
        //提交完成最后一项后 记录完成时间
        NSString *finishTime = [IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat5 timeZone:[NSTimeZone localTimeZone]];
        NSDictionary *patrolTimeDic = [[TLPatrolTimeManager sharedManager] getPatrolTimeWithPatrolId:self.patrolId];
        NSMutableDictionary *finialPatrolTime = [[NSMutableDictionary alloc] init];
        [finialPatrolTime setValue:patrolTimeDic[@"patrolId"] forKey:@"patrolId"];
        [finialPatrolTime setValue:patrolTimeDic[@"startTime"] forKey:@"startTime"];
        [finialPatrolTime setValue:finishTime forKey:@"finishTime"];
        [[TLPatrolTimeManager sharedManager] savePatrolTimeWithpatrolTimeDictionary:finialPatrolTime];
    }
}


- (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

- (void)updatePhotoArrayWithImageFilePath:(NSString *)path loadStatus:(TLloadImageType)status {
    
    for (NSInteger i = 0; i < self.photoArray.count; i++) {
        TLPhotoModel *model = self.photoArray[i];
        if ([model.filePath isEqualToString:path]) {
            TLPhotoModel *newModel = [[TLPhotoModel alloc] init];
            newModel.filePath = path;
            newModel.type = status;
            [self.photoArray replaceObjectAtIndex:i withObject:newModel];
            break;
        }
    }
}

- (void)hidePickerView {

    self.coverView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.bgPickerView.frame = CGRectMake(0, screenHeight, screenWidth, 250);
    }];

}

#pragma mark - action
- (void)rightNavigationBarItemAction:(UIButton *)sender {

    if ([self.deviceNameLabel.text isEqualToString:@""] || [self.subclassLabel.text isEqualToString:@""]) {
        [TLAlert showMessage:@"请先完善信息" hideDelay:2 inView:self.view];
        return;
    } else {
        [self addTroubleVcRequestSubmit];
    }
}

- (void)deviceNameLabelTapAction:(UITapGestureRecognizer *)tap {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入设备ID" message:@"" preferredStyle:UIAlertControllerStyleAlert];
   
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.deviceNameLabel.text = @"";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *deviceIdField = alertController.textFields.firstObject;
        _deviceId = deviceIdField.text;
        [self requestTroubleDeviceNameWithDeviceId:deviceIdField.text];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)scanQRCodeBtnAction:(UIButton *)btn {

    //显示扫描界面
    TLScanQRCodeViewController *scanVc = [[TLScanQRCodeViewController alloc] init];
    scanVc.hidesBottomBarWhenPushed = YES;
    scanVc.scanQRcodeBlock = ^(NSString *scanResult) {
        
        self.deviceNameLabel.text = scanResult;
    };
    [self.navigationController pushViewController:scanVc animated:YES];
}

- (void)coverViewTapAction:(UITapGestureRecognizer *)tap {
    [self hidePickerView];
}

- (void)cancelViewTapAction:(UITapGestureRecognizer *)tap {
    [self hidePickerView];
}

- (void)okBtnAction:(UIButton *)sender {
    [self hidePickerView];
    
    self.subclassLabel.text = _troubleSubclassModel.troubleTypename;
    self.priorityLabel.text = _troubleSubclassModel.priority;
    self.solveTimeLimitLabel.text = _troubleSubclassModel.plancosttime;
    _problemTypeId = _troubleSubclassModel.problemTypeId;
}


- (void)cameraBtnAction:(UIButton *)sender {

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
        self.imagePikerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePikerController animated:YES completion:nil];
    }
    else {
        [TLAlert showMessage:@"没有相机" hideDelay:2 inView:self.view];
    }
}

- (void)subclassLabelTapAction:(UITapGestureRecognizer *)tap {

    if ([self.deviceNameLabel.text isEqualToString:@""]) {
        [TLAlert showMessage:@"请先添加设备" hideDelay:2 inView:self.view];
    } else {
        [self requestDeviceTroubleSubclass];
    }
}


#pragma mark - delegate
- (BOOL)navigationShouldPopOnBackButton {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"退出之后将清空所填数据，确定退出吗？"
                               delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    return NO;
}
// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.deviceNameLabel.isFirstResponder) {
            [self.deviceNameLabel resignFirstResponder];
        }
        if (self.notiLabel.isFirstResponder) {
            [self.notiLabel resignFirstResponder];
        }
        if (self.deviceNameLabel.isFirstResponder) {
            [self.deviceNameLabel resignFirstResponder];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//textView delegate
//文本改变是否显示
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
// 结束编辑
    CGFloat height = [self heightForString:textView.text andWidth:screenWidth - 2 * paddingK];
    
    [self.troubleDescriptionTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(self.descriptionView.mas_bottom).offset(paddingK);
        make.width.equalTo(@(screenWidth - 2 * paddingK));
        make.height.equalTo(@(height));
    }];
    CGFloat offPoint = self.scrollView.contentOffset.y;
    self.scrollView.contentOffset = CGPointMake(0, offPoint + height);
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight - statusBarAndNavBarHeight + height);
    
    self.navigationItem.rightBarButtonItem = nil;
    [self addRightBarButtonItemWithTitle:@"上报" titleColor:SYSTEM_COLOR];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    
    self.navigationItem.rightBarButtonItem = done;
    
}


- (void)leaveEditMode {
    
    [self.troubleDescriptionTextView resignFirstResponder];
    
}

//pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.subclassArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerViewSelectedRow = row;
    _troubleSubclassModel = self.subclassArray[row];
    [pickerView reloadAllComponents];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 2) {
            singleLine.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f];
        }
    }
    
    TroubleSubclassModel *model = self.subclassArray[row];
    
    //设置文字的属性（改变picker中字体的颜色大小）
    UILabel *reasonLabel = [UILabel new];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    reasonLabel.text = model.troubleTypename;
    reasonLabel.font = [UIFont systemFontOfSize:18];
    reasonLabel.textColor = TextColor_GRAY;
    //改变选中行颜色（设置一个全局变量，在选择结束后获取到当前显示行，记录下来，刷新picker）
    if (row == _pickerViewSelectedRow) {
        //改变当前显示行的字体颜色，如果你愿意，也可以改变字体大小，状态
        reasonLabel.textColor = SYSTEM_COLOR;
    }
    
    return reasonLabel;
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
                [self.photoArray addObject:model];
                
                CGSize size = self.scrollView.contentSize;
                self.scrollView.contentSize = CGSizeMake(screenWidth, size.height + 50);
                [self.photoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.top.equalTo(self.cameraBtn.mas_bottom).offset(30);
                    make.width.equalTo(@(screenWidth));
                    make.height.equalTo(@(50 * self.photoArray.count));
                }];
                //上传图片
                self.photoTableView.hidden = NO;
                [self uploadImageWithImageFilePath:imageFile];
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

//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoArray.count;
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

    TLPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TLPhotoTableViewCellIdentifier];
        
    if (!cell) {
        cell = [[TLPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TLPhotoTableViewCellIdentifier];
    }
    NSDictionary *dic = self.photoArray[indexPath.row];
    [cell setupPhotoTableViewCellWithImageFilePath:dic[@"imageFilePath"] loadStatusType:[dic[@"loadStatusType"] integerValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.loadStatusViewTapBlock = ^(NSString *imageFilePath) {
        [self uploadImageWithImageFilePath:imageFilePath];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.photoArray[indexPath.row];
    TLPhotoViewController *photoVc = [[TLPhotoViewController alloc] initWithImageFilePath:dic[@"imageFilePath"]];
    
    [self.navigationController pushViewController:photoVc animated:YES];
}


#pragma mark - network
- (void)requestTroubleDeviceNameWithDeviceId:(NSString *)deviceId {

    NSString *dataStr = [self getDeviceNameParameterWithDeviceId:deviceId];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data":dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSArray *dataArray = dataDic[@"dataList"];
            
            if (dataArray.count > 0) {
                strongSelf.deviceNameLabel.text = [dataArray firstObject][@"devicename"];
                _classificationid = [dataArray firstObject][@"classificationid"];
            } else {
                strongSelf.deviceNameLabel.text = @"";
                [TLAlert showMessage:@"设备不匹配" hideDelay:2 inView:strongSelf.view];
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
}

- (void)requestDeviceTroubleSubclass {
   
    NSString *dataStr = [self getDeviceTroubleSubclassParameter];
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] findByBaseConditionRequest:@{@"data": dataStr} withURL:TLRequestUrlFindByBaseCondition responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            if (strongSelf.subclassArray.count > 0) {
                [strongSelf.subclassArray removeAllObjects];
            }
            
            NSDictionary *dataDic = [NSString dictionaryWithJsonString:data];
            NSArray *dataArray = dataDic[@"dataList"];
            if (dataArray.count > 0) {
                for (NSDictionary *dic in dataArray) {
                    TroubleSubclassModel *model = [TroubleSubclassModel yy_modelWithDictionary:dic];
                    [strongSelf.subclassArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.coverView.hidden = NO;
                    [strongSelf.pickerView reloadAllComponents];
                    _troubleSubclassModel = [strongSelf.subclassArray firstObject];
                    [UIView animateWithDuration:0.5 animations:^{
                        strongSelf.bgPickerView.frame = CGRectMake(0, screenHeight - 250, screenWidth, 250);
                    }];
                });
            }
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
    }];
}

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

- (void)addTroubleVcRequestSubmit {
    
    NSDictionary *finalParameters = @{@"patrolDetailId":_patrolDetailId, @"userId":[TLStorage getUserId], @"teamId":[TLStorage getTeamId], @"deviceState":_deviceState, @"problemTypeId":_problemTypeId, @"problemImageLink":[self getProblemImageLink], @"comment":self.troubleDescriptionTextView.text, @"deviceId":_deviceId, @"deviceName":self.deviceNameLabel.text};
    
    [self networkStartLoad:self.view animated:YES];
    WeakSelf;
    [[RequestManager sharedManager] performBasicRequest:finalParameters withURL:TLRequestUrlPatrolSubmit responseBlock:^(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data) {
        
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
        if (isSuccessful) {
            //提交成功 返回上级界面
            [strongSelf submitSuccessSetPatrolTime];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf networkStopLoad:strongSelf.view animated:YES];
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
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth, 360);
        
        [self descriptionView];//固定
        [self troubleDescriptionTextView];
        [self lineLabel];
        [self cameraBtn];
    }
    return _scrollView;
}

- (UIView *)descriptionView {
    if (!_descriptionView) {
        _descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 205)];
        [self.scrollView addSubview:_descriptionView];
        
        for (NSInteger i = 0; i < 5; i++) {
            [_descriptionView addSubview:[UILabel addLabelWithBgColor:[UIColor whiteColor] frame:CGRectMake(5, (i + 1) * (2 * paddingK + 20), screenWidth - 10, 1)]];//20：文字label高度
        }
        NSArray *titleArray = @[@"地       点:", @"设备名称:", @"子       类:", @"等       级:", @"解决时限:"];
        for (NSInteger i = 0; i < 5; i++) {
             [_descriptionView addSubview:[UILabel addLabelWithText:titleArray[i] textColor:TextColor_GRAY frame:CGRectMake(paddingK, paddingK + 41 * i, labelWidth_KEY, 20) font:FONT(18) alignment:NSTextAlignmentLeft]];
        }
       
        [_descriptionView addSubview:[UIImageView addImageViewWithImageName:@"ic_right" frame:CGRectMake(screenWidth - paddingK - 15, CGRectGetMaxY(self.deviceNameLabel.frame) + 2 * paddingK + 1, 15, 20)]];
        
        [self areaNameLabel];
        [self deviceNameLabel];
        [self scanQRCodeBtn];
        [self subclassLabel];
        [self priorityLabel];
        [self solveTimeLimitLabel];
        }
    return _descriptionView;
}

-(UILabel *)areaNameLabel {
    if (!_areaNameLabel) {
        _areaNameLabel = [UILabel addLabelWithText:[TLStorage getPointName] textColor:[UIColor whiteColor] frame:CGRectMake(paddingK + labelWidth_KEY + paddingK, paddingK, screenWidth - labelWidth_KEY - 3 * paddingK, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.descriptionView addSubview:_areaNameLabel];
    }
    return _areaNameLabel;
}

-(UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.areaNameLabel.frame),  CGRectGetMaxY(self.areaNameLabel.frame) + 2 * paddingK + 1, screenWidth - labelWidth_KEY - 3 * paddingK - 30, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        _deviceNameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceNameLabelTapAction:)];
        [_deviceNameLabel addGestureRecognizer:tap];
        [self.descriptionView addSubview:_deviceNameLabel];
    }
    return _deviceNameLabel;
}

- (UIButton *)scanQRCodeBtn {
    if (!_scanQRCodeBtn) {
        _scanQRCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _scanQRCodeBtn.frame = CGRectMake(screenWidth - 35, CGRectGetMinY(self.deviceNameLabel.frame) - 5, 30, 30);
        _scanQRCodeBtn.backgroundColor = [UIColor clearColor];
        [_scanQRCodeBtn setImage:[[UIImage imageNamed:@"ic_QRcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_scanQRCodeBtn addTarget:self action:@selector(scanQRCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.descriptionView addSubview:_scanQRCodeBtn];
    }
    return _scanQRCodeBtn;
}

-(UILabel *)subclassLabel {
    if (!_subclassLabel) {
        _subclassLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.areaNameLabel.frame),  CGRectGetMaxY(self.deviceNameLabel.frame) + 2 * paddingK + 1, screenWidth - labelWidth_KEY - 3 * paddingK, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        
        _subclassLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subclassLabelTapAction:)];
        [_subclassLabel addGestureRecognizer:tap];
        
        [self.descriptionView addSubview:_subclassLabel];
    }
    return _subclassLabel;
}

-(UILabel *)priorityLabel {
    if (!_priorityLabel) {
        _priorityLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.areaNameLabel.frame),  CGRectGetMaxY(self.subclassLabel.frame) + 2 * paddingK + 1, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.descriptionView addSubview:_priorityLabel];
    }
    return _priorityLabel;
}

-(UILabel *)solveTimeLimitLabel {
    if (!_solveTimeLimitLabel) {
        _solveTimeLimitLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMinX(self.areaNameLabel.frame),  CGRectGetMaxY(self.priorityLabel.frame) + 2 * paddingK + 1, 80, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.descriptionView addSubview:_solveTimeLimitLabel];
    }
    return _solveTimeLimitLabel;
}

-(UITextView *)troubleDescriptionTextView {
    if (!_troubleDescriptionTextView) {
        _troubleDescriptionTextView = [[UITextView alloc] init];
        _troubleDescriptionTextView.delegate = self;
        _troubleDescriptionTextView.text = @"";
        _troubleDescriptionTextView.font = FONT(18);
        _troubleDescriptionTextView.zw_placeHolder = @"问题描述:";
        _troubleDescriptionTextView.zw_placeHolderColor = TextColor_GRAY;
        _troubleDescriptionTextView.textColor = TextColor_GRAY;
        _troubleDescriptionTextView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_troubleDescriptionTextView];
        
        [_troubleDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.top.equalTo(self.descriptionView.mas_bottom).offset(paddingK);
            make.width.equalTo(@(screenWidth - paddingK));
            make.height.equalTo(@(30));
        }];
    }
    return _troubleDescriptionTextView;
}

- (UILabel *)lineLabel {

    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.equalTo(self.troubleDescriptionTextView.mas_bottom).offset(paddingK);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(1));
        }];
      
    }
    return _lineLabel;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.scrollView addSubview:_cameraBtn];
        _cameraBtn.titleLabel.font = FONT(18);
        _cameraBtn.layer.masksToBounds = YES;
        _cameraBtn.layer.cornerRadius = 5;
        _cameraBtn.backgroundColor = Saffron_Yellow_COLOR;
        [_cameraBtn setImage:[[UIImage imageNamed:@"ic_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_cameraBtn setImage:[[UIImage imageNamed:@"ic_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        _cameraBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 30, 10, screenWidth - 100 - 30 - 20);
        [_cameraBtn setTitle:@"拍    照" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _cameraBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [_cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(50);
            make.top.equalTo(self.lineLabel.mas_bottom).offset(30);
            make.width.equalTo(@(screenWidth - 100));
            make.height.equalTo(@(40));
        }];
    }
    return _cameraBtn;
}

- (UIImagePickerController *)imagePikerController {
    if (!_imagePikerController) {
        _imagePikerController = [[UIImagePickerController alloc] init];
        _imagePikerController.delegate = self;
        _imagePikerController.allowsEditing = YES;//可编辑
    }
    return _imagePikerController;
}

- (NSMutableArray *)imageLinkArray {
    if (!_imageLinkArray) {
        _imageLinkArray = [[NSMutableArray alloc] init];
    }
    return _imageLinkArray;
}

- (NSMutableArray *)subclassArray {
    if (!_subclassArray) {
        _subclassArray = [[NSMutableArray alloc] init];
    }
    return _subclassArray;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 250)];
        _coverView.backgroundColor = RGBColor(0, 0, 0, 0.5);
        _coverView.hidden = YES;
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapAction:)];
        [_coverView addGestureRecognizer:tap];
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

- (UIView *)bgPickerView {
    if (!_bgPickerView) {
        _bgPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 250)];
        _bgPickerView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_bgPickerView];
        
        [self cancelView];
        [self pickerView];
    }
    return _bgPickerView;
}

- (UIView *)cancelView {
    if (!_cancelView) {
        _cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        _cancelView.backgroundColor = [UIColor grayColor];
        _cancelView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelViewTapAction:)];
        [_cancelView addGestureRecognizer:tap];
        [self.bgPickerView addSubview:_cancelView];
        [self okBtn];
    }
    return _cancelView;
}

-(UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _okBtn.frame = CGRectMake(screenWidth - paddingK - 60, 0, 60, 30);
        _okBtn.titleLabel.font = FONT(18);
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.cornerRadius = 5;
        _okBtn.backgroundColor = [UIColor clearColor];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:SYSTEM_COLOR forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelView addSubview:_okBtn];
    }
    return _okBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor blackColor];
        [self.bgPickerView addSubview:_pickerView];
    }
    return _pickerView;
}

- (UITableView *)photoTableView {
    if (!_photoTableView) {
        _photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cameraBtn.frame) + 30, screenWidth, 50) style:UITableViewStylePlain];
        _photoTableView.backgroundColor = [UIColor clearColor];
        _photoTableView.hidden = YES;
        _photoTableView.showsVerticalScrollIndicator = NO;
        _photoTableView.showsHorizontalScrollIndicator = NO;
        _photoTableView.sectionFooterHeight = 0;
        _photoTableView.sectionHeaderHeight = 0;
        _photoTableView.rowHeight = 50;
        _photoTableView.delegate = self;
        _photoTableView.dataSource = self;
        [_photoTableView setSeparatorColor:[UIColor clearColor]];
        [_photoTableView registerClass:[TLPhotoTableViewCell class] forCellReuseIdentifier:TLPhotoTableViewCellIdentifier];
        [self.scrollView addSubview:_photoTableView];
        
        [_photoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.equalTo(self.cameraBtn.mas_bottom).offset(30);
            make.width.equalTo(@(screenWidth));
            make.height.equalTo(@(50));
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
