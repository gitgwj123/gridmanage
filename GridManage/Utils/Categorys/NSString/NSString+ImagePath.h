//
//  NSString+ImagePath.h
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ImagePath)

+ (NSString *)getFilePath;

+ (NSString *)getImageFileWithImage:(UIImage *)photo fileName:(NSString *)fileName;

@end
