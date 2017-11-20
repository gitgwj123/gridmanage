//
//  NSString+StartAndEndTime.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "NSString+StartAndEndTime.h"

@implementation NSString (StartAndEndTime)


+ (NSString *)getStartTimeAndEndTimeWithStarttime:(NSString *)starttime endtime:(NSString *)endtime {
    
    NSString *starttimeK = @"";
    NSString *endtimeK = @"";
    if ([starttime isEqualToString:@""] || [starttime isEqualToString:@""]) {
        starttimeK = @"--:--";
    } else {
        starttimeK = [starttime substringWithRange:NSMakeRange(11, 5)];
    }
    
    if ([endtime isEqualToString:@""] || [endtime isEqualToString:@""]) {
        endtimeK = @"--:--";
    } else {
        endtimeK = [endtime substringWithRange:NSMakeRange(11, 5)];
    }
    
    return [NSString stringWithFormat:@"%@ ~ %@", starttimeK, endtimeK];
}

@end
