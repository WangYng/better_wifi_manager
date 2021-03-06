# better_wifi_manager

A simple Wifi manager for Flutter.

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_wifi_manager: ^0.0.5
```

2. Install it

```bash
$ flutter packages get
```

3. Config permission <br/>
#### iOS
> TARGETS -> Signing $ Capabilities -> +Capability -> Access WiFi Information. <br/>
Info.plist -> add Privacy - NSLocationWhenInUseUsageDescription.
Info.plist -> add Privacy - NSLocationTemporaryUsageDescriptionDictionary.
Info.plist -> add Privacy - NSLocationTemporaryUsageDescriptionDictionary - key - WantsToGetWiFiSSID.

#### Android
> AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

## Normal usage

1. ensure wifi is opened.

2. request location permission.
2.1 request accuracy location permission for iOS.

3. get wifi info or scan wifi list.

```dart
  final currentSSID = await wifiManager.getWifiInfo();

  scanResultSubscription = wifiManager.scanResultStream.listen((event) {
    scanResultSubscription?.cancel();
    final scanResult = event["scanResult"].toString();
    if (scanResult.isNotEmpty) {
      List<WifiScanResult> wifiScanResultList = jsonDecode(scanResult)
          .map((e) {
            return WifiScanResult().wifiScanResultEntityFromJson(e);
          })
          .cast<WifiScanResult>()
          .toList();

      setState(() {
        this.wifiScanResult = wifiScanResultList;
      });
    }
  });
  await wifiManager.scanWifi();
```

## Feature
- [x] determine WiFi enable. 
- [x] get WiFi info.
- [x] scan wifi. (only Android)

