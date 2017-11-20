//
//  PatrolModel.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "PatrolModel.h"

@implementation PatrolModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"patrolId" : @"id"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"pointname:%@\n patrolId:%@\n planendtime:%@\n planstarttime:%@\n itemscount:%@\n finishcount：%@\n problemscount:%@\n bluetoothid:%@", self.pointname, self.patrolId, self.planendtime, self.planstarttime, self.itemscount, self.finishcount, self.problemscount, self.bluetoothid];
}


@end
