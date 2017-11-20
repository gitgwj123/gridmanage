//
//  TLTroubleManageTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TroubleManageModel.h"

extern NSString *TLTroubleManageTableViewCellIdentifier;

@interface TLTroubleManageTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^troubleManageCellBtnBlock)(TroubleManageModel *troubleManageModel, NSString *changedTaskStatus);

- (void)setupTroubleManageCellWithTroubleManageModel:(TroubleManageModel *)troubleManageModel;

@end
