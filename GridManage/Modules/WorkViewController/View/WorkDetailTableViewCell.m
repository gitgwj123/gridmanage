//
//  WorkDetailTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "WorkDetailTableViewCell.h"
#import "XLPaymentLoadingHUD.h"
#import "XLPaymentSuccessHUD.h"
#import "TLFailureHUD.h"
#import "TLPhotoModel.h"

NSString *WorkDetailTableViewCellIdentifier = @"WorkDetailTableViewCellIdentifier";

@interface WorkDetailTableViewCell ()

{
    TLloadImageType _loadStatusType;
    NSString *_imageFilePath;
}

@property (nonatomic, strong) UILabel *imageNameLabel;
@property (nonatomic, strong) UIView *loadStatusView;
@property (nonatomic, strong) UIImageView *failImageView;

@end

@implementation WorkDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBColor(59, 59, 59, 1);
        [self initUI];
    }
    return self;
}


#pragma mark - UI
- (void)initUI {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 20)];
    imageView.image = [UIImage imageNamed:@"ic_photo"];
    [self.contentView addSubview: imageView];
    
    [self imageNameLabel];
    [self loadStatusView];
}

#pragma mark - private methods

- (void)setupWorkDetailCellWithImageFilePath:(NSString *)imageFilePath loadStatusType:(TLloadImageType)type {
    
    self.imageNameLabel.text = [[imageFilePath componentsSeparatedByString:@"/"] lastObject];
    _loadStatusType = type;
    _imageFilePath = imageFilePath;
    [self setupLoadStatusView];

}

- (void)setupLoadStatusView {
    
    if (_loadStatusType == loadingType) {
        [XLPaymentLoadingHUD showIn:self.loadStatusView];
        self.loadStatusView.userInteractionEnabled = NO;
        [self downloadImageAndLocalSaveWithImageFilePath:_imageFilePath];
    } else if (_loadStatusType == loadSuccessType) {
        [XLPaymentLoadingHUD hideIn:self.loadStatusView];
        [XLPaymentSuccessHUD showIn:self.loadStatusView];
        self.loadStatusView.userInteractionEnabled = NO;
    } else if (_loadStatusType == loadFailureType) {
        [XLPaymentLoadingHUD hideIn:self.loadStatusView];
        self.failImageView.hidden = NO;
        self.loadStatusView.userInteractionEnabled = YES;
    }
}

- (void)downloadImageAndLocalSaveWithImageFilePath:(NSString *)imageFilePath {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageFilePath]];
    TLPhotoModel *model = [[TLPhotoModel alloc] init];
    model.filePath = imageFilePath;
    if (data != nil) {
        UIImage *image = [UIImage imageWithData:data]; // 取得图片
        // 本地沙盒目录
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
        NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
        if (success){
            MyLog(@"写入本地成功");
        } else {
            MyLog(@"写入本地失败");
        }
        model.type = loadSuccessType;
        
    } else {
        MyLog(@"图片数据为空");
        model.type = loadFailureType;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkDetailCellDownloadNotification" object:model];
    
}

#pragma mark - action
- (void)loadStatusViewTapAction:(UITapGestureRecognizer *)tap {

    if (_loadStatusType == loadFailureType) {
        [TLFailureHUD hideIn:self.loadStatusView];
        [XLPaymentLoadingHUD showIn:self.loadStatusView];
        self.loadStatusView.userInteractionEnabled = NO;
    }
}


#pragma  mark - lazy loading
- (UILabel *)imageNameLabel {
    
    if (!_imageNameLabel) {
        _imageNameLabel = [UILabel addLabelWithText:@"" textColor:[UIColor whiteColor] frame:CGRectMake(70, 15, screenWidth - 70 - 40, 20) font:FONT(18) alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_imageNameLabel];
    }
    return _imageNameLabel;
}

- (UIView *)loadStatusView {
    
    if (!_loadStatusView) {
        _loadStatusView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - 40, 10, 30, 30)];
        _loadStatusView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadStatusViewTapAction:)];
        [_loadStatusView addGestureRecognizer:tap];
        [self.contentView addSubview:_loadStatusView];
        [self failImageView];
    }
    return _loadStatusView;
}

- (UIImageView *)failImageView {
    
    if (!_failImageView) {
        _failImageView = [UIImageView addImageViewWithImageName:@"ic_warning" frame:CGRectMake(5, 5, 20, 20)];
        _failImageView.hidden = YES;
        [self.loadStatusView addSubview:_failImageView];
    }
    return _failImageView;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
