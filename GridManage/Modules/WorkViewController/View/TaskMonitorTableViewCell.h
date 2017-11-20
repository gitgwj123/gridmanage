//
//  TaskMonitorTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskMonitorModel.h"

extern NSString *TLTaskMonitorTableViewCellIdentifier;

@interface TaskMonitorTableViewCell : UITableViewCell

- (void)setupPatrolCellWithTaskMonitorModel:(TaskMonitorModel *)model;

@end
