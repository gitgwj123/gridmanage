//
//  TLAddTroubleViewController.h
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController.h"

@interface TLAddTroubleViewController : BaseViewController

@property (nonatomic, copy) NSString *patrolId;
@property (nonatomic, assign) NSInteger finishCount;
@property (nonatomic, assign) NSInteger itemsCount;
@property (nonatomic, assign) NSInteger completePatrolItemsNum;

-(instancetype)initWithPatrolDetailId:(NSString *)patrolDetailId deviceState:(NSString *)deviceState;

@end
