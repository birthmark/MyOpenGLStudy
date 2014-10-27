//
//  MainViewController.m
//  MyOpenGLStudy
//
//  Created by XiaoG on 14-7-29.
//  Copyright (c) 2014年 XiaoG. All rights reserved.
//

#import "MainViewController.h"
#import "GLView.h"
#import "MyOpenGLRecorder.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController ()<MyOpenGLRecorderDelegate>

@property (nonatomic, strong) GLView* glView;
@property (nonatomic, strong) MyOpenGLRecorder* openglRecorder;
@property (nonatomic, strong) MPMoviePlayerController *movie;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.glView = [[GLView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.glView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, screenSize.height-40, 160, 40)];
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(160, screenSize.height-40, 160, 40)];
    [button setTitle:@"stop" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(stopClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)startClicked
{
    NSLog(@"startClicked");
    if (self.openglRecorder == nil) {
        self.openglRecorder = [[MyOpenGLRecorder alloc] initWithDelegete:self];
    }
    [self.openglRecorder startRecord];
}

- (void)stopClicked
{
    NSLog(@"stopClicked");
    [self.openglRecorder stopRecord];
}

- (void)openGLRecorderDidStart
{
    
}
- (void)openGLRecorderFinished
{
    NSString* filePath = [self.openglRecorder targetFilePath];
    NSLog(@"target file path : %@", filePath);
//    [self playMovie:filePath];
}

- (void)openGLRecorderFailed
{
    
}

-(void)playMovie:(NSString *)filePath{
    filePath = [[NSBundle mainBundle] pathForResource:@"01.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //视频播放对象
    self.movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.movie.controlStyle = MPMovieControlStyleDefault;
    [self.movie.view setFrame:self.view.bounds];
    self.movie.shouldAutoplay = YES;
    [self.view addSubview:self.movie.view];
    
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.movie];
    [self.movie prepareToPlay];
    [self.movie play];
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
}

@end
