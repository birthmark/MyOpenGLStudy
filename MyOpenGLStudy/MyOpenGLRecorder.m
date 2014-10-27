//
//  MyOpenGLRecorder.m
//  oalTouch
//
//  Created by XiaoG on 14-10-25.
//
//

#import "MyOpenGLRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/ES2/gl.h>

#define kTargetFileName     @"targetgl.mp4"
#define kTargetFilePath     [NSTemporaryDirectory() stringByAppendingPathComponent: kTargetFileName]
#define kFrameRate          30//fps

@interface MyOpenGLRecorder()
{
    bool    isRecording;
    CMTime  frameLength;
    CMTime  currentTime;
    int     currentFrame;
}

@property (nonatomic, assign) id<MyOpenGLRecorderDelegate>          delegate;
@property (nonatomic, strong) NSTimer*                              timer;
@property (nonatomic, strong) AVAssetWriter*                        videoWriter;
@property (nonatomic, strong) AVAssetWriterInput*                   writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor* adaptor;

- (bool)initTargetFile;

@end

@implementation MyOpenGLRecorder

- (id)initWithDelegete:(id<MyOpenGLRecorderDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (BOOL)startRecord
{
    if (isRecording) {
        return YES;
    }
    
    if (![self initTargetFile]) {
        if ([self.delegate respondsToSelector:@selector(openGLRecorderFailed)]) {
            [self.delegate openGLRecorderFailed];
        }
        return NO;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/kFrameRate target:self
                                                selector:@selector(captureScreenVideo) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)stopRecord
{
    isRecording = NO;
    [self.timer invalidate];
    self.timer = nil;
    
    [self.writerInput markAsFinished];
    [self.videoWriter finishWritingWithCompletionHandler:^{
        
        if ([self.delegate respondsToSelector:@selector(openGLRecorderFinished)]) {
            [self.delegate openGLRecorderFinished];
        }
    }];
}

- (NSString*)targetFilePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kTargetFilePath]) {
        return kTargetFilePath;
    }
    return nil;
}

#pragma mark -- private methods

- (bool) initTargetFile {
    
    //initialize global info
    
    CGSize size = [self frameBufferSize];
    frameLength = CMTimeMake(1, kFrameRate);
    currentTime = kCMTimeZero;
    currentFrame = 0;
    
    NSError* error = nil;
    NSString* targetPath = kTargetFilePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
    }
    
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:targetPath]
                                                 fileType:AVFileTypeMPEG4 error:&error];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    self.writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    //    self.writerInput.expectsMediaDataInRealTime = NO;
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],
                                                           kCVPixelBufferPixelFormatTypeKey, nil];
    
    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.writerInput                                                                          sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    [self.videoWriter addInput:self.writerInput];
    [self.videoWriter startWriting];
    [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    return YES;
}

- (void) captureScreenVideo {
    NSLog(@"captureScreenVideo ----- begin");
    if (!self.writerInput.readyForMoreMediaData) {
        NSLog(@"captureScreenVideo writerInput not ready ----- end");
        return;
    }
    
    CGSize size = [self frameBufferSize];
    NSInteger pixelBytesTotal = size.width * size.height * 4;
    NSInteger pixelBytesPerRow = size.width * 4;
    
    GLubyte *pixelsBuffer = (GLubyte *) malloc(pixelBytesTotal);
    if (pixelsBuffer != NULL) {
        glReadPixels(0, 0, size.width, size.height, GL_RGBA, GL_UNSIGNED_BYTE, pixelsBuffer);
        
        // swap red and blue
        for (int i=0; i<pixelBytesTotal; i+=4) {
            GLubyte* red = pixelsBuffer+i;
            GLubyte* blue = pixelsBuffer+i+2;
            GLubyte swapByte = *red;
            *red = *blue;
            *blue = swapByte;
        }
        
        // flip picture
        GLubyte *swapbuffer = (GLubyte *) malloc(pixelBytesTotal);
        if (swapbuffer != NULL) {
            for (int i=0; i<size.height; i++) {
                NSInteger pixelOffsetUp = i*pixelBytesPerRow;
                NSInteger pixelOffsetDown = (size.height-1-i)*pixelBytesPerRow;
                memcpy(swapbuffer+pixelOffsetUp, pixelsBuffer+pixelOffsetDown, pixelBytesPerRow);
            }
            
            memcpy(pixelsBuffer, swapbuffer, pixelBytesTotal);
            free(swapbuffer);
        }
        
        CVPixelBufferRef pixelBufferRef = NULL;
        OSType pixelFormat = kCVPixelFormatType_32BGRA;
        
        CVReturn result = CVPixelBufferCreateWithBytes (kCFAllocatorDefault, size.width, size.height, pixelFormat, pixelsBuffer,
                                                        pixelBytesPerRow, NULL, 0, NULL, &pixelBufferRef);
        free(pixelsBuffer);
        
        if (result == kCVReturnSuccess) {
            if(![self.adaptor appendPixelBuffer:pixelBufferRef withPresentationTime:currentTime]) {
                NSLog(@"appendPixelBuffer failed");
            } else {
                NSLog(@"appendPixelBuffer Succeed: %d", currentFrame);
                currentTime = CMTimeAdd(currentTime, frameLength);
            }
            
            CVPixelBufferRelease(pixelBufferRef);
            currentFrame++;
        }
    }
    NSLog(@"captureScreenVideo ----- end");
}

- (CGSize)frameBufferSize
{
    float scale = [[UIScreen mainScreen] scale];
    float width = [[UIScreen mainScreen] bounds].size.width*scale;
    float height = [[UIScreen mainScreen] bounds].size.height*scale;
    
    return CGSizeMake(width, height);
}

@end
