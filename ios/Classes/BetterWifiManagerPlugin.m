#import "BetterWifiManagerPlugin.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import "BetterWifiManagerEventSink.h"
#import <ifaddrs.h>
#import <net/if.h>
#import "BetterWifiManagerReachability.h"

@interface BetterWifiManagerPlugin ()

@property (nonatomic, strong) BetterWifiManagerEventSink *eventSink;

@end

@implementation BetterWifiManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BetterWifiManagerPlugin* instance = [[BetterWifiManagerPlugin alloc] init];
    [BetterWifiManagerApi setup:registrar api:instance];
}

- (void)scanWifiWithEventSink:(BetterWifiManagerEventSink *)eventSink {
    self.eventSink = eventSink;
    
    NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
    event[@"scanResult"] = [NSString stringWithFormat:@"[{\"SSID\":\"%@\"}]", [self getWifiInfo]];
    self.eventSink.event(event);
}

- (NSString *)getWifiInfo {
    NSString *currentSSID = @"";
    CFArrayRef networkInterface = CNCopySupportedInterfaces();
    if (networkInterface != nil) {
        CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(networkInterface, 0));
        if (networkInfo != nil) {
            currentSSID = CFBridgingRelease(CFDictionaryGetValue(networkInfo, kCNNetworkInfoKeySSID));
        }
    }
    
    return currentSSID;
}

- (BOOL)isWifiOpen {
    BetterWifiManagerReachability *reachability = [BetterWifiManagerReachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NetworkStatus status = [reachability currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

- (void)pushToWifiSettingPage {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}

@end
