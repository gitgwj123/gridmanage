//
//  TLPhotoTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *TLPhotoTableViewCellIdentifier;

@interface TLPhotoTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^loadStatusViewTapBlock)(NSString *imageFilePath);

- (void)setupPhotoTableViewCellWithImageFilePath:(NSString *)imageFilePath loadStatusType:(TLloadImageType)type;

@end
