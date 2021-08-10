import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:better_wifi_manager/better_wifi_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final wifiManager = BetterWifiManager();

  bool wifiState = false;
  bool locationState = false;

  String currentSSID = "";
  List<WifiScanResult> wifiScanResult = [];

  StreamSubscription scanResultSubscription;

  @override
  void initState() {
    super.initState();

    PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]).then((value) async {
      if (value.values.first == PermissionStatus.granted) {
        if (Platform.isIOS) {
          final result = await BetterWifiManager.requestTemporaryFullAccuracyAuthorization();
          print("result $result");
        }
      }
    });
  }

  @override
  void dispose() {
    scanResultSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: Column(
            children: [
              CupertinoButton(
                child: Text("getWifiState"),
                onPressed: () async {
                  final result = await wifiManager.isWifiOpen();
                  setState(() {
                    wifiState = result;
                  });
                },
              ),
              CupertinoButton(
                child: Text("pushToWifiSetting"),
                onPressed: () => wifiManager.pushToWifiSettingPage(),
              ),
              CupertinoButton(
                child: Text("getLocationState"),
                onPressed: () async {
                  final result = await wifiManager.isLocationOpen();
                  setState(() {
                    locationState = result;
                  });
                },
              ),
              CupertinoButton(
                child: Text("pushToLocationSettingPage"),
                onPressed: () => wifiManager.pushToLocationSettingPage(),
              ),
              CupertinoButton(
                child: Text("getWifiInfo"),
                onPressed: () async {
                  final currentSSID = await wifiManager.getWifiInfo();
                  setState(() {
                    this.currentSSID = currentSSID;
                  });
                },
              ),
              CupertinoButton(
                child: Text("scanWifi"),
                onPressed: () async {
                  scanResultSubscription?.cancel();
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
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("WiFi : ${wifiState ? '🟢' : '🔴'}"),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Location : ${locationState ? '🟢' : '🔴'}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ssid: $currentSSID",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: wifiScanResult.map((e) => Text(e.toString())).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
