//
//  NSString+StringSize.m
//  hello
//
//  Created by mark on 15/9/24.
//  Copyright (c) 2015年 mark. All rights reserved.
//  返回字符串所占用的尺寸

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
