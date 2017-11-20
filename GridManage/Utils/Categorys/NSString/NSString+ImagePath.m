//
//  NSString+ImagePath.m
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "NSString+ImagePath.h"

@implementation NSString (ImagePath)

+ (NSString *)getFilePath {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    return fileName;
}

+ (NSString *)getImageFileWithImage:(UIImage *)photo fileName:(NSString *)fileName{
    
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"deviceTroubleImage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSData *data = UIImageJPEGRepresentation(photo, 0.5f);
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:NO];
    
    return filePath;
}


@end
