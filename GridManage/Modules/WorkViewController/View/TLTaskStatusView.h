//
//  TLTaskStatusView.h
//  GridManage
//
//  Created by gwj on 2017/11/13.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLTaskStatusViewDelegate <NSObject>

- (void)taskStatusViewTapWithStatus:(NSString *)status;

@end

@interface TLTaskStatusView : UIView

@property (nonatomic, weak) id<TLTaskStatusViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame choosedText:(NSString *)text;

@end
