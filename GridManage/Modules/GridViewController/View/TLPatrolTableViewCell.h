//
//  TLPatrolTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolModel.h"

extern NSString *TLPatrolTableViewCellIdentifier;

@interface TLPatrolTableViewCell : UITableViewCell


/**
 设置cell 

 @param patrolModel <#patrolModel description#>
 */
- (void)setupPatrolCellWithPatrolModel:(PatrolModel *)patrolModel;


@end
