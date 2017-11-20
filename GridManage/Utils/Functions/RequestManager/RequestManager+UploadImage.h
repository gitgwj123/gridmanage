//
//  RequestManager+UploadImage.h
//  GridManage
//
//  Created by gwj on 2017/11/12.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "RequestManager.h"

#define INVALID_FILE_CODE -1999

@interface RequestManager (UploadImage)


- (void)uploadImageWithImageFilePath:(NSString *)filePath block:(ResponseBlock)block;


@end
