//
//  AccountPwdTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/14.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *AccountPwdTableViewCellIdentifier;

@interface AccountPwdTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^accountPwdDeleteActionblock)(NSString *accountName);

- (void)setupAccountPwdTableViewCellWithImageUrl:(NSString *)imageUrl accountName:(NSString *)accountName;

@end
