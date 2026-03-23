import 'package:flutter/services.dart';
import 'vibrate_plugin_platform_interface.dart';
//methodChannel class extends the vibratepluginplatform interface
//bcz this methodChannel class implements the function vibrate method from the platform interface
import 'package:flutter/services.dart';
class MethodChannelVibratePlugin extends VibratePluginPlatform {
  final _channel = const MethodChannel('vibrate_plugin');

  @override
  Future<void> vibrate({int duration = 500}) async {
    //invokeMethod() is used to  send message to native code and get the response from native code
    //it have 2 paramters 1st is the method name and 2nd is the arguments
    await _channel.invokeMethod('vibrate', {'duration': duration});
  }
}