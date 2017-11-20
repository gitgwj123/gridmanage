//
//  IIDate.h
//  Created by ZhangYiCheng on 11-9-18.
//  Copyright 2011 ZhangYiCheng. All rights reserved.
//

#define kFormat1 @"yyyy-MM-dd"  
#define kFormat2 @"yyyy-MM-dd HH:mm:ss"
#define kFormat3 @"dd-MM-yyyy"
#define kFormat4 @"H:mm yyyy-MM-dd"
#define kFormat5 @"HH:mm"
#define kFormat6 @"LLLL d, yyyy" //July 9, 2013
#define kFormat7 @"h:mm a" //2:58 PM
#define kFormat8 @"EEE, h:mm a" //Thu, 2:58 PM
#define kFormat9 @"d LLL, h:mm a" //4 Jan, 2:58 PM
#define kFormat10 @"yyyy-MM-dd, h:mm a" //2012-01-13, 2:58 PM
#define kFormat11 @"EEE" //Thu
#define kFormat12 @"d LLL" //4 Jan
#define kFormat13 @"yyyy-MM-dd HH:mm"
#define kFormat14 @"EEE MMM d HH:mm:ss Z yyyy" // Tue Mar 10 17:32:22 +0800 2016
#define kFormat15 @"今天HH:mm"
#define kFormat16 @"昨天HH:mm"
#define kFormat17 @"前天HH:mm"
#define kFormat18 @"yyyy-MM-dd HH:mm"
#define kFormat19 @"HH:mm:ss"

@interface IIDate : NSObject {
    NSDateFormatter *formatter;    
}
typedef enum {
    IIDateFormat1 = 0,
    IIDateFormat2 = 1,
    IIDateFormat3 = 2,
    IIDateFormat4 = 3,
    IIDateFormat5 = 4,
    IIDateFormat6 = 5,
    IIDateFormat7 = 6,
    IIDateFormat8 = 7,
    IIDateFormat9 = 8,
    IIDateFormat10 = 9,
    IIDateFormat11 = 10,
    IIDateFormat12 = 11,
    IIDateFormat13 = 12,
    IIDateFormat14 = 13,
    IIDateFormat15 = 14,
    IIDateFormat16 = 15,
    IIDateFormat17 = 16,
    IIDateFormat18 = 17,
    IIDateFormat19 = 18
} IIDateFormat;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSTimeZone *localTimeZone;
@property (nonatomic, strong) NSTimeZone *UTCTimeZone;

- (IIDate *)initWithFormat:(IIDateFormat)format;
- (IIDate *)init;
+ (NSString *)getNowDateStringOfFormat:(IIDateFormat)format;
+ (NSString *)getStringFromDate:(NSDate *)sdate ofFormat:(IIDateFormat)format;
+ (NSDate *)getDateFromString:(NSString *)string inFormat:(IIDateFormat)format;
+ (NSDate *)dateFromString:(NSString *)string inFormat:(NSString *)formate;

+ (NSInteger)age:(NSString *)dateString inFormat:(IIDateFormat)format;
+ (NSNumber *)getTimestampFromString:(NSString *)string inFormat:(IIDateFormat)format ;
+ (NSString *)convertDate:(double)timeStamp;
+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp;
+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp maxDays:(int)days;
+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp maxDays:(int)days timezone:(NSTimeZone *)timeZone;

+ (NSString *)calculateDateUtilNow:(NSDate *)date;
+ (NSString *)calculateDateUtilNow:(NSDate *)date maxDays:(int)days;
+ (NSString *)dateFormatStringFromIIDateFormat:(IIDateFormat)format;

+ (NSDate *) getDawnTime:(NSDate *)beforeDate;
+ (NSString *)getFormatteDawnTime:(NSDate *)beforeDate;


+ (NSString *)getStringFromDate:(NSDate *)sdate ofFormat:(IIDateFormat)format timeZone:(NSTimeZone *)zone;
+ (NSDate *)getDateYears:(int)years fromDate:(NSDate *)date;
+ (NSString *)localTimeFromUTCTime:(NSString *)UTCTime;
+ (NSString *)dateFromUTCTimestamp:(NSNumber *)UTCTimestamp;

- (NSString *)localTimeFromUTCTime:(NSString *)UTCTime ;

+ (NSString *)localTimeFromUTCTimestamp:(NSNumber *)timestamp;

+ (NSString *)compareDate:(NSDate *)date;
+ (BOOL)isCurrentDay:(NSDate *)date;
+ (BOOL)isYesterday:(NSDate *)date;
+ (BOOL)isTheDayBeforeYesterday:(NSDate *)date;
+ (BOOL)isInLast24Hours:(NSDate *)date;
+ (BOOL)isInLast7Days:(NSDate *)date;
+ (BOOL)isTheSameYearAsToday:(NSDate *)date;
+ (BOOL)isInLastHour:(NSDate *)date;
+ (BOOL)isInLastMinute:(NSDate *)date;
+ (NSInteger) calcuateDaysBetweenDay:(NSDate *)date1 date2:(NSDate*)date2;

+ (double)convertTimeInterval:(id)value;

+ (NSDate *)dateBeforeDate:(NSDate *)date timeInterval:(NSTimeInterval)timeInterval;

//
+ (NSString *)getHourAndMinuteWithTime:(NSString *)time;

@end
