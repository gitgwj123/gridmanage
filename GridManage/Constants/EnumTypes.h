//
//  EnumTypes.h
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#ifndef EnumTypes_h
#define EnumTypes_h

/**
 上传、下载照片 状态 type.
 
 - loadingType: 上传中
 - UploadSuccessType: 上传成功
 - UploadFailureType: 上传失败
 */
typedef NS_ENUM(NSInteger, TLloadImageType) {
    loadingType = 0,
    loadSuccessType = 1,
    loadFailureType = 2,
};

typedef NS_ENUM(NSInteger, TLPhotoType) {
    photoType_publish = 0,
    photoType_opreator = 1,
};

#endif /* EnumTypes_h */
