//
//  NSString+AttributeColor.m
//  TravelApp
//
//  Created by gwj on 16/6/14.
//  Copyright © 2016 winsion. All rights reserved.
//

#import "NSString+AttributeColor.h"

@implementation NSString (AttributeColor)

+ (NSAttributedString *)getNewStringWithRange:(NSRange)range string:(NSString *)string color:(UIColor *)color {

    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:string];
    [newStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return newStr;
}

//+ (NSAttributedString *)getNewStringWithRange:(NSRange)range string:(NSString *)string{
//
//    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:string];
//    [newStr addAttribute:NSForegroundColorAttributeName value:CommentNameColor range:range];
//    
//    return newStr;
//}

+ (NSAttributedString *)setAttributes:(NSDictionary *)attributes range:(NSRange)range string:(NSString *)string{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];

    [attributedString setAttributes:attributes range:NSMakeRange(range.location, string.length-range.length)];

    return attributedString;
}

@end
