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

@interface HVRSingleSentenceNoUIViewController ()
{
    BOOL isSpeaking;
}

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIButton *speakButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelRecButton;

- (IBAction)tapToSpeak:(id)sender;
- (IBAction)cancelRec:(id)sender;

@end

@implementation HVRSingleSentenceNoUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSpeaking = NO;
    [self setButtonsBasedOnSpeakingFlag];
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
    [self.resultLabel sizeToFit];
    
    // Resize the frame's width to 280 (320 - margins) see: http://stackoverflow.com/questions/1054558/vertically-align-text-within-a-uilabel
    CGRect myFrame = self.resultLabel.frame;
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 280, myFrame.size.height);
    self.resultLabel.frame = myFrame;
}

- (IBAction)tapToSpeak:(id)sender {
    if (isSpeaking) {
        [[BDVoiceRecognitionClient sharedInstance] speakFinish];
    }
    else {
        // 设置开发者信息
        [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
        
        // 设置语音识别模式，默认是搜索模式, 请在设置服务器地址之前进行设置，避免服务器地址设置出错
        [[BDVoiceRecognitionClient sharedInstance] setCurrentVoiceRecognitionMode:EVoiceRecognitionModeSearch];
        
        // 开始监听音量
        [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
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
    }
    
    isSpeaking = !isSpeaking;
    [self setButtonsBasedOnSpeakingFlag];
}

- (IBAction)cancelRec:(id)sender {
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
}

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    switch (aStatus) {
        case EVoiceRecognitionClientWorkStatusFinish:
        {
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
        default:
        {
            break;
        }
    }
}
@end
