//
//  MyTaskModel.h
//  GridManage
//
//  Created by gwj on 2017/11/15.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTaskModel : NSObject

@property NSString *taskname;//ex:显示屏20060101 花屏 (只显示 花屏)
@property NSString *taskstatus;// 0、1、2、3、4 ：未开始 进行中 已结束 验收通过 验收未通过
@property NSString *jobsid;//
@property NSString *tasksid;//
@property NSString *joboperatorsid;//
@property NSString *note;
@property NSString *planstarttime;//计划开始时间
@property NSString *planendtime;//计划结束时间
@property NSString *realstarttime;//实际执行时间
@property NSString *realendtime;//实际执行时间

@end
