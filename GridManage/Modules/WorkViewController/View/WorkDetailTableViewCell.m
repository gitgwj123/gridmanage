//
//  WorkDetailTableViewCell.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "WorkDetailTableViewCell.h"
#import "XLPaymentLoadingHUD.h"
#import "TLPhotoModel.h"

NSString *WorkDetailTableViewCellIdentifier = @"WorkDetailTableViewCellIdentifier";

@interface WorkDetailTableViewCell ()

{
    TLPhotoModel *_photoModel;
}

@property (nonatomic, strong) UILabel *imageNameLabel;
@property (nonatomic, strong) UIView *loadStatusView;
@property (nonatomic, strong) UIImageView *loadImageView;

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

- (void)setupWorkDetailCellWithPhotoModel:(TLPhotoModel *)photoModel {
    _photoModel = photoModel;
    
    self.imageNameLabel.text = [[photoModel.filePath componentsSeparatedByString:@"/"] lastObject];

    [self setupLoadStatusView];
}

- (void)setupLoadStatusView {
    
    TLloadImageType type = _photoModel.type;
    if (type == loadingType) {
        [XLPaymentLoadingHUD showIn:self.loadStatusView];
        self.loadImageView.hidden = YES;
        self.loadStatusView.userInteractionEnabled = NO;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_photoModel.filePath] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            TLPhotoModel *model = _photoModel;
            if (image) {
                model.type = loadSuccessType;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkDetailCellDownloadNotification" object:model];
            } else {
                model.type = loadFailureType;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkDetailCellDownloadNotification" object:model];
            }
        }];
    } else if (type == loadSuccessType) {
        [XLPaymentLoadingHUD hideIn:self.loadStatusView];
        self.loadImageView.hidden = NO;
        self.loadImageView.image = [UIImage imageNamed:@"ic_upload_success"];
        self.loadStatusView.userInteractionEnabled = NO;
    } else if (type == loadFailureType) {
        [XLPaymentLoadingHUD hideIn:self.loadStatusView];
        self.loadImageView.hidden = NO;
        self.loadImageView.image = [UIImage imageNamed:@"ic_warning"];
        self.loadStatusView.userInteractionEnabled = YES;
    }
}

#pragma mark - action
- (void)loadStatusViewTapAction:(UITapGestureRecognizer *)tap {

    if (_photoModel.type == loadFailureType) {
        [XLPaymentLoadingHUD showIn:self.loadStatusView];
        self.loadImageView.hidden = YES;
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
        [self loadImageView];
    }
    return _loadStatusView;
}

- (UIImageView *)loadImageView {
    
    if (!_loadImageView) {
        _loadImageView = [UIImageView addImageViewWithImageName:@"ic_warning" frame:CGRectMake(5, 5, 20, 20)];
        _loadImageView.hidden = YES;
        [self.loadStatusView addSubview:_loadImageView];
    }
    return _loadImageView;
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
