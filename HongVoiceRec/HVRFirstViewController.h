//
//  HVRFirstViewController.h
//  HongVoiceRec
//
//  Created by  段弘 on 13-11-2.
//  Copyright (c) 2013年 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRecognizerViewDelegate.h"

@interface HVRFirstViewController : UIViewController<BDRecognizerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)tabToSpeak:(id)sender;

@end
