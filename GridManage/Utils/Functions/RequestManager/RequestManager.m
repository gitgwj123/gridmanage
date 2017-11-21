//
//  RequestManager.m
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>

 static RequestManager *sharedManager = nil;

@interface RequestManager ()

{
    AFHTTPSessionManager *httpSessionManager;
}

@end

@implementation RequestManager


- (NSURLSessionDataTask *)findByBaseConditionRequest:(NSDictionary *)parameters withURL:(NSString *)url responseBlock:(ResponseBlock)responseBlock failureBlock:(ResponseFailureBlock)failureBlock {

    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":[TLStorage getToken], @"time":@"1", @"hash":[TLStorage getHash], @"opeCode":@"1"}];
    [parameterDic addEntriesFromDictionary:parameters];
    
    return [self performBasicRequest:parameterDic withURL:url responseBlock:responseBlock failureBlock:failureBlock];
}

- (NSURLSessionDataTask *)performBasicRequest:(NSDictionary *)parameters withURL:(NSString *)url responseBlock:(ResponseBlock)responseBlock failureBlock:(ResponseFailureBlock) failureBlock{

    NSString *finalUrl = [NSString stringWithFormat:@"%@%@", [TLStorage getbase_URL], url];

    return [self performPostRequestWithParameters:parameters url:finalUrl responseBlock:responseBlock failureBlock:failureBlock];
}

- (NSURLSessionDataTask *)performPostRequestWithParameters:(NSDictionary *)parameters url:(NSString *)url responseBlock:(ResponseBlock)responseBlock failureBlock:(ResponseFailureBlock)failureBlock {

    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [finalParameters addEntriesFromDictionary:[self getCommonParameters]];
    
    NSURLSessionDataTask *task = [httpSessionManager POST:url parameters:finalParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        BOOL isSuccessful = [dic[@"success"] boolValue];
        int code = [dic[@"code"] intValue];
        NSString *message = dic[@"message"];
        if ([message isKindOfClass:[NSNull class]]
            || [message isEqualToString:@""]) {
            message = nil;
        }
        
        NSString *hash = dic[@"hash"];
        
        id data = [dic objectForKey:@"data"];
        if ([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }

        responseBlock(isSuccessful, code, message, hash, data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"😱😱URL:%@ Request failed：%@",url,error);
        failureBlock(error);
    }];
    
    return task;
}

#pragma mark - private methods
- (NSDictionary *)getCommonParameters {

    NSMutableDictionary *lastParameters = [[NSMutableDictionary alloc]init];
#warning JPush的RegistrationID
    //deviceToken	一个token值，来自JPush的RegistrationID
    
    //appVersion 当前app的版本号
    static NSString *appVersion = nil;
    if (!appVersion) {
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    [lastParameters setObject:appVersion forKey:@"appVersion"];
    
    //osVersion 当前的操作系统的版本号
    static NSString *osVersion = nil;
    if (!osVersion) {
        osVersion = [[UIDevice currentDevice] systemVersion];
    }
    [lastParameters setObject:osVersion forKey:@"osVersion"];
    
    //model 当前手机的型号
    static NSString *model = nil;
    if (!model) {
        model = [self deviceModel];
    }
    [lastParameters setObject:model forKey:@"model"];
    
    return [lastParameters copy];
}

//- (NSString *)getWifiSSID {
//    //需要导入框架头文件 #import <SystemConfiguration/CaptiveNetwork.h>
//    NSArray *names = (__bridge NSArray*)CNCopySupportedInterfaces();
//    NSDictionary *info = nil;
//    for (NSString *name in names) {
//        info = (__bridge NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
//        if (info && [info count]) {
//            break;
//        }
//    }
//    NSString *ssidStr = [info objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
//    //NSString *bssid = [[info objectForKey:(__bridge NSString*)kCNNetworkInfoKeyBSSID] lowercaseString]; //BSSID wifi的MAC地址
//    return ssidStr;
//}

- (NSString *)deviceModel {
    //https://www.theiphonewiki.com/wiki/Main_Page
    // Gets a string with the device model
    //需要导入框架头文件#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    
    //iPhone X, iPhone 8, iPhone 8p
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    //iPhone 7
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2G (Cellular)";
    
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China Model)";
    
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9 inch";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9 inch";
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7 inch";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7 inch";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}


+ (instancetype)sharedManager {

    if (sharedManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[RequestManager alloc] init];
        });
    }
    return  sharedManager;
}

- (id)init {
    Class class = [self class];
    @synchronized(class) {
        if (sharedManager == nil) {
            if (self = [super init]) {
                sharedManager = self;
                httpSessionManager = [AFHTTPSessionManager manager];
                [httpSessionManager.requestSerializer setTimeoutInterval:30];  //Time out after 30 seconds
            }
        }
    }
    return  sharedManager;
}


@end
