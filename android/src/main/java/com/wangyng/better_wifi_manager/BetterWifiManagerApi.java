package com.wangyng.better_wifi_manager;

import android.content.Context;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiInfo;
import android.os.Build;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public interface BetterWifiManagerApi {

    // 获取wifi搜索信息
    void scanWifi(Context context, BetterWifiManagerEventSink eventSink);
    void registerReceiver(Context context);
    void unregisterReceiver(Context context);

    // 获取当前wifi信息
    WifiInfo getCurrentWifiInfo(Context context);

    // 获取wifi状态
    boolean isWifiOpen(Context context);

    // 获取Location状态
    boolean isLocationOpen(Context context);

    // 跳转到Wifi设置页
    void pushToWifiSettingPage(Context context);

    // 跳转到位置授权页面
    void pushToLocationPermissionPage(Context context);

    static void setup(BinaryMessenger binaryMessenger, BetterWifiManagerApi api, Context context) {
        { // scanWifi
            EventChannel eventChannel = new EventChannel(binaryMessenger, "com.wangyng.better_wifi_manager/scanResultListenerEvent");
            BetterWifiManagerEventSink eventSink = new BetterWifiManagerEventSink();
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.scanWifi", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {

                        // 搜索到的wifi列表
                        api.scanWifi(context, eventSink);

                        wrapped.put("result", new HashMap<>());
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
                eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink.event = events;
                        api.registerReceiver(context);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink.event = null;
                        api.unregisterReceiver(context);
                    }
                });
            } else {
                channel.setMessageHandler(null);
                eventChannel.setStreamHandler(null);
            }
        }
        { // getWifiInfo
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.getWifiInfo", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {

                        // 当前连接的wifi信息
                        WifiInfo wifiInfo = api.getCurrentWifiInfo(context);
                        String currentSSID = wifiInfo != null ? wifiInfo.getSSID() : "";
                        if (currentSSID.indexOf("\"") == 0)
                            currentSSID = currentSSID.substring(1);   //去掉第一个 "
                        if (currentSSID.lastIndexOf("\"") == (currentSSID.length() - 1)) {
                            currentSSID = currentSSID.substring(0, currentSSID.length() - 1);  //去掉最后一个 "
                        }

                        HashMap<String, Object> result = new HashMap<>();
                        result.put("SSID", currentSSID);
                        wrapped.put("result", result);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // getWifiState
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.isWifiOpen", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> result = new HashMap<>();
                        boolean isOpen = api.isWifiOpen(context);
                        result.put("isOpen", isOpen);

                        wrapped.put("result", result);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // getLocationState
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.isLocationOpen", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> result = new HashMap<>();
                        boolean isOpen = api.isLocationOpen(context);
                        result.put("isOpen", isOpen);

                        wrapped.put("result", result);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // pushToWifiSettingPage
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.pushToWifiSettingPage", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        api.pushToWifiSettingPage(context);

                        HashMap<String, Object> result = new HashMap<>();
                        wrapped.put("result", result);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // pushToLocationPermissionPage
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_wifi_manager.pushToLocationPermissionPage", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        api.pushToLocationPermissionPage(context);

                        HashMap<String, Object> result = new HashMap<>();
                        wrapped.put("result", result);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
    }

    static HashMap<String, Object> wrapError(Exception exception) {
        HashMap<String, Object> errorMap = new HashMap<>();
        errorMap.put("message", exception.toString());
        errorMap.put("code", null);
        errorMap.put("details", null);
        return errorMap;
    }
}
