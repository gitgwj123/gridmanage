//
//  UILabel+Parameter.m
//  GridManage
//
//  Created by gwj on 2017/11/7.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "UILabel+Parameter.h"

@implementation UILabel (Parameter)

+ (UILabel *)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame {
   
    return [self addLabelWithText:text textColor:textColor frame:frame font:FONT(18) alignment:NSTextAlignmentLeft];
}

+ (UILabel *)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame font:(UIFont*)font alignment:(NSTextAlignment)alignment {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.font = font;
    label.textColor = textColor;
    
    return label;
}

+ (UILabel *)addLabelWithBgColor:(UIColor *)bgColor frame:(CGRect)frame {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = bgColor;
    
    return label;
}

@end
