//
//  UILabel+Parameter.h
//  GridManage
//
//  Created by gwj on 2017/11/7.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Parameter)


/**
 默认字号18 label

 @param text <#text description#>
 @param textColor <#textColor description#>
 @param frame <#frame description#>
 @return <#return value description#>
 */
+ (UILabel *)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame;

+ (UILabel *)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame font:(UIFont *)font alignment:(NSTextAlignment)alignment;

+ (UILabel *)addLabelWithBgColor:(UIColor *)bgColor frame:(CGRect)frame;

@end
