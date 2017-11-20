//
//  TLPatrolTimeManager.h
//  GridManage
//
//  Created by gwj on 2017/11/9.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLPatrolTimeManager : NSObject

+ (instancetype)sharedManager;

/**
 <#Description#>

 @param patrolTime 包含一组字典 @"patrolId":@""  @"startTime":@""  @"finishTime":@""
 */
- (void)savePatrolTimeWithpatrolTimeDictionary:(NSDictionary *)patrolTime;

- (NSDictionary *)getPatrolTimeWithPatrolId:(NSString *)patrolId;

@end
