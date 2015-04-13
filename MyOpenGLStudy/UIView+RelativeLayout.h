//
//  UIView+RelativeLayout.h
//  NamedViewTest
//
//  Created by XiaoG on 15-4-11.
//  Copyright (c) 2015年 XiaoG. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
//#define AUTO_VIEWBORDER //自动显示view的border开关
#endif

@interface UIView (RelativeLayout)

//  将View的左边移动到指定位置
@property (nonatomic) CGFloat left;

//  将View的顶端移动到指定位置
@property (nonatomic) CGFloat top;

//  将View的右边移动到指定位置
@property (nonatomic) CGFloat right;

//  将View的底端移动到指定位置
@property (nonatomic) CGFloat bottom;

//  更改View的宽度
@property (nonatomic) CGFloat width;

//  更改View的高度
@property (nonatomic) CGFloat height;

//  更改View的位置
@property (nonatomic) CGPoint origin;

//  更改View的尺寸
@property (nonatomic) CGSize size;

//  更改View中心点的位置x
@property (nonatomic) CGFloat centerX;

//  更改View中心点的位置x
@property (nonatomic) CGFloat centerY;

//  更改View左上角点的位置
@property (nonatomic) CGPoint leftTop;

//  更改View左下角点的位置
@property (nonatomic) CGPoint rightTop;

//  更改View右上角点的位置
@property (nonatomic) CGPoint leftBottom;

//  更改View右下角点的位置
@property (nonatomic) CGPoint rightBottom;

// 辅助调试函数，标示出子view的边框
- (void)markBorder;            //随机颜色
- (void)markBorderRecursive;   //随机颜色，递归标示子view
- (void)markBorderWithColor:(UIColor *)color;
- (void)markBorderWithColor:(UIColor *)color width:(CGFloat)width;


@end
