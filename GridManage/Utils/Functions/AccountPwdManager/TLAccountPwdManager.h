//
//  TLAccountPwdManager.h
//  GridManage
//
//  Created by gwj on 2017/11/14.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAccountPwdManager : NSObject


+ (instancetype)sharedManager;

/**
 <#Description#>
 
 @param accountPwd 包含一组字典  @"account":@""  @"pwd":@"" @"imageUrl":@""
 */
- (void)saveAccountPwdWithAccountPwdDictionary:(NSDictionary *)accountPwd;

- (void)deleteAccountPwdWithAccount:(NSString *)account;

- (NSArray *)getAllAccountPwd;



@end
