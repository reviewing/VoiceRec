//
//  HVRMultiSentenceController.m
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-2.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import "HVRMultiSentenceController.h"
#import "BDRecognizerViewController.h"
#import "BDTheme.h"

#define API_KEY @"LjfQaGXUdnHHGZFBReQBtVGs"
#define SECRET_KEY @"awDw9VbFAAbFFKWDhcthn7MrZv44FQI0"

@interface HVRMultiSentenceController ()
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@end

@implementation HVRMultiSentenceController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setText:@"请点击说话按钮开始识别"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setText:(NSString *)text
{
    self.resultLabel.text = text;
    [self.resultLabel sizeToFit];
    
    // Resize the frame's width to 280 (320 - margins) see: http://stackoverflow.com/questions/1054558/vertically-align-text-within-a-uilabel
    CGRect myFrame = self.resultLabel.frame;
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 280, myFrame.size.height);
    self.resultLabel.frame = myFrame;
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
    paramsObject.recognitionMode = BDRecognizerRecognitionModeInput;
    
    // 设置显示效果，是否开启连续上屏
    paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    
    // 设置提示音开关，是否打开，默认打开
    paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    
    [self.recognizerViewController startWithParams:paramsObject];

}

#pragma mark - BDRecognizerViewDelegate

- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    self.resultLabel.text = nil;
    
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
    
    [self setText:tmpString];
}
@end
