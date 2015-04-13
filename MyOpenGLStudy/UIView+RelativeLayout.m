//
//  UIView+RelativeLayout.m
//  NamedViewTest
//
//  Created by XiaoG on 15-4-11.
//  Copyright (c) 2015年 XiaoG. All rights reserved.
//

#import "UIView+RelativeLayout.h"
#import <QuartzCore/QuartzCore.h>

#define RandomColorComponent arc4random() % 256 ) / 255.0
#define RandomColor [UIColor colorWithRed:(RandomColorComponent green:(RandomColorComponent blue:(RandomColorComponent alpha:1.0]

@implementation UIView (RelativeLayout)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
    [self showBorder];
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
    [self showBorder];
}

- (CGFloat)right {
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
    
    [self showBorder];
}

- (CGFloat)bottom {
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
    
    [self showBorder];
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
    
    [self showBorder];
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
    
    [self showBorder];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    [self showBorder];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    [self showBorder];
}

- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
    
    [self showBorder];
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
    [self showBorder];
}

//
- (CGPoint)leftTop {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
}

- (void)setLeftTop:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
    
    [self showBorder];
}

//
- (CGPoint)rightTop {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (void)setRightTop:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.x = point.x - frame.size.width;
    frame.origin.y = point.y;
    
    self.frame = frame;
    
    [self showBorder];
}

//
- (CGPoint)leftBottom {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setLeftBottom:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y - frame.size.height;
    self.frame = frame;
    
    [self showBorder];
}

//
- (CGPoint)rightBottom {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setRightBottom:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.x = point.x - frame.size.width;
    frame.origin.y = point.y - frame.size.height;
    self.frame = frame;
    
    [self showBorder];
}

#pragma mark
#pragma mark - mark view's border methods

- (void)markBorder {
    [self markBorderWithColor:nil];
}

- (void)markBorderRecursive {
    [self markBorder];
    
    for (UIView *subView in self.subviews) {
        [subView markBorderRecursive];
    }
}

- (void)markBorderWithColor:(UIColor *)color {
    [self markBorderWithColor:color width:0.0f];
}

- (void)markBorderWithColor:(UIColor *)color width:(CGFloat)width {
    UIColor* borderColor = color == nil ? RandomColor : color;
    CGFloat borderWidth = width < 1.0 ? 1.0 : width;
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)showBorder {
#ifdef AUTO_VIEWBORDER
    [self markBorder];
#endif
}

@end
