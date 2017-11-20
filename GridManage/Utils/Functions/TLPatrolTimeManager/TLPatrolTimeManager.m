//
//  TLPatrolTimeManager.m
//  GridManage
//
//  Created by gwj on 2017/11/9.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPatrolTimeManager.h"

static TLPatrolTimeManager *patrolTimeManager = nil;

@implementation TLPatrolTimeManager

+ (instancetype)sharedManager {
    
    if (patrolTimeManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            patrolTimeManager = [[TLPatrolTimeManager alloc] init];
        });
    }
    return  patrolTimeManager;
}

- (void)savePatrolTimeWithpatrolTimeDictionary:(NSDictionary *)patrolTime {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *completePath = [documentPath stringByAppendingPathComponent:@"patrolTime.plist"];
    
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:completePath];
    NSMutableArray *finialResultArr = [[NSMutableArray alloc] init];;
    if (resultArr.count == 0) {
        [finialResultArr addObject:patrolTime];
        [finialResultArr writeToFile:completePath atomically:YES];
    } else {
        finialResultArr = [NSMutableArray arrayWithArray:resultArr];
        NSInteger i = 0;
        for (NSDictionary *dic in resultArr) {
            if ([dic[@"patrolId"] isEqualToString:patrolTime[@"patrolId"]]) {
                [finialResultArr removeObject:dic];
                break;
            }
            i++;
        }
        
        if (i == finialResultArr.count) {
            [finialResultArr addObject:patrolTime];
        }
        
        [finialResultArr writeToFile:completePath atomically:YES];
    }
}


- (NSDictionary *)getPatrolTimeWithPatrolId:(NSString *)patrolId {
    
    NSArray *allPatrolTimeArr = [self getAllPatrolTime];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    if (allPatrolTimeArr.count > 0) {
        for (NSDictionary * patrolTimeDic in allPatrolTimeArr) {
            if ([patrolId isEqualToString:patrolTimeDic[@"patrolId"]]) {
                resultDic = [NSMutableDictionary dictionaryWithDictionary:patrolTimeDic];
                break;
            }
        }
    }
    
    return resultDic;
}

- (NSArray *)getAllPatrolTime {
    
    //找到Documents文件所在的路径 取得第一个Documents文件夹的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *completePath = [documentPath stringByAppendingPathComponent:@"patrolTime.plist"];
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:completePath];
    
    if (resultArr.count == 0) {
        //建立文件管理 创建plist
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:completePath contents:nil attributes:nil];
    }
    
    return resultArr;
}

@end
