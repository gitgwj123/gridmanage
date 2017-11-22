//
//  SaveImageManager.m
//  GridManage
//
//  Created by gwj on 2017/11/22.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "SaveImageManager.h"

static SaveImageManager *saveImageManager = nil;

@implementation SaveImageManager


+ (instancetype)sharedManager {
    
    if (saveImageManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            saveImageManager = [[SaveImageManager alloc] init];
        });
    }
    return  saveImageManager;
}

- (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath saveBlock:(saveBlock)saveBlock {
    BOOL success;
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        success = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        success = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
        success = 0;
    }
    
    saveBlock(success);
}


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


@end
