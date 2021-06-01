//
//  BetterWifiManagerEventSink.h
//  Pods
//
//  Created by 汪洋 on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface BetterWifiManagerEventSink : NSObject <FlutterStreamHandler>

@property (nonatomic, copy) FlutterEventSink event;

@end
