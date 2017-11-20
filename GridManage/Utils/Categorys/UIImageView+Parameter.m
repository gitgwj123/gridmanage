//
//  UIImageView+Parameter.m
//  GridManage
//
//  Created by gwj on 2017/11/7.
//  Copyright © 2017年 gwj. All rights reserved.
//

#import "UIImageView+Parameter.h"

@implementation UIImageView (Parameter)

+ (UIImageView *)addImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

@end
