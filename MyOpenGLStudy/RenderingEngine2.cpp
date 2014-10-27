//
//  RenderingEngine2.cpp
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-30.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#include "RenderingEngine2.h"
#include <iostream>
#include <cmath>

#define STRINGIFY(A) #A

#include "Simple.vert"
#include "Simple.frag"


struct Vertex {
    float Position[2];
    float Color[4];
};

const Vertex Vertexs[] = {
    {{-0.5, -0.866},{1, 1, 0.5, 1}},
    {{0.5, -0.866},{1, 1, 0.5, 1}},
    {{0, 1},{1, 1, 0.5, 1}},
    {{-0.5, -0.866},{0.5, 0.5, 0.5, 1}},
    {{0.5, -0.866},{0.5, 0.5, 0.5, 1}},
    {{0, -0.4},{0.5, 0.5, 0.5, 1}},
};

RenderingEngine2::RenderingEngine2()
{
    glGenRenderbuffers(1, &m_renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, m_renderbuffer);
}

void RenderingEngine2::Initialize(int width, int height)
{
    m_zoomin = true;
    m_scaleRatio = 0.5;
    glGenFramebuffers(1, &m_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, m_framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_renderbuffer);
    glViewport(0, 0, width*2, height*2);
    m_simpleProgram = BuildProgram(SimpleVertexShader, SimpleFragmentShader);
    glUseProgram(m_simpleProgram);
    ApplayScale(m_scaleRatio);
    ApplayOrtho(2, 3);
    OnRotate(DeviceOrientationPortrait);
    
}
void RenderingEngine2::Render() const
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    ApplayScale(m_scaleRatio);
    
    GLuint positionSlot = glGetAttribLocation(m_simpleProgram, "Position");
    GLuint colorSlot = glGetAttribLocation(m_simpleProgram, "SourceColor");
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(colorSlot);
    
    GLsizei stride = sizeof(Vertex);
    const GLvoid* pCoords = &Vertexs[0].Position[0];
    const GLvoid* pColors = &Vertexs[0].Color[0];
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, stride, pCoords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, stride, pColors);
    GLsizei vertexCount = sizeof(Vertexs) / sizeof(Vertex);
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
}
void RenderingEngine2::UpdateAnimation(float timeStep)
{
    float step = 0.02;
    if (m_zoomin) {
        m_scaleRatio += step;
    } else {
        m_scaleRatio -= step;
    }
    
    if (m_scaleRatio > 2.5) {
        m_zoomin = false;
    }
    
    if (m_scaleRatio < 0.5) {
        m_zoomin = true;
    }
}
void RenderingEngine2::OnRotate(DeviceOrientation newOrientation)
{
    
}

GLuint RenderingEngine2::BuildShader(const char* source, GLenum shaderType) const
{
    GLuint shanderHandle = glCreateShader(shaderType);
    glShaderSource(shanderHandle, 1, &source, 0);
    glCompileShader(shanderHandle);
    GLint compileSuccess;
    glGetShaderiv(shanderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shanderHandle, sizeof(message), 0, &message[0]);
        std::cout<<message;
        exit(1);
    }
    return shanderHandle;
}

GLuint RenderingEngine2::BuildProgram(const char* vShader, const char* fShader) const
{
    GLuint vertexShader = BuildShader(vShader, GL_VERTEX_SHADER);
    GLuint fragmentShader = BuildShader(fShader, GL_FRAGMENT_SHADER);
    GLuint progmentHandle = glCreateProgram();
    glAttachShader(progmentHandle, vertexShader);
    glAttachShader(progmentHandle, fragmentShader);
    glLinkProgram(progmentHandle);
    GLint linkSuccess;
    glGetProgramiv(progmentHandle, GL_LINK_STATUS, &linkSuccess);
    
    if (linkSuccess == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(progmentHandle, sizeof(message), 0, &message[0]);
        std::cout<<message;
        exit(1);
    }
    
    return progmentHandle;
}

void RenderingEngine2::ApplayOrtho(float maxX, float maxY) const
{
    float a = 1.0 / maxX;
    float b = 1.0 / maxY;
    float ortho[16] = {
        a, 0, 0, 0,
        0, b, 0, 0,
        0,0,-1,0,
        0,0,0,1
    };
    
    GLint projectionUniform = glGetUniformLocation(m_simpleProgram, "Projection");
    glUniformMatrix4fv(projectionUniform, 1, 0, &ortho[0]);
    
}

void RenderingEngine2::ApplayScale(float scaleRatio) const
{
    float scale[16] = {
      scaleRatio, 0, 0, 0,
        0, scaleRatio, 0, 0,
        0, 0, scaleRatio, 0,
        0, 0, 0, 1
    };
    
    GLint modelviewUniform = glGetUniformLocation(m_simpleProgram, "Modelview");
    glUniformMatrix4fv(modelviewUniform, 1, 0, &scale[0]);
}

struct IRenderingEngine* CreateRenderer2()
{
    return new RenderingEngine2();
}