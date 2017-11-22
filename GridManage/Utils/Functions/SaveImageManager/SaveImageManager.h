//
//  SaveImageManager.h
//  GridManage
//
//  Created by gwj on 2017/11/22.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^saveBlock)(BOOL success);

@interface SaveImageManager : NSObject

+ (instancetype)sharedManager;

-(UIImage *) getImageFromURL:(NSString *)fileURL;

- (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath saveBlock:(saveBlock)saveBlock;

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

@end
