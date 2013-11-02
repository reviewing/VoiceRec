//
//  HVRMultiSentenceController.h
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-2.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRecognizerViewDelegate.h"

@interface HVRMultiSentenceController : UIViewController<BDRecognizerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)tapToSpeak:(id)sender;

@end
