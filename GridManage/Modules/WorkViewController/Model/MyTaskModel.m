//
//  MyTaskModel.m
//  GridManage
//
//  Created by gwj on 2017/11/15.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "MyTaskModel.h"

@implementation MyTaskModel

- (NSString *)description {
    
    return [NSString stringWithFormat:@"taskname:%@\n taskstatus:%@\n jobsid:%@\n joboperatorsid:%@\n tasksid:%@\n note:%@\n planstarttime:%@\n planendtime:%@\n realstarttime:%@\n realendtime%@: ", self.taskname, self.taskstatus, self.jobsid, self.joboperatorsid, self.tasksid, self.note, self.planstarttime, self.planendtime, self.realstarttime, self.realendtime];
}


@end
