//
//  Lotuseed.h
//  Lotuseed
//
//  Created by beyond on 12-5-22.
//  Copyright (c) 2012年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Lotuseed : NSObject <UIAlertViewDelegate> {
    
}

#pragma mark basics

/**
 * 开启Lotuseed统计功能
 */
+ (void)initWithCustomData256:(NSString *)data; //可选，在startWithAppKey前调用，最长256字节。

+ (void)startWithAppKey:(NSString *)appKey;

+ (void)startWithAppKey:(NSString *)appKey channelID:(NSString *)cid;

+ (void)startWithAppKey:(NSString *)appKey channelID:(NSString *)cid appleID:(NSString*)aid;

+ (void)startWithAppKey:(NSString *)appKey channelID:(NSString *)cid appleID:(NSString*)aid location:(BOOL)onoff;

/**
 * 是否设置Lotuseed SDK为DEBUG模式
 * 默认为NO
 */
+ (void)setDebugMode:(BOOL)mode;
+ (BOOL)debugMode;

/**
 * 是否通过Lotuseed捕捉和提交错误日志
 * 默认为YES
 */
+ (void)setCrashReportEnabled:(BOOL)value;

/**
 * 设置Session非活动时长，单位：秒
 */
+ (void)setSessionContinueSeconds:(int)seconds;


/**
 * 跟踪记录PageView访问时长
 */
+ (void)onPageViewBegin:(NSString *)pageName;
+ (void)onPageViewEnd:(NSString *)pageName;


#pragma mark custom event

/**
 * 统计事件累计次数
 */
+ (void)onEvent:(NSString *)eventID;
+ (void)onEvent:(NSString *)eventID withCount:(long)count;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label withCount:(long)count;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic withCount:(long)count;

+ (void)onEvent:(NSString *)eventID postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID withCount:(long)count postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label withCount:(long)count postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic withCount:(long)count postData:(BOOL)immediately;

/**
 * 统计事件累计时长
 */
+ (void)onEvent:(NSString *)eventID withDuration:(long)duration;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label withDuration:(long)duration;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic withDuration:(long)duration;

+ (void)onEvent:(NSString *)eventID withDuration:(long)duration postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID label:(NSString *)label withDuration:(long)duration postData:(BOOL)immediately;
+ (void)onEvent:(NSString *)eventID attributes:(NSDictionary *)dic withDuration:(long)duration postData:(BOOL)immediately;

#pragma mark special event

/**
 * 记录特殊事件
 */
// 性别
typedef enum {
    kGenderUnknown = 0,     // 未知
    kGenderMale,            // 男
    kGenderFemale           // 女
} LSGAGender;

+ (void)onRegistration:(NSString*)accountId;
+ (void)onRegistration:(NSString*)accountId gender:(LSGAGender)gender age:(int)age;

+ (void)onLogin:(NSString*)accountId;
+ (void)onLogout:(NSString*)accountId;

+ (void)onOrder:(NSString*)accountId orderId:(NSString*)orderId amount:(double)number;

#pragma mark log report

/**
 * 记录自定义日志
 */
+ (void)onCustomLog:(NSString *)logmsg;

#pragma mark check update

/**
 * 应用版本更新
 */
+ (void)checkUpdate;
+ (void)checkUpdate:(NSString*)title updateButtonCaption:(NSString*)update cancelButtonCaption:(NSString*)cancel;
+ (void)checkUpdateWithDelegate:(id)delegate didFinishSelector:(SEL)selector;
+ (BOOL)isUpdating;

#pragma mark online config

/**
 * 在线参数配置
 */
+ (void)updateOnlineConfig;
+ (NSString *)getConfigParams:(NSString*)key withDefaultValue:(NSString *)value;

#pragma mark location query
#ifdef LOTUSEED_LOCATION
/**
 * 在线位置查询
 * 请尽可能在主线程中调用该方法，同时允许打开GPS获取位置信息；子线程中调用时GPS位置信息将无法获取。
 */
+ (void)queryMyLocationWithDelegate:(id)delegate didFinishSelector:(SEL)selector allowGPS:(BOOL)allow;
#endif

/**
 * 强制提交缓存数据
 */
+ (void)forcePost;

/**
 * 获取设备唯一识别串
 */
+ (NSString*)getDeviceID;


#ifdef LOTUSEED_TRACK
/**
 * 跟踪用户注册事件
 * @临时性api
 */
+ (void)trackUserRegister:(NSString*)userName;
#endif

@end
