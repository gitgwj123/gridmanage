//
//  UrlAPI.h
//  GridManage
//
//  Created by gwj on 2017/11/3.
//  Copyright © 2017年 gwj. All rights reserved.
//

#ifndef UrlAPI_h
#define UrlAPI_h

//auth
static NSString * const TLRequestUrlUserLogin = @"/kingkong/0.01/auth/userLogin"; //userLogin
static NSString * const TLRequestUrlUserLogout = @"/kingkong/0.01/auth/userLogout"; //userLogout

//job
static NSString * const TLRequestUrlFindByBaseCondition = @"/kingkong/0.01/job/findByBaseCondition"; //findByBaseCondition


static NSString * const TLRequestUrlPatrolSubmit = @"/grid/0.01/patrolSubmit/submit"; //如果提交的设备状态是FAILURE，则必须填写problemTypeId。另外，如果有多张图片，链接用逗号分开

static NSString * const TLRequestUrlUploadSingleFile = @"/kingkong/0.01/fileUpload/uploadSingleFile"; //uploadSingleFile

static NSString * const TLRequestUrlPublishTaskCommand = @"/kingkong/0.01/job/PublishTaskCommand"; // 发布命令与协作


#endif /* UrlAPI_h */
