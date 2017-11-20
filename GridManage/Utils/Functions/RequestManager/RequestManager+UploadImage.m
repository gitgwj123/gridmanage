//
//  RequestManager+UploadImage.m
//  GridManage
//
//  Created by gwj on 2017/11/12.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "RequestManager+UploadImage.h"
#import <AFNetworking/AFNetworking.h>


@implementation RequestManager (UploadImage)


- (void)uploadImageWithImageFilePath:(NSString *)filePath block:(ResponseBlock)block {
    
    NSString *finalURL;
    finalURL = [NSString stringWithFormat:@"%@%@", [TLStorage getbase_URL], TLRequestUrlUploadSingleFile];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if (!imageData) {
        block(NO, INVALID_FILE_CODE, @"不能读取文件", @"", nil);
        return;
    }
    NSString *fileName = [filePath lastPathComponent];
    if ([fileName componentsSeparatedByString:@"."].count == 0) {
        fileName = [NSString stringWithFormat:@"%@.jpg",fileName];
    }
    
    MyLog(@"❗❗❗start upload image");
    
    NSDictionary *finalParameters = @{@"token":[TLStorage getToken], @"time":@"1", @"hash":[TLStorage getHash]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    
    [manager POST:finalURL parameters:finalParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        MyLog(@"🕛🕒🕙upload %@ progress: %@/%@", fileName ,@(uploadProgress.totalUnitCount), @(uploadProgress.completedUnitCount));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"✅✅✅Upload %@ successfully",fileName);
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        BOOL isSuccesfull = ((NSString *)[dic objectForKey:@"success"]).boolValue;
        int code = ((NSString *)[dic objectForKey:@"code"]).intValue;
        NSString *message = [dic objectForKey:@"message"];
        id data = [dic objectForKey:@"data"];
        
        if ([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }
        if (!isSuccesfull || code != 0) {
            MyLog(@"❎❎❎FileName:%@ message:%@",fileName,message);
        }
        block(isSuccesfull, code, message, dic[@"hash"], data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"❌❌❌Upload %@ Failed : %@", fileName, error);
        
        if ([[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"]) {
            NSData *data = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            MyLog(@"❌❌❌Error Msg: %@", [[NSString alloc]initWithData:data encoding:4]);
        }
        
        block(NO, REQUEST_FAIL_CODE, [error description], @"", nil);
        
    }];
    
}



@end
