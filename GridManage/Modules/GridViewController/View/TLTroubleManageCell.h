//
//  TLTroubleManageCell.h
//  GridManage
//
//  Created by gwj on 2017/11/20.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TroubleManageModel.h"

extern NSString *TLTroubleManageCellIdentifier;

@interface TLTroubleManageCell : UITableViewCell

@property (nonatomic, copy) void(^troubleManageCellBtnBlock)(TroubleManageModel *troubleManageModel, NSString *changedTaskStatus);

@property (nonatomic, strong) TroubleManageModel *model;

@end
