# better_wifi_manager

A simple Wifi manager for Flutter.

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_wifi_manager: ^0.0.1
```

2. Install it

```bash
$ flutter packages get
```

## Normal usage

1. ensure wifi is opened.

2. request location permission.

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
- [x] current WiFi info.
- [x] scan wifi. (only Android)

