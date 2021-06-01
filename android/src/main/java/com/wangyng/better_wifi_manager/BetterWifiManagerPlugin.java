package com.wangyng.better_wifi_manager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.LocationManager;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.provider.Settings;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * BetterWifiManagerPlugin
 */
public class BetterWifiManagerPlugin implements FlutterPlugin, BetterWifiManagerApi {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BetterWifiManagerApi.setup(binding.getBinaryMessenger(), this, binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        BetterWifiManagerApi.setup(binding.getBinaryMessenger(), null, null);
    }

    private BetterWifiManagerEventSink eventSink;

    private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (eventSink != null) {
                WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

                // 搜索到的wifi列表
                List<ScanResult> scanResultList = wifiManager.getScanResults();
                JSONArray wifiArray = new JSONArray();
                try {
                    for (ScanResult result : scanResultList) {
                        JSONObject wifiObject = new JSONObject();
                        if (!result.SSID.equals("")) {
                            wifiObject.put("SSID", result.SSID);
                            wifiObject.put("frequency", result.frequency);
                            wifiArray.put(wifiObject);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                HashMap<String, Object> result = new HashMap<>();
                result.put("scanResult", wifiArray.toString());

                eventSink.event.success(result);
            }
        }
    };


    @Override
    public void scanWifi(Context context, BetterWifiManagerEventSink eventSink) {
        WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        wifiManager.startScan();

        this.eventSink = eventSink;
    }


    @Override
    public void registerReceiver(Context context) {
        context.getApplicationContext().registerReceiver(broadcastReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
    }

    @Override
    public void unregisterReceiver(Context context) {
        context.getApplicationContext().unregisterReceiver(broadcastReceiver);
    }

    @Override
    public WifiInfo getCurrentWifiInfo(Context context) {
        WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        return wifiManager.getConnectionInfo();
    }

    @Override
    public boolean isLocationOpen(Context context) {
        LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        return locationManager.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER);
    }

    @Override
    public boolean isWifiOpen(Context context) {
        WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        int state = wifiManager.getWifiState();
        boolean flag = false;
        if (state == WifiManager.WIFI_STATE_ENABLED || state == WifiManager.WIFI_STATE_ENABLING) {
            flag = true;
        }
        return flag;
    }

    @Override
    public void pushToWifiSettingPage(Context context) {
        Intent intent = new Intent(Settings.ACTION_WIFI_SETTINGS);//"android.net.wifi.PICK_WIFI_NETWORK");
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    @Override
    public void pushToLocationPermissionPage(Context context) {
        Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }
}
