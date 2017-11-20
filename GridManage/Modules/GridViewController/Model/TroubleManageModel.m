//
//  TroubleManageModel.m
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TroubleManageModel.h"


@implementation TroubleManageModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"taskname:%@\n tasksid:%@\n taktype:%@\n notes:%@\n picture:%@\n taskstatus:%@\n deviceid:%@\n donejob:%@\n", self.taskname, self.tasksid, self.taktype, self.notes, self.picture, self.taskstatus, self.deviceid, self.donejob];
}

@end
