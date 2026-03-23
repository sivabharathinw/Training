import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'vibrate_plugin_method_channel.dart';
//it is platfrom abstract class it have the declaration of method
abstract class VibratePluginPlatform extends PlatformInterface {
  VibratePluginPlatform() : super(token: _token);
  static final Object _token = Object();
//create the instace of the method channel class
  static VibratePluginPlatform _instance = MethodChannelVibratePlugin();
  //use getter to get the current instanace of the platform withpuut the getter the _instance is private so we cant call from outside that is from the vibration.dart

  static VibratePluginPlatform get instance => _instance;
  static set instance(VibratePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> vibrate({int duration = 500}) {
    throw UnimplementedError('vibrate() has not been implemented.');
  }
}