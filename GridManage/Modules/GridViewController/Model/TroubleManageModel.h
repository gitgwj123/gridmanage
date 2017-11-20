//
//  TroubleManageModel.h
//  GridManage
//
//  Created by gwj on 2017/11/8.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TroubleManageModel : NSObject

@property NSString *monitorteamname;//ex:客运主任丁
@property NSString *monitorteamid;

@property NSString *operatorteamname;//ex:运营1组
@property NSString *operatorteamid;

@property NSString *planstarttime;// ex:2017-11-08 10:37:06.0
@property NSString *planendtime;//ex:2017-11-09 10:37:00.0

@property NSString *realstarttime;//
@property NSString *realendtime;//


@property NSString *taskname;//ex:显示屏20060101 花屏（设备名称 子类）
@property NSString *tasksid;
@property NSString *areaname;//ex:第3候车室
@property NSString *areaid;
@property NSString *taktype;//等级
@property NSString *notes;//ex:问题描述
@property NSString *picture;//上传照片张数
@property NSString *taskstatus;//任务状态 ：0、2、4（未开始、待验收、验收未通过）(operate:3-->未通过/5--通过)
@property NSString *deviceid;//
@property NSString *donejob;//0、1


@end
