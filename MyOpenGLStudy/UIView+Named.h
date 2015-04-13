//
//  UIView+Named.h
//  NamedViewTest
//
//  Created by XiaoG on 15-4-11.
//  Copyright (c) 2015年 XiaoG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Named)

// 设置view的name
@property (nonatomic) NSString* name;

// 根据名字找到view对象 (包括本身)
- (id)viewWithName:(NSString*)name;

@end
