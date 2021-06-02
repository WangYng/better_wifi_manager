//
//  BetterWifiManagerApi.h
//  Pods
//
//  Created by 汪洋 on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BetterWifiManagerEventSink.h"

@protocol BetterWifiManagerApiDelegate <NSObject>

// 获取wifi搜索信息
- (void) scanWifiWithEventSink:(BetterWifiManagerEventSink *)eventSink;

// 获取wifi信息
- (NSString *)getWifiInfo;

// 获取wifi状态
- (BOOL)isWifiOpen;

// 跳转wifi设置页面
- (void)pushToWifiSettingPage;

@end

@interface BetterWifiManagerApi : NSObject

+ (void)setup:(NSObject<FlutterPluginRegistrar>*)registrar api:(id<BetterWifiManagerApiDelegate>)api;


@end
