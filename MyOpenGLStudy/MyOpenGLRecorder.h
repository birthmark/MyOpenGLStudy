//
//  MyOpenGLRecorder.h
//  oalTouch
//
//  Created by XiaoG on 14-10-25.
//
//

#import <Foundation/Foundation.h>

@protocol MyOpenGLRecorderDelegate <NSObject>

- (void)openGLRecorderDidStart;
- (void)openGLRecorderFinished;
- (void)openGLRecorderFailed;

@end

@interface MyOpenGLRecorder : NSObject

- (id)initWithDelegete:(id<MyOpenGLRecorderDelegate>)delegate;
- (BOOL)startRecord;
- (void)stopRecord;
- (NSString*)targetFilePath;

@end
