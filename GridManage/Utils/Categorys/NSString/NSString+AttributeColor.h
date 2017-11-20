//
//  NSString+AttributeColor.h
//  TravelApp
//
//  Created by gwj on 16/6/14.
//  Copyright © 2016 winsion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributeColor)

///**
// *  改变字符串 范围的字体属性
// *
// *  @param range  <#range description#>
// *  @param string <#string description#>
// *
// *  @return <#return value description#>
// */
//+ (NSAttributedString *)getNewStringWithRange:(NSRange)range string:(NSString *)string;


/**
 <#Description#>

 @param range  <#range description#>
 @param string <#string description#>
 @param color  <#color description#>

 @return <#return value description#>
 */
+ (NSAttributedString *)getNewStringWithRange:(NSRange)range string:(NSString *)string color:(UIColor *)color;

+ (NSAttributedString *)setAttributes:(NSDictionary *)attributes range:(NSRange)range string:(NSString *)string;

@end
