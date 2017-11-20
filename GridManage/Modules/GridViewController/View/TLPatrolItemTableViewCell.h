//
//  TLPatrolItemTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolItemModel.h"

extern NSString *TLPatrolItemTableViewCellIdentifier;

@interface TLPatrolItemTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^deviceStateImageViewBlock)(NSString *patrolDetailId, BOOL isNormal);

- (void)setupPatrolCellWithPatrolItemModel:(PatrolItemModel *)patrolItemModel;

@end
