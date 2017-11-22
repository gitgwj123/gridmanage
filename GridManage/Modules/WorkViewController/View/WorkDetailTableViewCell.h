//
//  WorkDetailTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoModel.h"

extern NSString *WorkDetailTableViewCellIdentifier;

@interface WorkDetailTableViewCell : UITableViewCell

- (void)setupWorkDetailCellWithPhotoModel:(TLPhotoModel *)photoModel;

@end
