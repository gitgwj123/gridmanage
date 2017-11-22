//
//  TLPhotoViewController.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TLPhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    NSString *_imageFilePath;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePikerController;

@end

@implementation TLPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightBarButtonItemWithTitle:@"相册" titleColor:SYSTEM_COLOR];
    self.title = [[_imageFilePath componentsSeparatedByString:@"/"] lastObject];
    [self imageView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:_imageFilePath];
    self.imageView.image = image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(instancetype)initWithImageFilePath:(NSString *)path{

    self = [super init];
    if (self) {
        _imageFilePath = path;
    }
    return self;
}

#pragma mark - action
-(void)rightNavigationBarItemAction:(UIButton *)sender {

    //浏览图片
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied) {
            [TLAlert setAlertControllerWithController:self Title:@"提示" message:@"请前往设置->隐私->相册授权应用访问相册权限" okActionTitle:@"确定" okActionHandler:^(UIAlertAction *action) {
            }];
            return;
        }
    }
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 推送图片拾取器控制器
        [self presentViewController:self.imagePikerController animated:YES completion:^{
            MyLog(@"打开相册");
        }];
    } else {
        [TLAlert showMessage:@"没有相册" hideDelay:2 inView:self.view];
    }

}

#pragma mark - private methods


#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy loading
- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarAndNavBarHeight, screenWidth, screenHeight - statusBarAndNavBarHeight)];
        
        [self.view addSubview:_imageView];
    }
    
    return _imageView;
}


- (UIImagePickerController *)imagePikerController {
    if (!_imagePikerController) {
        _imagePikerController = [[UIImagePickerController alloc] init];
        _imagePikerController.delegate = self;
        _imagePikerController.allowsEditing = YES;//可编辑
        _imagePikerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    return _imagePikerController;
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
