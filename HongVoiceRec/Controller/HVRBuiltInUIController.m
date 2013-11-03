//
//  HVRBuiltInUIController.m
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-2.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import "HVRBuiltInUIController.h"
#import "BDRecognizerViewController.h"
#import "BDTheme.h"

#define API_KEY @"LjfQaGXUdnHHGZFBReQBtVGs"
#define SECRET_KEY @"awDw9VbFAAbFFKWDhcthn7MrZv44FQI0"

@interface HVRBuiltInUIController ()
{
    int voiceRecMode;
}

@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;

- (IBAction)tapToSpeak:(id)sender;
- (IBAction)switchMode:(UISwitch *)sender;
@end

@implementation HVRBuiltInUIController

- (void)viewDidLoad
{
    [super viewDidLoad];
    voiceRecMode = EVoiceRecognitionModeSearch;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setResultText:NSLocalizedString(@"TapSpeakButtonToRec", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setResultText:(NSString *)text
{
    self.resultTextView.text = text;
}

- (IBAction)tapToSpeak:(id)sender {
    // 创建识别控件
    self.recognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme:[BDTheme defaultTheme]];
    self.recognizerViewController.delegate = self;
    
    // 设置识别参数
    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    
    // 开发者信息
    paramsObject.apiKey = API_KEY;
    paramsObject.secretKey = SECRET_KEY;
    
    // 设置识别模式
    paramsObject.recognitionMode = voiceRecMode;
    
    // 设置显示效果，是否开启连续上屏
    paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    
    // 设置提示音开关，是否打开，默认打开
    paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    
    [self.recognizerViewController startWithParams:paramsObject];
}

- (IBAction)switchMode:(UISwitch *)sender {
    if (sender.on) {
        voiceRecMode = EVoiceRecognitionModeSearch;
    }
    else
    {
        voiceRecMode = EVoiceRecognitionModeInput;
    }
}

#pragma mark - BDRecognizerViewDelegate

- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    self.resultTextView.text = nil;
    if (voiceRecMode == EVoiceRecognitionModeSearch) {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i=0; i < [audioResultData count]; i++)
        {
            [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
        }
        
        [self setResultText:tmpString];
    }
    else
    {
        self.resultTextView.text = nil;
        
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        for (NSArray *result in aResults)
        {
            NSDictionary *dic = [result objectAtIndex:0];
            NSString *candidateWord = [[dic allKeys] objectAtIndex:0];
            [tmpString appendString:candidateWord];
        }
        
        [self setResultText:tmpString];
    }
}
@end
