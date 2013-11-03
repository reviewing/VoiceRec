//
//  HVRSingleSentenceNoUIViewController.m
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-3.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import "HVRSingleSentenceNoUIViewController.h"

#define API_KEY @"LjfQaGXUdnHHGZFBReQBtVGs"
#define SECRET_KEY @"awDw9VbFAAbFFKWDhcthn7MrZv44FQI0"

#define VOLUME_UPDATE_INTERVAL 0.1

@interface HVRSingleSentenceNoUIViewController ()
{
    BOOL isSpeaking;
    NSTimer *volumeUpdateTimer;
}

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIButton *speakButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelRecButton;
@property (strong, nonatomic) IBOutlet UIProgressView *volumeBar;

- (IBAction)tapToSpeak:(id)sender;
- (IBAction)cancelRec:(id)sender;

@end

@implementation HVRSingleSentenceNoUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSpeaking = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setResultText:@"请点击说话按钮开始识别"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setButtonsBasedOnSpeakingFlag
{
    NSString *speakButtonTitle = @"";
    if (isSpeaking) {
        speakButtonTitle = NSLocalizedString(@"FinishSpeaking", nil);
    }
    else {
        speakButtonTitle = NSLocalizedString(@"Speak", nil);
    }
    
    [self.speakButton setTitle:speakButtonTitle forState:UIControlStateNormal];
    self.cancelRecButton.enabled = isSpeaking;
}

- (void)setResultText:(NSString *)text
{
    self.resultLabel.text = text;
}

- (IBAction)tapToSpeak:(id)sender {
    if (isSpeaking) {
        [[BDVoiceRecognitionClient sharedInstance] speakFinish];
        [self speakEnded];
    }
    else {
        // 设置开发者信息
        [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
        
        // 设置语音识别模式，默认是搜索模式, 请在设置服务器地址之前进行设置，避免服务器地址设置出错
        [[BDVoiceRecognitionClient sharedInstance] setCurrentVoiceRecognitionMode:EVoiceRecognitionModeSearch];
        
        // 开始监听音量
        [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        volumeUpdateTimer = [[NSTimer alloc] initWithFireDate:[[NSDate alloc] initWithTimeIntervalSinceNow:VOLUME_UPDATE_INTERVAL] interval:VOLUME_UPDATE_INTERVAL target:self selector:@selector(updateVolumeBar:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:volumeUpdateTimer forMode:NSDefaultRunLoopMode];
        
        // 开始说话提示音
        [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:YES];
        // 结束说话提示音
        [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:YES];
        
        int startStatus = -1;
        startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
        // 启动失败，报告错误
        if (startStatus != EVoiceRecognitionStartWorking)
        {
            [self setResultText:[NSString stringWithFormat:@"启动失败，错误码：%d", startStatus]];
            return;
        }
        
        [self setResultText:@"初始化，请稍后..."];
    }
    
    isSpeaking = !isSpeaking;
    [self setButtonsBasedOnSpeakingFlag];
}

- (IBAction)cancelRec:(id)sender {
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    [self speakEnded];
}

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    switch (aStatus) {
        case EVoiceRecognitionClientWorkStatusFinish:
        {
            [self speakEnded];
            
            self.resultLabel.text = nil;
            
            // 搜索模式下的结果为数组，示例为
            // ["公园", "公元"]
            NSMutableArray *audioResultData = (NSMutableArray *)aObj;
            NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
            
            for (int i=0; i < [audioResultData count]; i++)
            {
                [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
            }
            
            [self setResultText:tmpString];
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng:
        {
            [self setResultText:@"请说话"];
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd:
        {
            [self setResultText:@"识别中，请稍候..."];
            [self stopVolumeUpdate];
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {
            [self setResultText:@"已取消，点击说话按钮开始识别"];
            break;
        }
        default:
        {
            break;
        }
    }
}

// 网络连接指示器
- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
    }
}

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    [self setResultText:[NSString stringWithFormat:@"识别出错，错误码%d", aSubStatus]];
    [self speakEnded];
}

- (void)speakEnded
{
    isSpeaking = NO;
    [self setButtonsBasedOnSpeakingFlag];
    [self stopVolumeUpdate];
}

- (void)updateVolumeBar:(id)sender
{
    float volume = (float)[[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter]/60;
    if (volume > 1.0) {
        volume = 1.0;
    }
    [self.volumeBar setProgress:(float)volume animated:NO];
}

- (void)stopVolumeUpdate
{
    [volumeUpdateTimer invalidate];
    [self.volumeBar setProgress:0.01f animated:YES];
    // 停止监听音量
    [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
}

@end
