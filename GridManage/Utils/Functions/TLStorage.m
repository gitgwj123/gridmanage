//
//  TLStorage.m
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLStorage.h"
#import <CommonCrypto/CommonDigest.h> // 苹果自带 MD5加密需要导入的头文件


@implementation TLStorage


//设置/获取base_URL（登录设置：IP和端口）

+ (void)setbase_URL:(NSString *)base_URL {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:base_URL forKey:@"KEY_Base_URL"];
    [userDef synchronize];
}
+ (NSString *)getbase_URL {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_Base_URL"];
}



//设置/获取userId
+ (void)setUserId:(NSString *)userId {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:userId forKey:@"KEY_userId"];
    [userDef synchronize];
}
+ (NSString *)getUserId{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_userId"];
}

//设置/获取teamId
+ (void)setTeamId:(NSString *)teamId {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:teamId forKey:@"KEY_teamId"];
    [userDef synchronize];
}
+ (NSString *)getTeamId{

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_teamId"];
}

/**
 *  设置/获取username
 */
+ (void)setUsername:(NSString *)username {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:username forKey:@"KEY_username"];
    [userDef synchronize];
}
+ (NSString *)getUsername{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_username"];
}

// 设置/获取User photo
+ (void)setUserPhoto:(NSString *)photo {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:photo forKey:@"KEY_UserPhoto"];
    [userDef synchronize];

}
+ (NSString *)getUserPhoto{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_UserPhoto"];
    
}

// 设置/获取token
+ (void)setToken:(NSString *)token {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:token forKey:@"KEY_token"];
    [userDef synchronize];
    
}
+ (NSString *)getToken{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_token"];
}

// 设置/获取hash

+ (void)setHash:(NSString *)hash {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:hash forKey:@"KEY_hash"];
    [userDef synchronize];
}
+ (NSString *)getHash {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_hash"];


}

//设置/获取pointName ex:第3候车室
+ (void)setPointName:(NSString *)pointName{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:pointName forKey:@"KEY_pointName"];
    [userDef synchronize];
}
+ (NSString *)getPointName {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:@"KEY_pointName"];
}


//MD5加密
+ (NSString *)md5String:(NSString *)str
{
    const char * strK = [str UTF8String];
    unsigned char buff[16];
    CC_MD5(strK, (CC_LONG)strlen(strK), buff);
    
    NSMutableString *newStr = [NSMutableString string];
    for (int i = 0; i < 16; i ++) {
        [newStr appendFormat:@"%02x",buff[i]];
    }
    return newStr;
}

@end
