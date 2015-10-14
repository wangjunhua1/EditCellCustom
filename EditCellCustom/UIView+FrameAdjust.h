//
//  UIView+FrameAdjust.h
//  hello
//
//  Created by mark on 15/9/24.
//  Copyright (c) 2015年 mark. All rights reserved.
//  调整对象的属性的结构体x y w h (OC语法是不允许直接调整对象的属性的结构体x y w h 所以给UIView增加分类)

#import <UIKit/UIKit.h>

@interface UIView (FrameAdjust)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@end
