//
//  NSString+CarrayoutTime.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "NSString+CarrayoutTime.h"

@implementation NSString (CarrayoutTime)

+ (NSString *)getCarryoutTimeWithRealstarttime:(NSString *)realstarttime realendtime:(NSString *)realendtime {
    
    if ([realstarttime isEqualToString:@"-- --"] || [realstarttime isEqualToString:@""]) {
        return @"0分";
    } else {
        
        NSInteger realstarttimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:realstarttime] inFormat:IIDateFormat2] integerValue];
        NSInteger realendtimeTimeStamp = 0;
        
        if ([realendtime isEqualToString:@"-- --"] || [realendtime isEqualToString:@""] ) {
            realendtime = [IIDate getStringFromDate:[NSDate new] ofFormat:IIDateFormat2 timeZone:[NSTimeZone localTimeZone]];
            realendtimeTimeStamp = [[IIDate getTimestampFromString:realendtime inFormat:IIDateFormat2] integerValue];
        } else {
            realendtimeTimeStamp = [[IIDate getTimestampFromString:[self yearToSecendWithDate:realendtime] inFormat:IIDateFormat2] integerValue];
        }
        
        return [NSString stringWithFormat:@"%ld分", (realendtimeTimeStamp - realstarttimeTimeStamp)/60];
    }
}

+ (NSString *)yearToSecendWithDate:(NSString *)date {
    //2017-11-14 16:13:00.0
    NSString *timeStr = @"0";
    NSArray *timeArray = [date componentsSeparatedByString:@"."];
    if (timeArray.count == 2) {
        timeStr = [timeArray firstObject];
    }
    return timeStr;
}


@end
