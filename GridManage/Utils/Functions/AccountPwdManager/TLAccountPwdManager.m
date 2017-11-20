//
//  TLAccountPwdManager.m
//  GridManage
//
//  Created by gwj on 2017/11/14.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLAccountPwdManager.h"

static TLAccountPwdManager *accountPwdManager = nil;

@implementation TLAccountPwdManager


+ (instancetype)sharedManager {
    
    if (accountPwdManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            accountPwdManager = [[TLAccountPwdManager alloc] init];
        });
    }
    return  accountPwdManager;
}

- (NSString *)getSaveDataPath {

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *completePath = [documentPath stringByAppendingPathComponent:@"accountPwd.plist"];
    return completePath;
}

//包含一组字典  @"account":@""  @"pwd":@""
- (void)saveAccountPwdWithAccountPwdDictionary:(NSDictionary *)accountPwd {

    NSString *completePath = [self getSaveDataPath];
    
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:completePath];
    NSMutableArray *finialResultArr = [[NSMutableArray alloc] init];
    if (resultArr.count == 0) {
        [finialResultArr addObject:accountPwd];
        [finialResultArr writeToFile:completePath atomically:YES];
    } else {
        finialResultArr = [NSMutableArray arrayWithArray:resultArr];
     
        NSInteger i = 0;
        for (NSDictionary *dic in resultArr) {
            if ([dic[@"account"] isEqualToString:accountPwd[@"account"]]) {
                [finialResultArr removeObject:dic];
                break;
            } else {
                i++;
            }
        }
        
        if (i == finialResultArr.count) {
            [finialResultArr addObject:accountPwd];
        }
        
        [finialResultArr writeToFile:completePath atomically:YES];
    }
}

- (void)deleteAccountPwdWithAccount:(NSString *)account {

    NSString *completePath = [self getSaveDataPath];;
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:completePath];
    NSMutableArray *finialResultArr = [NSMutableArray arrayWithArray:resultArr];
    for (NSDictionary *dic in finialResultArr) {
        if ([dic[@"account"] isEqualToString:account]) {
            [finialResultArr removeObject:dic];
            break;
        }
    }
    [finialResultArr writeToFile:completePath atomically:YES];
    
}

- (NSArray *)getAllAccountPwd{

    NSString *completePath = [self getSaveDataPath];;
    NSArray *resultArr = [NSArray arrayWithContentsOfFile:completePath];
    
    if (resultArr.count == 0) {
        //建立文件管理 创建plist
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:completePath contents:nil attributes:nil];
    }
    
    return resultArr;
}

@end
