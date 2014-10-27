//
//  RenderingEngine2.h
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-30.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#ifndef __MyOpenGLStudy__RenderingEngine2__
#define __MyOpenGLStudy__RenderingEngine2__

#include <OpenGLES/ES2/gl.h>
#include <OpenglES/ES2/glext.h>
#include "IRenderingEngine.hpp"

class RenderingEngine2 : public IRenderingEngine {
    
public:
    RenderingEngine2();
    void Initialize(int width, int height);
    void Render() const;
    void UpdateAnimation(float timeStep);
    void OnRotate(DeviceOrientation newOrientation);
private:
    GLuint BuildShader(const char* source, GLenum shaderType) const;
    GLuint BuildProgram(const char* vShader, const char* fShader) const;
    void ApplayOrtho(float maxX, float maxY) const;
    void ApplayScale(float scaleRatio) const;
private:
    bool m_zoomin;
    float m_scaleRatio;
    float m_currentAngle;
    
    GLuint m_simpleProgram;
    GLuint m_framebuffer;
    GLuint m_renderbuffer;
};

struct IRenderingEngine* CreateRenderer2();

#endif /* defined(__MyOpenGLStudy__RenderingEngine2__) */
