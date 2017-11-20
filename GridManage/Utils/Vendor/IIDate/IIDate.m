//
//  IIDate.m
//
//  提供静态方法处理字符串与时间类型的相互转换
//  Created by ZhangYiCheng on 11-9-18.
//  Copyright 2011 ZhangYiCheng. All rights reserved.
//

#import "IIDate.h"

@interface IIDate()
+ (NSString *)dateFormatStringFromIIDateFormat:(IIDateFormat)format;
@end

@implementation IIDate

@synthesize formatter;
@synthesize localTimeZone;
@synthesize UTCTimeZone;

#pragma mark - Private methods
+ (NSString *)dateFormatStringFromIIDateFormat:(IIDateFormat)format
{
    if (format == IIDateFormat1)
    {
        return kFormat1;
    }
    else if (format == IIDateFormat2)
    {
        return kFormat2;
    }
    else if (format == IIDateFormat3)
    {
        return kFormat3;
    }
    else if (format == IIDateFormat4)
    {
        return kFormat4;
    }
    else if (format == IIDateFormat5)
    {
        return kFormat5;
    }
    else if (format == IIDateFormat6)
    {
        return kFormat6;
    }
    else if (format == IIDateFormat7)
    {
        return kFormat7;
    }
    else if (format == IIDateFormat8)
    {
        return kFormat8;
    }
    else if (format == IIDateFormat9)
    {
        return kFormat9;
    }
    else if (format == IIDateFormat10)
    {
        return kFormat10;
    }
    else if (format == IIDateFormat11)
    {
        return kFormat11;
    }
    else if (format == IIDateFormat12)
    {
        return kFormat12;
    }
    else if (format == IIDateFormat13)
    {
        return kFormat13;
        
    }else if (format == IIDateFormat14)
    {
        return kFormat14;
    }else if (format == IIDateFormat15)
    {
        return kFormat15;
    }else if (format == IIDateFormat16)
    {
        return kFormat16;
    }else if (format == IIDateFormat17)
    {
        return kFormat17;
    }else if (format == IIDateFormat18)
    {
        return kFormat18;
    }

    return nil;
}

#pragma mark - Public methods

- (IIDate *)init {
    
    if (self = [super init]) {
        
        formatter = [[NSDateFormatter alloc] init];
        localTimeZone = [NSTimeZone localTimeZone];
        UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    }
    return self;
    
//    formatter = [[NSDateFormatter alloc] init];
//    localTimeZone = [NSTimeZone localTimeZone]; 
//    UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    return  self = [super init];
}

- (IIDate *)initWithFormat:(IIDateFormat)format {
    
    if (self = [super init]) {
        
        self.formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
        [self.formatter setTimeZone:zone];
        if (format == IIDateFormat1) {
            [formatter setDateFormat:kFormat1];
        } else if (format == IIDateFormat2){
            [formatter setDateFormat:kFormat2];
        }
        else if (format == IIDateFormat2)
        {
            [formatter setDateFormat:kFormat3];
        }
        else
        {
            [formatter setDateFormat:kFormat4];
        }
    }
    
    return self;
    
//    self.formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [self.formatter setTimeZone:zone];
//    if (format == IIDateFormat1) {
//        [formatter setDateFormat:kFormat1];
//    } else if (format == IIDateFormat2){
//        [formatter setDateFormat:kFormat2];
//    }
//    else if (format == IIDateFormat2)
//    {
//        [formatter setDateFormat:kFormat3];
//    }
//    else
//    {
//        [formatter setDateFormat:kFormat4];
//    }
//    return self;
}

// 得到当前时间的字符串类型值
+ (NSString *)getNowDateStringOfFormat:(IIDateFormat)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:[self dateFormatStringFromIIDateFormat:format]];
    return [formatter stringFromDate:[NSDate date]];
}

// 时间类型转换成字符串类型
+ (NSString *)getStringFromDate:(NSDate *)sdate ofFormat:(IIDateFormat)format 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:[self dateFormatStringFromIIDateFormat:format]];
    return [formatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate:(NSDate *)sdate ofFormat:(IIDateFormat)format timeZone:(NSTimeZone *)zone{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:gregorianCalendar];
    [formatter setTimeZone:zone];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:[self dateFormatStringFromIIDateFormat:format]];
    return [formatter stringFromDate:sdate];
}

