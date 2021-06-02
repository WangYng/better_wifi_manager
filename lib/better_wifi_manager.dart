
import 'package:flutter/services.dart';

class BetterWifiManager {
  final Stream scanResultStream =
      EventChannel("com.wangyng.better_wifi_manager/scanResultListenerEvent").receiveBroadcastStream();

  // 获取wifi搜索信息
  Future<void> scanWifi() async {
    const channel =
        BasicMessageChannel<dynamic>('com.wangyng.better_wifi_manager.scanWifi', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map.from(replyMap['error']);
      _throwException(error);
    } else {
      // noop
    }
  }

  // 获取wifi信息
  Future<String> getWifiInfo() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_wifi_manager.getWifiInfo', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map.from(replyMap['error']);
      _throwException(error);
      return "";
    } else {
      final result = Map<String, dynamic>.from(replyMap["result"]);
      return result["SSID"];
    }
  }

  // 获取wifi状态
  Future<bool> isWifiOpen() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_wifi_manager.isWifiOpen', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      return false;
    } else {
      final result = Map<String, dynamic>.from(replyMap["result"]);
      return result["isOpen"];
    }
  }

  // 获取Location状态
  Future<bool> isLocationOpen() async {
    const channel =
        BasicMessageChannel<dynamic>('com.wangyng.better_wifi_manager.isLocationOpen', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      return false;
    } else {
      final result = Map<String, dynamic>.from(replyMap["result"]);
      return result["isOpen"];
    }
  }

  // 跳转到Wifi设置页
  Future<void> pushToWifiSettingPage() async {
    const channel =
        BasicMessageChannel<dynamic>('com.wangyng.better_wifi_manager.pushToWifiSettingPage', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
    } else {
      // noop
    }
  }

  // 跳转到位置设置页面
  Future<void> pushToLocationSettingPage() async {
    const channel = BasicMessageChannel<dynamic>(
        'com.wangyng.better_wifi_manager.pushToLocationSettingPage', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {};
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
    } else {
      // noop
    }
  }

  // makes real freq boundaries
  static bool is24GHz(int freq) {
    return freq > 2400 && freq < 2500;
  }

  // makes real freq boundaries
  static bool is5GHz(int freq) {
    return freq > 4900 && freq < 5900;
  }
}

class WifiScanResult {
  String SSID;
  int frequency;

  WifiScanResult wifiScanResultEntityFromJson(Map<String, dynamic> json) {
    if (json['SSID'] != null) {
      this.SSID = json['SSID'].toString();
    }
    if (json['frequency'] != null) {
      this.frequency = json['frequency'] is String ? int.tryParse(json['frequency']) : json['frequency'].toInt();
    }
    return this;
  }

  Map<String, dynamic> wifiScanResultEntityToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SSID'] = this.SSID;
    data['frequency'] = this.frequency;
    return data;
  }

  @override
  String toString() {
    return 'frequency: $frequency  SSID: $SSID';
  }
}

_throwChannelException() {
  throw PlatformException(code: 'channel-error', message: 'Unable to establish connection on channel.', details: null);
}

_throwException(Map<String, dynamic> error) {
  throw PlatformException(code: "${error['code']}", message: "${error['message']}", details: "${error['details']}");
}
