//
//  BDVoiceRecognitionClient.h
//  BDVoiceRecognitionClient
//
//  Created by liujunqi on 12-4-1.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 枚举 - 语音识别状态
enum TVoiceRecognitionClientWorkStatus
{
    EVoiceRecognitionClientWorkStatusNone = 0,               //空闲
    EVoiceRecognitionClientWorkPlayStartTone,                //播放开始提示音
    EVoiceRecognitionClientWorkPlayStartToneFinish,          //播放开始提示音完成
    EVoiceRecognitionClientWorkStatusStartWorkIng,           //识别工作开始，开始采集及处理数据
    EVoiceRecognitionClientWorkStatusStart,                  //检测到用户开始说话
    EVoiceRecognitionClientWorkStatusSentenceEnd,       // 输入模式下检测到语音说话完成
    EVoiceRecognitionClientWorkStatusEnd,                    //本地声音采集结束结束，等待识别结果返回并结束录音
    EVoiceRecognitionClientWorkPlayEndTone,                  //播放开始提示音
    EVoiceRecognitionClientWorkPlayEndToneFinish,            //播放开始提示音完成
    
    EVoiceRecognitionClientWorkStatusFlushData,    // 连续上屏
    EVoiceRecognitionClientWorkStatusReceiveData,  // 输入模式下有识别结果返回
    EVoiceRecognitionClientWorkStatusFinish,                 //语音识别功能完成，服务器返回正确结果
    
    EVoiceRecognitionClientWorkStatusCancel,                //用户取消
    EVoiceRecognitionClientWorkStatusError                  //发生错误，详情见VoiceRecognitionClientErrorStatus接口通知
};

// 枚举 - 网络工作状态
enum TVoiceRecognitionClientNetWorkStatus
{
    EVoiceRecognitionClientNetWorkStatusStart = 1000,        //网络开始工作
    EVoiceRecognitionClientNetWorkStatusEnd,                 //网络工作完成
};

// 枚举 - 语音识别错误通知状态分类
enum TVoiceRecognitionClientErrorStatusClass
{    
    EVoiceRecognitionClientErrorStatusClassVDP = 1100,        //语音数据处理过程出错
    EVoiceRecognitionClientErrorStatusClassRecord = 1200,     //录音出错
    EVoiceRecognitionClientErrorStatusClassLocalNet = 1300,   //本地网络联接出错
    EVoiceRecognitionClientErrorStatusClassServerNet = 3000,  //服务器返回网络错误
};

// 枚举 - 语音识别错误通知状态
enum TVoiceRecognitionClientErrorStatus
{    
    //以下状态为错误通知，出现错语后，会自动结束本次识别
    EVoiceRecognitionClientErrorStatusUnKnow = EVoiceRecognitionClientErrorStatusClassVDP+1,          //未知错误(异常)
    EVoiceRecognitionClientErrorStatusNoSpeech,               //用户未说话
    EVoiceRecognitionClientErrorStatusShort,                  //用户说话声音太短
    EVoiceRecognitionClientErrorStatusException,              //语音前端库检测异常
    
    
    EVoiceRecognitionClientErrorStatusChangeNotAvailable = EVoiceRecognitionClientErrorStatusClassRecord+1,     //录音设备不可用
    EVoiceRecognitionClientErrorStatusIntrerruption,          //录音中断

    
    EVoiceRecognitionClientErrorNetWorkStatusUnusable = EVoiceRecognitionClientErrorStatusClassLocalNet+1,            //网络不可用
    EVoiceRecognitionClientErrorNetWorkStatusError,               //网络发生错误
    EVoiceRecognitionClientErrorNetWorkStatusTimeOut,             //网络本次请求超时
    EVoiceRecognitionClientErrorNetWorkStatusParseError,          //解析失败
    
    
    //服务器返回错误
    EVoiceRecognitionClientErrorNetWorkStatusServerParamError = EVoiceRecognitionClientErrorStatusClassServerNet+1,       //协议参数错误
    EVoiceRecognitionClientErrorNetWorkStatusServerRecognError,      //识别过程出错
    EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult,     //没有找到匹配结果
    EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError,    //AppnameUnkown错误
    EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem,    //声音不符合识别要求
    EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError,      //未知错误
};

// 枚举 - 语音识别模式
enum TVoiceRecognitionMode
{
    EVoiceRecognitionModeSearch = 0,     // 语音搜索
    EVoiceRecognitionModeInput             // 语音输入
};

// 枚举 - 播放录音提示音
enum TVoiceRecognitionPlayTones
{
    EVoiceRecognitionPlayTonesRecStart = 1,                 //录音开始提示音
    EVoiceRecognitionPlayTonesRecEnd = 2,                   //录音结束提示音
    //所有日志打开
    EVoiceRecognitionPlayTonesAll = (EVoiceRecognitionPlayTonesRecStart | EVoiceRecognitionPlayTonesRecEnd )
};