+ (NSNumber *)getTimestampFromString:(NSString *)string inFormat:(IIDateFormat)format
{
//    NSDate *date = [self getDateFromString:string inFormat:format];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:[self dateFormatStringFromIIDateFormat:format]];
    NSDate *date = [formatter dateFromString:string];

    double timestamp = [date timeIntervalSince1970];
    
    NSNumber *temp = [NSNumber numberWithDouble:timestamp];
    
    return temp;
}

+ (NSString *)localTimeFromUTCTime:(NSString *)UTCTime 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [formatter setTimeZone:zone];
    [formatter setDateFormat:kFormat2];
    
    NSDate *date = [formatter dateFromString:UTCTime];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    return  [formatter stringFromDate:date];
}

- (NSString *)localTimeFromUTCTime:(NSString *)UTCTime 
{
    [formatter setTimeZone:UTCTimeZone];
    
    [formatter setDateFormat:kFormat2];
    
    NSDate *date = [formatter dateFromString:UTCTime];
    
    [formatter setTimeZone:localTimeZone];
    
    return  [formatter stringFromDate:date];
}

+ (NSString *)localTimeFromUTCTimestamp:(NSNumber *)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    
    NSString *dateString = [self getStringFromDate:date ofFormat:IIDateFormat2 timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:kFormat2];
    
    NSDate *localDate = [formatter dateFromString:dateString];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return  [formatter stringFromDate:localDate];

}

+ (NSString *) getFormatteDawnTime:(NSDate *)beforeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *utcDawnStr = [formatter stringFromDate:beforeDate];
    return utcDawnStr;
}

//获取给定时间的凌晨时间
+ (NSDate *)getDawnTime:(NSDate *)beforeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *utcDawnStr = [formatter stringFromDate:beforeDate];

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:gregorianCalendar];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:kFormat2];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    NSDate *localDate = [formatter dateFromString:utcDawnStr];
    
    return localDate;
}

+ (NSString *)dateFromUTCTimestamp:(NSNumber *)UTCTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:UTCTimestamp.doubleValue];
    NSString *dateString = [self getStringFromDate:date ofFormat:IIDateFormat2 timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return dateString;
}

// 字符类型转换成时间类型
+ (NSDate *)getDateFromString:(NSString *)string inFormat:(IIDateFormat)format
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:gregorianCalendar];
    //NSTimeZone *zone = [NSTimeZone localTimeZone];
    //[formatter setTimeZone:zone];
    [formatter setDateFormat:[self dateFormatStringFromIIDateFormat:format]];
    return [formatter dateFromString:string];
}

+ (NSDate *)dateFromString:(NSString *)string inFormat:(NSString *)formate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:gregorianCalendar];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
 
    [formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setDateFormat:formate];
    return [formatter dateFromString:string];
}

+ (NSInteger)age:(NSString *)dateString inFormat:(IIDateFormat)format
{
    if ([dateString isKindOfClass:[NSNull class]] || dateString.length == 0 || dateString == nil)
    {
        //return 20;
        //AZ - 20130422 -
        return 0;
    }
    NSDate *dateOfBirth = [self getDateFromString:dateString inFormat:format];
    if (dateOfBirth == nil)
    {
        //return 20;
        //AZ - 20130422 - 
        return 0;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    }
    else
    {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

+ (NSString *)convertDate:(double)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setCalendar:gregorianCalendar];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateYears:(int)years fromDate:(NSDate *)date 
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1*years;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    return previousDate;
}


