//
//  HVRSingleSentenceNoUIViewController.m
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-3.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import "HVRSingleSentenceNoUIViewController.h"

@interface HVRSingleSentenceNoUIViewController ()
{
    BOOL isSpeaking;
}

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIButton *speakButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelRecButton;

- (IBAction)tapToSpeak:(id)sender;
- (IBAction)cancelRec:(id)sender;

@property (strong, nonatomic) BDVoiceRecognitionClient *voiceRecClient;

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

- (IBAction)tapToSpeak:(id)sender {
    if (isSpeaking) {
        
    }
    
    isSpeaking = !isSpeaking;
    [self setButtonsBasedOnSpeakingFlag];
}

- (IBAction)cancelRec:(id)sender {
}

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    
}
@end
