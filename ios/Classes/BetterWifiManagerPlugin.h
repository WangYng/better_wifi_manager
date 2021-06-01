#import <Flutter/Flutter.h>
#import "BetterWifiManagerApi.h"

@interface BetterWifiManagerPlugin : NSObject<BetterWifiManagerApiDelegate>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end
