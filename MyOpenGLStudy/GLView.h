//
//  GLView.h
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>

@interface GLView : UIView

- (void)drawView:(CADisplayLink*)displayLink;
- (void)didRotate:(NSNotification*) notification;

- (void)stop;
@end
