//
//  TaskMonitorModel.m
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TaskMonitorModel.h"

@implementation TaskMonitorModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"taskname:%@\n taskstatus:%@\n tasksid:%@\n planstarttime:%@\n planendtime:%@\n job：%@\n realstarttime:%@\n realendtime%@: ", self.taskname, self.taskstatus, self.tasksid, self.planstarttime, self.planendtime, self.job, self.realstarttime, self.realendtime];
}

@end