+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp maxDays:(int)days
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setCalendar:gregorianCalendar];

    float timeGap = [date timeIntervalSince1970] - [[dateFormatter dateFromString:timestamp] timeIntervalSince1970];
    if (timeGap>=60*60*24*30*12) {
        int i = timeGap/(60*60*24*30*12);
        if (i > 0)
        {
            return timestamp;
        }
    } else if(timeGap>=60*60*24*30) {
        int i = timeGap/(60*60*24*30);
        if (i > 0)
        {
            return timestamp;
        }
    } else if(timeGap>=60*60*24)
    {
        int i = timeGap/(60*60*24);

        if (i > days && i != 0)
        {
            return timestamp;
        }
        if (i>1) {
            return [NSString stringWithFormat:@"%d days ago", i];
        } else {
            return @"1 day ago";
        }
    } else if(timeGap>=60*60) {
        int i = timeGap/(60*60);
        if (i>1) {
            return [NSString stringWithFormat:@"%d hours ago", i];
        } else {
            return @"1 hour ago";
        }
    } else if(timeGap>=60)
    {
        int i = timeGap/60;
        if (i>1) {
            return [NSString stringWithFormat:@"%d minutes ago", i];
        } else {
            return @"1 minute ago";
        }
    }
    else
    {
        int i = timeGap;

        if (i>1)
        {
            return [NSString stringWithFormat:@"%d seconds ago", i];
        }
        else
        {
            return @"1 second ago";
        }
    }
    return nil;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *theDayBeforeYesterday, *yesterday;
    
    theDayBeforeYesterday = [today dateByAddingTimeInterval: - 2 * secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * theDayBeforeYesterdayString = [[theDayBeforeYesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:theDayBeforeYesterdayString])
    {
        return @"前天";
    }
    else
    {
        return dateString;
    }
}


+ (BOOL)isCurrentDay:(NSDate *)date
{
    NSString *currentDayString = [self getStringFromDate:[NSDate date] ofFormat:IIDateFormat1 timeZone:[NSTimeZone localTimeZone]];
    NSString *dateString       = [self getStringFromDate:date ofFormat:IIDateFormat1 timeZone:[NSTimeZone localTimeZone]];
    
    if ([currentDayString isEqualToString:dateString])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isYesterday:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
  if ([dateString isEqualToString:yesterdayString]){
      
      return YES;
    }
    
    return NO;
    
}

+ (BOOL)isTheDayBeforeYesterday:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *theDayBeforeYesterday;
    
    theDayBeforeYesterday = [today dateByAddingTimeInterval: - 2 * secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * theDayBeforeYesterdayString = [[theDayBeforeYesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:theDayBeforeYesterdayString]){
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)isJustNowInOneMinute:(NSDate *)date{

    NSDate *today = [[NSDate alloc] init];
    float different = [date timeIntervalSinceDate:today];
    
    if (different < 60) {
        
        return YES;
    }
    
    return NO;
    
}



+ (BOOL)isInLastHour:(NSDate *)date
{

    //当iPhone 系统时间未做调整时可用（如果时间快或慢，与服务器返回时间会有误差， 不建议使用）
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitHour
                                                fromDate:date
                                                  toDate:[NSDate date] options:0];
    NSInteger hours = [components hour];
    if (hours >= 1)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isInLastMinute:(NSDate *)date
{
    
    if (!date)
    {
        return NO;
    }
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMinute
                                                fromDate:date
                                                  toDate:[NSDate date] options:0];
    NSInteger minutes = [components minute];
    if (minutes > 1)
    {
        return NO;
    }
    return YES;
}


+ (BOOL)isInLast24Hours:(NSDate *)date
{   
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay
                                                fromDate:date
                                                  toDate:[NSDate date] options:0];
    NSInteger days = [components day];
    if (days == 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isInLast7Days:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    NSInteger days = [comps day];
    if (days < 6)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isTheSameYearAsToday:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
    if ([comps year] == 0)
    {
        return YES;
    }
    return NO;
}

+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp maxDays:(int)days timezone:(NSTimeZone *)timeZone
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    float timeGap = [date timeIntervalSince1970] - [[dateFormatter dateFromString:timestamp] timeIntervalSince1970];
    if (timeGap>=60*60*24*30*12) {
        int i = timeGap/(60*60*24*30*12);
        if (i > 0)
        {
            return timestamp;
        }
    } else if(timeGap>=60*60*24*30) {
        int i = timeGap/(60*60*24*30);
        if (i > 0)
        {
            return timestamp;
        }
    } else if(timeGap>=60*60*24)
    {
        int i = timeGap/(60*60*24);
        
        if (i > days && i != 0)
        {
            return timestamp;
        }
        if (i>1) {
            return [NSString stringWithFormat:@"%d days ago", i];
        } else {
            return @"1 day ago";
        }
    } else if(timeGap>=60*60) {
        int i = timeGap/(60*60);
        if (i>1) {
            return [NSString stringWithFormat:@"%d hours ago", i];
        } else {
            return @"1 hour ago";
        }
    } else if(timeGap>=60)
    {
        int i = timeGap/60;
        if (i>1) {
            return [NSString stringWithFormat:@"%d minutes ago", i];
        } else {
            return @"1 minute ago";
        }
    }
    else
    {
        int i = timeGap;
        
        if (i>1)
        {
            return [NSString stringWithFormat:@"%d seconds ago", i];
        }
        else
        {
            return @"1 second ago";
        }
    }
    return @"";
}

