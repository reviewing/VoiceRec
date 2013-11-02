//
//  BDRecognizerViewParamsObject.h
//  BDVoiceRecognitionClient
//
//  Created by Baidu on 13-9-25.
//  Copyright (c) 2013年 Baidu, Inc. All rights reserved.
//

// 头文件
#import <Foundation/Foundation.h>

// 枚举 - 弹窗UI的识别模式
typedef enum
{
    BDRecognizerRecognitionModeSearch     = 0,   // 搜索模式
    BDRecognizerRecognitionModeInput,               // 输入模式
} TBDRecognizerRecognitionMode;

// 枚举 - 弹窗中连续上屏效果开关
typedef enum
{
    BDRecognizerResultShowModeWholeShow     = 0,  // 无连续上屏效果
    BDRecognizerResultShowModeContinuousShow,     // 连续上屏效果支持
} TBDRecognizerResultShowMode;

// 枚举 - 播放提示音开关
typedef enum
{
    EBDRecognizerPlayTonesRecordForbidden = 0,                  // 不开启提示音
    EBDRecognizerPlayTonesRecordPlay = 1,                          //  提示音开启
} TBDRecognizerPlayTones;

// @class - BDRecognizerViewParamsObject
// @brief - 语音识别弹窗参数配置类
@interface BDRecognizerViewParamsObject : NSObject

@property (nonatomic, copy) NSString *productID;  // 向百度语音技术部申请
@property (nonatomic, copy) NSString *apiKey;  // 开发者apiKey，在百度开放平台申请
@property (nonatomic, copy) NSString *secretKey;  // 开发者secretKey，在百度开放平
@property (nonatomic) TBDRecognizerRecognitionMode recognitionMode;  // 识别模式
@property (nonatomic) TBDRecognizerResultShowMode resultShowMode;   // 显示效果
@property (nonatomic) TBDRecognizerPlayTones recordPlayTones;   // 提示音开关

@end // BDRecognizerViewParamsObject
