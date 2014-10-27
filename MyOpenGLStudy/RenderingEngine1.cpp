//
//  RenderingEngine1.cpp
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#include "RenderingEngine1.h"
#include "Vector.hpp"

struct Vertex {
    vec3 Position;
    vec4 Color;
};

const Vertex Vertexs[] = {
//    {{-0.5, -0.866},{1, 1, 0.5, 1}},
//    {{0.5, -0.866},{1, 1, 0.5, 1}},
//    {{0, 1},{1, 1, 0.5, 1}},
//    {{-0.5, -0.866},{0.5, 0.5, 0.5, 1}},
//    {{0.5, -0.866},{0.5, 0.5, 0.5, 1}},
//    {{0, -0.4},{0.5, 0.5, 0.5, 1}},
};

RenderingEngine1::RenderingEngine1()
{
    m_scaleRatio = 0.5;
    glGenRenderbuffersOES(1, &m_renderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderbuffer);
}

void RenderingEngine1::Initialize(int width, int height)
{
    glGenFramebuffersOES(1, &m_framebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_framebuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_renderbuffer);
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    const float ratio = (float)height / width;
    glOrthof(-1, 1, -ratio, ratio, -1, 1);
    glMatrixMode(GL_MODELVIEW);
}

void RenderingEngine1::Render() const
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glPushMatrix();
    glScalef(m_scaleRatio, m_scaleRatio, 1.0);
    glRotatef(m_currentAngle/180.0*3.1415926, 0, 0, 1);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
//    glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &Vertexs[0].Position[0]);
//    glColorPointer(4, GL_FLOAT, sizeof(Vertex), &Vertexs[0].Color[0]);
    GLsizei vertexCount = sizeof(Vertexs) / sizeof(Vertex);
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glPopMatrix();
}

void RenderingEngine1::UpdateAnimation(float timeStep)
{
    m_scaleRatio += 0.01;
    if (m_scaleRatio >= 2.5) {
        m_scaleRatio = 0.5;
    }
}

void RenderingEngine1::OnRotate(DeviceOrientation newOrientation)
{
    float angle = 0;
    switch (newOrientation) {
        case DeviceOrientationLandscapeLeft:
            angle = 270;
            break;
        case DeviceOrientationPortraitUpsideDown:
            angle = 180;
            break;
        case DeviceOrientationLandscapeRight:
            angle = 90;
            break;
            
        default:
            break;
    }
    
    m_currentAngle = angle;
}

struct IRenderingEngine* CreateRenderer1()
{
    return new RenderingEngine1();
}
