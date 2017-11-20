//
//  RequestManager.h
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQUEST_FAIL_CODE -999

typedef void(^ResponseBlock)(BOOL isSuccessful, int code, NSString *message, NSString *hash, id data);
typedef void(^ResponseFailureBlock)(NSError *error);

@interface RequestManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)findByBaseConditionRequest:(NSDictionary *)parameters withURL:(NSString *)url responseBlock:(ResponseBlock)responseBlock failureBlock:(ResponseFailureBlock)failureBlock;

- (NSURLSessionDataTask *)performBasicRequest:(NSDictionary *)parameters withURL:(NSString *)url responseBlock:(ResponseBlock)responseBlock failureBlock:(ResponseFailureBlock)failureBlock;

@end
