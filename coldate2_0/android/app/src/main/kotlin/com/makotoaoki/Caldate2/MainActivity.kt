package com.makotoaoki.Caldate2

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity

import android.os.Build
import android.os.Bundle
import android.view.ViewTreeObserver
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "package/coldate"
        private const val METHOD_GET_LIST = "test"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val dataStore : SharedPreferences = getSharedPreferences("DataSrore", Context.MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
                    if (methodCall.method == METHOD_GET_LIST) {
                        val parametoers = methodCall.arguments<String>();
                        val e = dataStore.edit()
                        e.putString("Input", parametoers)
                        e.commit()
                    }
                }

    }
}