//
//  PatrolModel.h
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatrolModel : NSObject

@property NSString *pointname;//候车室name
@property NSString *patrolId;//巡视id
@property NSString *planendtime;//结束时间
@property NSString *planstarttime;//开始时间
@property NSString *itemscount;//任务count
@property NSString *problemscount;//问题任务count
@property NSString *finishcount;//已巡视任务count
@property NSString *bluetoothid;//任务对应的bluetoothid



@end