// 枚举 - 调用启动语音识别，返回结果                               startVoiceRecognition
enum TVoiceRecognitionStartWorkResult
{
    EVoiceRecognitionStartWorking = 2000,                    //开始工作
    EVoiceRecognitionStartWorkNOMicrophonePermission,        //没有麦克风权限
    EVoiceRecognitionStartWorkNoAPIKEY,                      //没有设定应用API KEY
    EVoiceRecognitionStartWorkGetAccessTokenFailed,            //获取accessToken失败
    EVoiceRecognitionStartWorkNetUnusable,                   //当前网络不可用
    EVoiceRecognitionStartWorkDelegateInvaild,               //没有实现MVoiceRecognitionClientDelegate中VoiceRecognitionClientWorkStatus方法,或传入的对像为空
    EVoiceRecognitionStartWorkRecorderUnusable,              //录音设备不可用
    EVoiceRecognitionStartWorkPreModelError,                 //启动预处理模块出错
};

// 枚举 - 设置Property字段，返回结果                               setStatisiticInfo
enum TSetPropertyInfoResult
{
    ESetPropertyInfoSuccessFul = 0,                       //设置成功
    ESetPropertyInfoNonPositiveNumber,                   //失败，设置数据只能是正数, >0
    ESetPropertyInfoWorkBusy,                              //失败，系统处理忙时状态
};

// @protocol - MVoiceRecognitionClientDelegate
// @brief - 语音识别工作状态通知
@protocol MVoiceRecognitionClientDelegate<NSObject>
@optional

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj;              //aStatus TVoiceRecognitionClientWorkStatus

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus;//aStatus TVoiceRecognitionClientErrorStatusClass;aSubStatus TVoiceRecognitionClientErrorStatus

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus;                         //aStatus TVoiceRecognitionClientNetWorkStatus

@end // MVoiceRecognitionClientDelegate

@interface BDVoiceRecognitionClient : NSObject
//－－－－－－－－－－－－－－－－－－－类方法－－－－－－－－－－－－－－－－－－－－－－－－
// 创建语音识别客户对像，该对像是个单例
+ (BDVoiceRecognitionClient *)sharedInstance;

// 释放语音识别客户端对像
+ (void)releaseInstance;


//－－－－－－－－－－－－－－－－－－－识别方法－－－－－－－－－－－－－－－－－－－－－－－
// 判断是否可以录音
- (BOOL)isCanRecorder; 

// 开始语音识别，需要实现MVoiceRecognitionClientDelegate代理方法，并传入实现对像监听事件
// 返回值参考 TVoiceRecognitionStartWorkResult
- (int)startVoiceRecognition:(id<MVoiceRecognitionClientDelegate>)aDelegate; 

// 说完了，用户主动完成录音时调用
- (void)speakFinish;

// 结束本次语音识别
- (void)stopVoiceRecognition; 

// 得到当前识别模式
- (int)getCurrentVoiceRecognitionMode;

// 设置当前识别模式
- (BOOL)setCurrentVoiceRecognitionMode:(int)aMode;

//－－－－－－－－－－－－－－－－－－－提示音－－－－－－－－－－－－－－－－－－－－－－－
// 播放提示音，默认为播放,录音开始，录音结束提示音
// BDVoiceRecognitionClientResources/Tone
// record_start.caf   录音开始声音文件
// record_end.caf     录音结束声音文件
// 声音资源需要加到项目工程里，用户可替换资源文件，文件名不可以变，建音提示音不宜过长，0。5秒左右。
// aTone 取值参考 TVoiceRecognitionPlayTones，如没有找到文件，则返回ＮＯ
- (BOOL)setPlayTone:(int)aTone isPlay:(BOOL)aIsPlay;


//－－－－－－－－－－－－－－－－－－－音源信息－－－－－－－－－－－－－－－－－－－－－－－
// 监听当前音量级别，如果在工作状态设定，返回结果为ＮＯ ，且本次调用无效
- (BOOL)listenCurrentDBLevelMeter;

// 获取当前音量级别，取值需要考虑全平台
- (int)getCurrentDBLevelMeter;

// 取消监听音量级别
- (void)cancelListenCurrentDBLevelMeter;


//－－－－－－－－－－－－－－－－－－－产品相关－－－－－－－－－－－－－－－－－－－－－－－
//设定产品ＩＤ，此ＩＤ需要从服务端申请，如果不设定，调用 startVoiceRecognition函数时，会返回错误，如果在工作状态设定，返回结果为ＮＯ ，且本次调用无效
- (BOOL)setProductId:(NSString*)aProductId;

//－－－－－－－－－－－－－－－－－－－开发者身份验证－－－－－－－－－－－－－－－－－－－－
//设置开发者申请的api key和secret key
- (void)setApiKey:(NSString*)apiKey withSecretKey:(NSString*)secretKey;

//- - - - - - - - - - - - - - - -其他参数设置- - - - - - - - - - - - - - - - - -
//设置params，每次识别开始前都需要进行设置，目前支持如下参数：
//"txt" : 上传文本，如果设置了该字段，将略过语音输入和识别阶段
//"param" : 其他参数
- (void)setParamForKey:(NSString*)key withValue:(NSString*)value;

// 产品扩展字段，存放到请求的body中，只能是大于0的整型，返回结果参考TSetPropertyInfoResult
- (int)setPropertyInfo:(int)aPropertyInfo;

//－－－－－－－－－－－－－－－－－－－版本号－－－－－－－－－－－－－－－－－－－－－－－－
// 获取版本号
- (NSString*)libVer;

@end
