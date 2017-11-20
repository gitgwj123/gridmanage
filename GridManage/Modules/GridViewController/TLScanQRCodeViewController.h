//
//  TLScanQRCodeViewController.h
//  GridManage
//
//  Created by gwj on 2017/11/10.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "BaseViewController.h"

@interface TLScanQRCodeViewController : BaseViewController

@property (nonatomic, copy) void(^scanQRcodeBlock)(NSString *scanResult);


@end
