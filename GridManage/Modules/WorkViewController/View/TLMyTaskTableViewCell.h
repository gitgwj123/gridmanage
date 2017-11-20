//
//  TLMyTaskTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTaskModel.h"

extern NSString *TLMyTaskTableViewCellIdentifier;

@interface TLMyTaskTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^OperateLabelTapActionBlock)(MyTaskModel * myTaskModel, NSString *changedTaskStutas);

- (void)setupMyTaskCellWithMyTaskModel:(MyTaskModel *)model;

@end
