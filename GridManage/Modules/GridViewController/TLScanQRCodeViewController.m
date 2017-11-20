//
//  TLScanQRCodeViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/10.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>


#define Xcenter self.view.center.x
#define YCenter self.view.center.y

#define ScanFrameWidth (Xcenter + 60)

@interface TLScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    
    NSTimer *_scanTimer;
    int      _scanCount;
    BOOL     _isMoveUp;//扫描线移动方向（上、下）
    BOOL     _isLightOpen;//闪光灯是否开启
}

/**
 输入输出的中间桥梁
 */
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureDevice            *device;
@property (nonatomic, strong) AVCaptureDeviceInput       *input;
@property (nonatomic, strong) AVCaptureMetadataOutput    *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) NSString    *scanResult;

@property (nonatomic, strong) UIImageView *scanFrame;
@property (nonatomic, strong) UIImageView *scanLine;
@property (nonatomic, strong) UILabel     *descriptionLabel;


@end

@implementation TLScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //判断是否存在相机
    if (self.device == nil) {
        [self showAlertViewWithTitle:@"" message:@"未检测到相机"];
        return;
    }
    
    self.title = @"二维码/条码";
    
    //打开定时器 开始扫描
    [self addTimer];
    
    //界面初始化
    [self interfaceSetup];
    
    //初始化扫描
    [self scanSetup];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
    [_scanTimer setFireDate:[NSDate distantFuture]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - base setup

//初始化扫描配置
- (void)scanSetup {
    //2 添加预览图层
    self.preview.frame = self.view.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //3 设置输出能够解析的数据类型
    //注意:设置数据类型一定要在输出对象添加到回话之后才能设置
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
    
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //4 开始扫描
    [self.session startRunning];
}

//界面初始化
- (void)interfaceSetup {
    
//    [self addRightBarBtnItem];
    
    //1 添加扫描框
    [self scanFrame];
    [self scanLine];
    
    //添加模糊效果
    [self setOverView];
    
    [self descriptionLabel];
    
    //添加开始扫描按钮
    //    [self addScanButton];
    
    //添加闪光灯
    [self addLightButton];
}

//- (void)addRightBarBtnItem {
//    
//    UIBarButtonItem *photoLibraryItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhotoLibrary:)];
//    self.navigationItem.rightBarButtonItem = photoLibraryItem;
//}

//添加模糊效果
- (void)setOverView {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(self.scanFrame.frame);
    CGFloat y = CGRectGetMinY(self.scanFrame.frame);
    CGFloat w = CGRectGetWidth(self.scanFrame.frame);
    CGFloat h = CGRectGetHeight(self.scanFrame.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

//添加扫描按钮
//- (void)addScanButton {
//
//    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    scanButton.frame = CGRectMake(60, CGRectGetMaxY(self.descriptionLabel.frame) + 30, 80, 40);
//    scanButton.backgroundColor = [UIColor orangeColor];
//    [scanButton addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
//    [self.view addSubview:scanButton];
//}

//添加闪光灯控制开关
- (void)addLightButton {
    
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lightButton.frame = CGRectMake((screenWidth - 40)/2, CGRectGetMaxY(self.descriptionLabel.frame) + 30, 40, 40);
    lightButton.backgroundColor = [UIColor orangeColor];
    [lightButton addTarget:self action:@selector(lightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [lightButton setTitle:@"灯光" forState:UIControlStateNormal];
    [self.view addSubview:lightButton];
}

- (void)addTimer {
    
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(scanTiemrAction:) userInfo:nil repeats:YES];
}


#pragma mark - private methods

- (void)creatView:(CGRect)rect {
    
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    
    [self stopScan];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"扫描结果：%@", message] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self startScan];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)stopScan {
    //关闭扫描
    [self.session stopRunning];
    //关闭定时器
    [_scanTimer setFireDate:[NSDate distantFuture]];
    //隐藏扫描线
    _scanLine.hidden = YES;
}

- (void)startScan {
    //开始扫描
    [self.session startRunning];
    //打开定时器
    [_scanTimer setFireDate:[NSDate distantPast]];
    //显示扫描线
    _scanLine.hidden = NO;
}

#pragma mark - delegate
//UIImagePikerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //1 获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //初始化一个监听器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            //结果对象
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scanResult = feature.messageString;
            [self showAlertViewWithTitle:@"读取相册二维码" message:scanResult];
        }
        else
        {
            [self showAlertViewWithTitle:@"读取相册二维码" message:@"读取失败"];
        }
    }];
}

