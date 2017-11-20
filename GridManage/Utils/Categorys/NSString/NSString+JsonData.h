//
//  NSString+JsonData.h
//  GridManage
//
//  Created by gwj on 2017/11/6.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonData)


/**
 转json字符串

 @param infoDict <#infoDict description#>
 @return <#return value description#>
 */
+ (NSString *)convertToJSONData:(id)infoDict;


/**
 json字符串转字典

 @param jsonString <#jsonString description#>
 @return <#return value description#>
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
