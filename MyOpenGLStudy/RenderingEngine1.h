//
//  RenderingEngine1.h
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#ifndef __MyOpenGLStudy__RenderingEngine1__
#define __MyOpenGLStudy__RenderingEngine1__

#include <OpenGLES/ES1/gl.h>
#include <OpenglES/ES1/glext.h>
#include "IRenderingEngine.hpp"

class RenderingEngine1 : public IRenderingEngine {
    
public:
    RenderingEngine1();
    void Initialize(int width, int height);
    void Render() const;
    void UpdateAnimation(float timeStep);
    void OnRotate(DeviceOrientation newOrientation);
private:
    float m_scaleRatio;
    float m_currentAngle;
    GLuint m_framebuffer;
    GLuint m_renderbuffer;
};

struct IRenderingEngine* CreateRenderer1();

#endif /* defined(__MyOpenGLStudy__RenderingEngine1__) */
