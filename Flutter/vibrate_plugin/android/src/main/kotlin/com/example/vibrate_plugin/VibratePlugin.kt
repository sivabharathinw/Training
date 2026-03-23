package com.example.vibrate_plugin
//in kotlin semicolonn at the end is optional
//Context give access to android service
import android.content.Context
//provides android os version info ,bcz every andorid version has a api level number which tells what are the f3eatures are available at the andoid
import android.os.Build
//defines the viibrationPattern
import android.os.VibrationEffect
//control the vibration
import android.os.Vibrator
//android 12+ vibrationManager
import android.os.VibratorManager
//here flutter engine provides two mwthods attach and detach of plugins to flutter
import io.flutter.embedding.engine.plugins.FlutterPlugin
//MethodCall is a object represent req that send to android
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
//methodcallhandler is an interface to handle method calls from flutter
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
//send respons back to result
import io.flutter.plugin.common.MethodChannel.Result
//vibrate plugin class implements flutterplugin to attach and detach the plugin to flutter engine
//methodcall handler to handle method calls from flutter
class VibratePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
t
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "vibrate_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "vibrate" -> {
                val duration = call.argument<Int>("duration") ?: 500
                vibrate(duration.toLong())
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun vibrate(duration: Long) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val manager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            val vibrator = manager.defaultVibrator
            vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            @Suppress("DEPRECATION")
            val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(duration)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}


