//
//  BetterWifiManagerApi.m
//  Pods
//
//  Created by 汪洋 on 2021/6/1.
//

#import "BetterWifiManagerApi.h"

@implementation BetterWifiManagerApi

+ (void)setup:(NSObject<FlutterPluginRegistrar>*)registrar api:(id<BetterWifiManagerApiDelegate>)api {
    
    {
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.wangyng.better_wifi_manager/scanResultListenerEvent" binaryMessenger:[registrar messenger]];
        BetterWifiManagerEventSink *eventSink = [[BetterWifiManagerEventSink alloc] init];
        
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_wifi_manager.scanWifi" binaryMessenger:[registrar messenger]];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    [api scanWifiWithEventSink:eventSink];
                    
                    wrapped[@"result"] = @{};
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
            [eventChannel setStreamHandler:eventSink];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_wifi_manager.getWifiInfo" binaryMessenger:[registrar messenger]];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *wifiInfo = [api getWifiInfo];
                    
                    wrapped[@"result"] = @{@"SSID": wifiInfo};
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_wifi_manager.isWifiOpen" binaryMessenger:[registrar messenger]];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    bool isWifiOpen = [api isWifiOpen];
                    
                    wrapped[@"result"] = @{@"isOpen": @(isWifiOpen)};
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_wifi_manager.pushToWifiSettingPage" binaryMessenger:[registrar messenger]];

        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {

                    [api pushToWifiSettingPage];

                    wrapped[@"result"] = @{};
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
}


@end
