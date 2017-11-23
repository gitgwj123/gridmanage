//
//  RequestManager+DataParameters.m
//  GridManage
//
//  Created by gwj on 2017/11/22.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "RequestManager+DataParameters.h"

@implementation RequestManager (DataParameters)
//baseParameter
- (NSDictionary *)getBaseParameter {
    NSDictionary *dic = @{@"PageSize":@"999999", @"PageStart":@"1"};
    return dic;
}

//getPublishTaskCommandDataParameter
- (NSString *)getPublishTaskCommandDataParameterWithJobsId:(NSString *)jobsId  note:(NSString *)note opType:(NSString *)opType joboperatorsid:(NSString *)joboperatorsid tasksid:(NSString *)tasksid usersId:(NSString *)usersId {
    NSDictionary *dataDic = @{@"jobsId":jobsId, @"note":note, @"opType":opType, @"opormotId":joboperatorsid, @"ssId":@"", @"taskId":tasksid, @"usersId":usersId};
    NSString *dataStr = [[NSString convertToJSONData:dataDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return dataStr;
}

//getMyWorkTasksDataParameter
- (NSString *)getMyWorkTasksDataParameterWithTeamsid:(NSString *)teamsid {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"joboperatorsviewinfo" forKey:@"ViewName"];
    
    NSArray *orderByArr = @[@{@"Field":@"planstarttime", @"Mode":@"1"}];
    NSString *orderByArrStr = [NSString convertToJSONData:orderByArr];
    NSString *orderBy = [orderByArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:orderBy forKey:@"OrderBy"];
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"teamsid", @"JoinKey":@"0", @"ValueKey":teamsid}];//传入的参数teamId
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"taktype", @"JoinKey":@"2", @"ValueKey":@"3"}];
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    return [NSString convertToJSONData:dataDic];
}

//getWorkMonitorDataParameter
- (NSString *)getWorkMonitorDataParameterWithTeamsid:(NSString *)teamsid {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"taskinfo" forKey:@"ViewName"];
    
    NSArray *orderByArr = @[@{@"Field":@"planstarttime", @"Mode":@"1"}];
    NSString *orderByArrStr = [NSString convertToJSONData:orderByArr];
    NSString *orderBy = [orderByArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:orderBy forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"monitorteamid", @"JoinKey":@"0", @"ValueKey":teamsid}];//传入的参数teamId
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"taktype", @"JoinKey":@"2", @"ValueKey":@"3"}];
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    return [NSString convertToJSONData:dataDic];
}

//getMonitorfilesDataParameter
- (NSString *)getMonitorfilesDataParameterWithJobsid:(NSString *)jobsid {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"jobmonitorfilesviewinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"jobsid", @"JoinKey":@"2", @"ValueKey":jobsid}];//传入的参数
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    return [NSString convertToJSONData:dataDic];
}

//getOperatorfilesDataParameter
- (NSString *)getOperatorfilesDataParameterWithJoboperatorsid:(NSString *)joboperatorsid {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"joboperatorfilesinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"joboperatorsid", @"JoinKey":@"2", @"ValueKey":joboperatorsid}];//传入的参数
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    return [NSString convertToJSONData:dataDic];
}

//)getWorkTaskDetailDataParameter
- (NSString *)getWorkTaskDetailDataParameterWithTaskId:(NSString *)taskId {
    
   NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"joboperatorsviewinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"tasksid", @"JoinKey":@"2", @"ValueKey":taskId}];//传入的参数taskId
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//getTroubleManageDataParameter
- (NSString *)getTroubleManageDataParameterWithTeamId:(NSString *)teamId {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"taskinfo" forKey:@"ViewName"];
    
    NSArray *orderByArr = @[@{@"Field":@"planstarttime", @"Mode":@"1"}];
    NSString *orderByArrStr = [NSString convertToJSONData:orderByArr];
    NSString *orderBy = [orderByArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:orderBy forKey:@"OrderBy"];
    
    NSMutableArray *whereClauseArr = [[NSMutableArray alloc] init];
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"monitorteamid", @"JoinKey":@"0", @"ValueKey":teamId}];//传入的参数teamId
    [whereClauseArr addObject:@{@"FieldKey":@"0", @"Fields":@"taktype", @"JoinKey":@"2", @"ValueKey":@"3"}];
    
    NSString *whereClauseArrStr = [NSString convertToJSONData:whereClauseArr];
    NSString *whereClause = [whereClauseArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:whereClause forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//getPatrolPlanDataParameter
- (NSString *)getPatrolPlanDataParameterWithTeamId:(NSString *)teamId {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"patrolsviewinfo" forKey:@"ViewName"];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@{@"FieldKey":@"0", @"Fields":@"teamid", @"JoinKey":@"0", @"ValueKey":teamId}];//传入的参数teamId
    [dataArray addObject:@{@"FieldKey":@"0", @"Fields":@"createdate", @"JoinKey":@"2", @"ValueKey":[IIDate getStringFromDate:[NSDate date] ofFormat:IIDateFormat1 timeZone:[NSTimeZone localTimeZone]]}];//传入的参数：年-月-日
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//getJobsidDataParameter
- (NSString *)getJobsidDataParameterWithTaskId:(NSString *)taskId {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"joboperatorsviewinfo" forKey:@"ViewName"];
    
    NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"tasksid", @"JoinKey":@"2", @"ValueKey":taskId}];//传入的参数tasksid
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [[NSString convertToJSONData:dataDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

//getItemsListDataParameter 
- (NSString *)getItemsListDataParameterWithPatrolId:(NSString *)patrolId {
   
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"patrolDetailsViewinfo" forKey:@"ViewName"];//传入的参数patrolDetailsViewinfo
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@{@"FieldKey":@"0", @"Fields":@"patrolsid", @"JoinKey":@"2", @"ValueKey":patrolId}];//传入的参数patrolId
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//拼接设备ID data参数
- (NSString *)getDeviceNameParameterWithDeviceId:(NSString *)deviceId {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"deviceinfo" forKey:@"ViewName"];
    
    NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"id", @"JoinKey":@"2", @"ValueKey":deviceId}];//传入的参数deviceId
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

//拼接设备子类 data参数
- (NSString *)getDeviceTroubleSubclassParameterWithClassificationId:(NSString *)classificationId {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[self getBaseParameter]];
    [dataDic setObject:@"" forKey:@"OrderBy"];
    [dataDic setObject:@"problemtypeinfo" forKey:@"ViewName"];
    
    NSArray *dataArray = @[@{@"FieldKey":@"0", @"Fields":@"classificationId", @"JoinKey":@"2", @"ValueKey":classificationId}];//传入的参数classificationId
    
    NSString *dataArrStr = [NSString convertToJSONData:dataArray];
    NSString *dataArrSSS = [dataArrStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dataDic setObject:dataArrSSS forKey:@"WhereClause"];
    
    return [NSString convertToJSONData:dataDic];
}

@end
