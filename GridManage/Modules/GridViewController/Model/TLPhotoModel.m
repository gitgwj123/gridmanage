//
//  TLPhotoModel.m
//  GridManage
//
//  Created by gwj on 2017/11/17.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "TLPhotoModel.h"

@implementation TLPhotoModel

- (NSString *)description {
    return [NSString stringWithFormat:@"filePath:%@\n type:%ld\n", self.filePath, self.type];
}

@end
