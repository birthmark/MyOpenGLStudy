//
//  IRenderingEngine.hpp
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#ifndef MyOpenGLStudy_IRenderingEngine_hpp
#define MyOpenGLStudy_IRenderingEngine_hpp

enum DeviceOrientation {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationPortraitUpsideDown,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight,
    DeviceOrientationFaceUp,
    DeviceOrientationFaceDown,
};

struct IRenderingEngine {
    virtual void Initialize(int width, int height) = 0;
    virtual void Render() const = 0;
    virtual void UpdateAnimation(float timeStep) = 0;
    virtual void OnRotate(DeviceOrientation newOrientation) = 0;
    virtual ~IRenderingEngine(){}
};

#endif
