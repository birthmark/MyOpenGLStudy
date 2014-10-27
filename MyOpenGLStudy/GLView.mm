//
//  GLView.m
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/ES2/gl.h>
#import "IRenderingEngine.hpp"
#import "RenderingEngine1.h"
#import "RenderingEngine2.h"

const BOOL ForceES1 = NO;

@interface GLView() {
    EAGLContext* m_context;
    struct IRenderingEngine* m_renderingEngine;
    float m_timestamp;
    CADisplayLink* displayLink;
}

@end

@implementation GLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*)super.layer;
        eaglLayer.opaque = YES;
        eaglLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc] initWithAPI:api];
        
        if (!m_context || ForceES1) {
            api = kEAGLRenderingAPIOpenGLES1;
            m_context = [[EAGLContext alloc] initWithAPI:api];
        }
        
        if (!m_context || ![EAGLContext setCurrentContext:m_context]) {
            return nil;
        }
        
        if (api == kEAGLRenderingAPIOpenGLES1) {
            m_renderingEngine = CreateRenderer1();
        } else {
            m_renderingEngine = CreateRenderer2();
        }
        [m_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        m_renderingEngine->Initialize(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        [self drawView:nil];
        m_timestamp = CACurrentMediaTime();
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)didRotate:(NSNotification*) notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    m_renderingEngine->OnRotate((DeviceOrientation)orientation);
    [self drawView:nil];
}

- (void)drawView:(CADisplayLink*)dispLink {
    if (displayLink != nil) {
        float elapseSeconds = dispLink.timestamp - m_timestamp;
        m_timestamp = dispLink.timestamp;
        m_renderingEngine->UpdateAnimation(elapseSeconds);
    }
    
    m_renderingEngine->Render();
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)stop
{
    [displayLink invalidate];
}

- (void)dealloc
{
    delete m_renderingEngine;
}

@end
