//
//  TroubleSubclassModel.m
//  GridManage
//
//  Created by gwj on 2017/11/9.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TroubleSubclassModel.h"

@implementation TroubleSubclassModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"problemTypeId" : @"id", @"troubleTypename" : @"typename"};
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"troubleTypename:%@\n problemTypeId:%@\n priority:%@\n plancosttime:%@\n", self.troubleTypename, self.problemTypeId, self.priority, self.plancosttime];
}


@end