//扫描代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *stringValue = [metadataObject stringValue];
            if (stringValue != nil) {
                [self.session stopRunning];
                //扫描结果
                self.scanResult = stringValue;
                MyLog(@"%@",stringValue);
               // [self showAlertViewWithTitle:@"" message:stringValue];
                if (self.scanQRcodeBlock) {
                    self.scanQRcodeBlock(stringValue);
                }
            }
        }
    }
}


#pragma mark - timer action/ button click action

- (void)openPhotoLibrary:(UIBarButtonItem *)item {
    
    BOOL isOpenPhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (isOpenPhotoLibrary) {
        [self stopScan];
        
        //弹出系统相册
        UIImagePickerController *pikerVc = [[UIImagePickerController alloc]init];
        //设置照片来源
        pikerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pikerVc.delegate = self;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:pikerVc animated:YES completion:nil];
        
    } else {
        
        [self showAlertViewWithTitle:@"打开失败" message:@"相册打开失败。设备不支持访问相册，请在设置->隐私->照片中进行设置！"];
    }
    
    
}

- (void)scanButtonClick:(UIButton *)btn {
    //清除imageView上的图片
    self.scanFrame.image = [UIImage imageNamed:@""];
    //开始扫描
    [self startScan];
}

- (void)lightButtonClick {
    _isLightOpen = !_isLightOpen;
    //开启闪光灯
    [self systemLightSwitch:_isLightOpen];
}

- (void)scanTiemrAction:(NSTimer *)timer {
    
    if (_isMoveUp) {
        _scanCount --;
        self.scanLine.frame = CGRectMake(CGRectGetMinX(self.scanFrame.frame) + 5, CGRectGetMinY(self.scanFrame.frame) + 5 + _scanCount, CGRectGetWidth(self.scanFrame.frame) - 10, 3);
        
        if (_scanCount == 0) {
            _isMoveUp = NO;
        }
    } else {
        _scanCount ++;
        self.scanLine.frame = CGRectMake(CGRectGetMinX(self.scanFrame.frame) + 5, CGRectGetMinY(self.scanFrame.frame) + 5 + _scanCount, CGRectGetWidth(self.scanFrame.frame) - 10, 3);
        
        if (_scanCount == (int)(CGRectGetHeight(self.scanFrame.frame)- 10)) {
            _isMoveUp = YES;
        }
    }
}

#pragma mark - lazy loading

- (AVCaptureDevice *)device {
    
    if (!_device) {
        //打开相机
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

//output
- (AVCaptureMetadataOutput *)output {
    
    //如果不打开就无法输出扫描得到的信息
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        //设置输出对象解析数据时感兴趣的范围
        //默认值是CGRect(x: 0, y: 0, width: 1, height: 1)
        //参照的是以--横屏--的左上角作为原点
        //out.rectOfInterset = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //限制扫描区域（上下左右）
        [_output setRectOfInterest:[self rectOfIntersetByScanViewRect:_scanFrame.frame]];
    }
    return _output;
}

- (CGRect)rectOfIntersetByScanViewRect:(CGRect)rect {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

- (AVCaptureSession *)session {
    
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)preview {
    
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}

- (UIImageView *)scanFrame {
    
    if (!_scanFrame) {
        _scanFrame = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - ScanFrameWidth)/2, (screenHeight - ScanFrameWidth)/2, ScanFrameWidth, ScanFrameWidth)];
        //显示扫描框
        _scanFrame.image = [UIImage imageNamed:@"scanscanBg.png"];
        [self.view addSubview:_scanFrame];
    }
    
    return _scanFrame;
}

-(UIImageView *)scanLine {
    
    if (!_scanLine) {
        _scanLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.scanFrame.frame)+5, CGRectGetMinY(self.scanFrame.frame) + 5, CGRectGetWidth(self.scanFrame.frame), 3)];
        _scanLine.image = [UIImage imageNamed:@"scanLine@2x.png"];
        [self.view addSubview:_scanLine];
    }
    return _scanLine;
}

-(UILabel *)descriptionLabel {
    
    if (!_descriptionLabel) {
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.frame = CGRectMake(paddingK, CGRectGetMaxY(self.scanFrame.frame) + 20, screenWidth - 20, 40);
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"将二维码、条码放入框内，即可自动扫描";
        [self.view addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
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
