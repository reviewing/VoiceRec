//
//  BDRecognizerViewDelegate.h
//  BDVoiceRecognitionClient
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDRecognizerViewController;

// @protocol - BDRecognizerDialogDelegate
// @brief - 语音弹窗UI的委托接口
@protocol BDRecognizerViewDelegate <NSObject>

// @brief - 语音识别结果返回，搜索和输入模式结果返回的结构不想听
// @param aBDRecognizerView 弹窗UI
// @param aResults 返回结果，搜索结果为数组，输入结果为数组，但元素为字典
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults;

@end

// @protocol - BDRecognizerDialogDelegate
// @brief - 语音输入弹窗按钮的委托接口，开发者不需要关心
@protocol BDRecognizerDialogDelegate <NSObject>

@required
- (void)voiceRecognitionDialogClosed; // 对话框关闭
- (void)voiceRecognitionDialogRetry; // 用户重试
- (void)voiceRecognitionDialogSpeekFinish; // 说完了

@end // BDRecognizerDialogDelegate
