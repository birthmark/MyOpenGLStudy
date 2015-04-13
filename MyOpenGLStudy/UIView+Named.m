//
//  UIView+Named.m
//  NamedViewTest
//
//  Created by XiaoG on 15-4-11.
//  Copyright (c) 2015年 XiaoG. All rights reserved.
//

#import "UIView+Named.h"
#import <objc/runtime.h>

#define kViewNameKey @"CustomViewName"

@implementation UIView (Named)

- (void)setName:(NSString *)name
{
    if (name.length <= 0) {
        return;
    }
    
    NSUInteger tag = [name hash];
    [self setTag:tag];
    objc_setAssociatedObject(self, kViewNameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString*)name
{
    id object = objc_getAssociatedObject(self, kViewNameKey);
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    return nil;
}

- (id)viewWithName:(NSString*)name
{
    if (name.length <= 0) {
        return nil;
    }
    
    UIView* view = [self viewWithTag:[name hash]];
    return view;
}

@end
