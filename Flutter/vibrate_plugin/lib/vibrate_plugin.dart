//imports the platform interface to use the methods of the platform
import 'vibrate_plugin_platform_interface.dart';
class VibratePlugin {
  //it just have the method but not have the implementation
  //inside i return the platform instance,which actually points to the method channel so the vibrate method inside methodchannel is called
  Future<void> vibrate({int duration = 500}) {
    return VibratePluginPlatform.instance.vibrate(duration: duration);
  }
}