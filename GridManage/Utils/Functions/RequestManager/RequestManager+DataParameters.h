//
//  RequestManager+DataParameters.h
//  GridManage
//
//  Created by gwj on 2017/11/22.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "RequestManager.h"

@interface RequestManager (DataParameters)

- (NSString *)getPublishTaskCommandDataParameterWithJobsId:(NSString *)jobsId  note:(NSString *)note opType:(NSString *)opType joboperatorsid:(NSString *)joboperatorsid tasksid:(NSString *)tasksid usersId:(NSString *)usersId;

- (NSString *)getMyWorkTasksDataParameterWithTeamsid:(NSString *)teamsid;

- (NSString *)getWorkMonitorDataParameterWithTeamsid:(NSString *)teamsid;

- (NSString *)getMonitorfilesDataParameterWithJobsid:(NSString *)jobsid;

- (NSString *)getOperatorfilesDataParameterWithJoboperatorsid:(NSString *)joboperatorsid;

- (NSString *)getWorkTaskDetailDataParameterWithTaskId:(NSString *)taskId;

- (NSString *)getTroubleManageDataParameterWithTeamId:(NSString *)teamId;

- (NSString *)getPatrolPlanDataParameterWithTeamId:(NSString *)teamId;

- (NSString *)getJobsidDataParameterWithTaskId:(NSString *)taskId;

- (NSString *)getItemsListDataParameterWithPatrolId:(NSString *)patrolId;

- (NSString *)getDeviceNameParameterWithDeviceId:(NSString *)deviceId;

- (NSString *)getDeviceTroubleSubclassParameterWithClassificationId:(NSString *)classificationId;

@end
