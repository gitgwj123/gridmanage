//
//  PatrolItemModel.m
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "PatrolItemModel.h"

@implementation PatrolItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"patrolDetailId" : @"id"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"itemdescribe:%@\n devicestate:%@\n patroltime:%@\n committeamid:%@\n patrolDetailId:%@\n", self.itemdescribe, self.devicestate, self.patroltime, self.committeamid, self.patrolDetailId];
}


@end
