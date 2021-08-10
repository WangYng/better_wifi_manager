#import "BetterWifiManagerPlugin.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import "BetterWifiManagerEventSink.h"
#import <ifaddrs.h>
#import <net/if.h>
#import "BetterWifiManagerReachability.h"
#import <NetworkExtension/NetworkExtension.h>

@interface BetterWifiManagerPlugin ()

@property (nonatomic, strong) BetterWifiManagerEventSink *eventSink;

@property (nonatomic, strong) CLLocationManager *location;

@end

@implementation BetterWifiManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BetterWifiManagerPlugin* instance = [[BetterWifiManagerPlugin alloc] init];
    [BetterWifiManagerApi setup:registrar api:instance];
}

- (void)requestTemporaryFullAccuracyAuthorizationWithCompletion:(void(^)(BOOL))completion {
    if (@available(iOS 14.0, *)) {
        if (self.location == nil) {
            self.location = [CLLocationManager new];
        }
        CLAuthorizationStatus authorizationStatus = self.location.authorizationStatus;
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            if (self.location.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
                __weak typeof(self) ws = self;
                [self.location requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"WantsToGetWiFiSSID" completion:^(NSError *error) {
                    completion(ws.location.accuracyAuthorization == CLAccuracyAuthorizationFullAccuracy);
                }];
            } else {
                completion(YES);
            }
        } else {
            completion(NO);
        }
    } else {
        completion(NO);
    }
}

- (void)scanWifiWithEventSink:(BetterWifiManagerEventSink *)eventSink {
    self.eventSink = eventSink;
    
    __weak typeof(self) ws = self;
    [self getWifiInfoWithCompletion:^(NSString *SSID) {
        NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
        event[@"scanResult"] = [NSString stringWithFormat:@"[{\"SSID\":\"%@\"}]", SSID];
        ws.eventSink.event(event);
    }];
}

- (void)getWifiInfoWithCompletion:(void(^)(NSString *))completion {
    if (@available(iOS 14.0, *)) {
        [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
            if (currentNetwork) {
                completion(currentNetwork.SSID);
            } else {
                completion(@"");
            }
        }];
    } else {
         CFArrayRef networkInterface = CNCopySupportedInterfaces();
         if (networkInterface != nil) {
            CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(networkInterface, 0));
            if (networkInfo != nil) {
                NSString *SSID = CFBridgingRelease(CFDictionaryGetValue(networkInfo, kCNNetworkInfoKeySSID));
                completion(SSID);
            } else {
                completion(@"");
            }
         } else {
             completion(@"");
         }
    }
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
