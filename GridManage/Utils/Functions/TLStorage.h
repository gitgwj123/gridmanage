//
//  TLStorage.h
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLStorage : NSObject

/**
 *  设置/获取base_URL（登录设置：IP和端口）
 */
+ (void)setbase_URL:(NSString *)base_URL;
+ (NSString *)getbase_URL;

/**
 *  设置/获取userId
 */
+ (void)setUserId:(NSString *)userId;
+ (NSString *)getUserId;

/**
 *  设置/获取teamId
 */
+ (void)setTeamId:(NSString *)teamId;
+ (NSString *)getTeamId;

/**
 *  设置/获取username
 */
+ (void)setUsername:(NSString *)username;
+ (NSString *)getUsername;


/**
 *  设置/获取User photo
 */
+ (void)setUserPhoto:(NSString *)photo;
+ (NSString *)getUserPhoto;

/**
 *  设置/获取token
 */
+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;

/**
 *  设置/获取hash
 */
+ (void)setHash:(NSString *)hash;
+ (NSString *)getHash;


/**
 *  设置/获取pointName ex:第3候车室
 */
+ (void)setPointName:(NSString *)pointName;
+ (NSString *)getPointName;


/**
 *  MD5加密
 */
+ (NSString *)md5String:(NSString *)str;


@end
