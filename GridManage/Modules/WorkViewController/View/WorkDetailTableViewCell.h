//
//  WorkDetailTableViewCell.h
//  GridManage
//
//  Created by gwj on 2017/11/16.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *WorkDetailTableViewCellIdentifier;

@interface WorkDetailTableViewCell : UITableViewCell

- (void)setupWorkDetailCellWithImageFilePath:(NSString *)imageFilePath loadStatusType:(TLloadImageType)type;

@end