+ (NSInteger) calcuateDaysBetweenDay:(NSDate *)date1 date2:(NSDate*)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *fromDate;
    NSDate *toDate;
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:date1];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:date2    ];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSString *)calculateTimeUtilNow:(NSString *)timestamp
{
    return [self calculateTimeUtilNow:timestamp maxDays:0];
}

+ (NSString *)calculateDateUtilNow:(NSDate *)date maxDays:(int)days
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setCalendar:gregorianCalendar];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    float timeGap = [nowDate timeIntervalSince1970] - [date timeIntervalSince1970];
    if (timeGap>=60*60*24*30*12) {
        int i = timeGap/(60*60*24*30*12);
        if (i > 0)
        {
            return dateString;
        }
    } else if(timeGap>=60*60*24*30) {
        int i = timeGap/(60*60*24*30);
        if (i > 0)
        {
            return dateString;
        }
    } else if(timeGap>=60*60*24)
    {
        int i = timeGap/(60*60*24);
        
        if (i > days && i != 0)
        {
            return dateString;
        }
        if (i>1) {
            return [NSString stringWithFormat:@"%d days ago", i];
        } else {
            return @"1 day ago";
        }
    } else if(timeGap>=60*60) {
        int i = timeGap/(60*60);
        if (i>1) {
            return [NSString stringWithFormat:@"%d hours ago", i];
        } else {
            return @"1 hour ago";
        }
    } else if(timeGap>=60)
    {
        int i = timeGap/60;
        if (i > 1) {
            return [NSString stringWithFormat:@"%d minutes ago", i];
        } else {
            return @"1 minute ago";
        }
    }
    else
    {
        int i = timeGap;
        
        if (i > 1)
        {
            return [NSString stringWithFormat:@"%d seconds ago", i];
        }
        else
        {
            return @"1 second ago";
        }
    }
    return @"";
}

+ (NSString *)calculateDateUtilNow:(NSDate *)date
{
    return [self calculateDateUtilNow:date maxDays:0];
}

+ (double)convertTimeInterval:(id)value {
    NSString *number = [NSString stringWithFormat:@"%@",value];
//    MyLog(@"number : %@",number);
    if (!number
        || number.length == 0
        || [number isEqualToString:@""]
        || number.doubleValue < 0
        || number.length < 10) {
        return  -1;
    }
    
    if (number.length == 13) {
        return number.doubleValue / 1000.0;
    } else if (number.length == 10) {
        return number.doubleValue;
    }
    NSAssert(NO, @"Error data value");
    return 946656000; //返回一个default value 2000/1/1 0:0:0
}


+ (NSDate *)dateBeforeDate:(NSDate *)date timeInterval:(NSTimeInterval)timeInterval;
{
    if (!date) {
        return nil;
    }
    NSDate *ndate = [[NSDate alloc]initWithTimeInterval:-1 * timeInterval sinceDate:date];
    return ndate;
}

+ (NSString *)getHourAndMinuteWithTime:(NSString *)time {
    // planendtime:2017-11-07 23:59:00.0
    NSString *hourAndMinute = @"";
    
    if (![time isEqualToString:@"-- --"] && ![time isEqualToString:@""]) {
        
        NSArray *arrDate = [time componentsSeparatedByString:@" "];//按空格分割
        
        if (arrDate.count >= 2) {
            NSString *timeStr = arrDate[1];
            NSArray *arrTime = [timeStr componentsSeparatedByString:@":"];
            hourAndMinute = [NSString stringWithFormat:@"%@:%@", arrTime[0], arrTime[1]];
        }
    }
    
    
    return hourAndMinute;
}



@end
