import 'package:flutter_test/flutter_test.dart';
import 'package:vibrate_plugin/vibrate_plugin.dart';
import 'package:vibrate_plugin/vibrate_plugin_platform_interface.dart';
import 'package:vibrate_plugin/vibrate_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVibratePluginPlatform
    with MockPlatformInterfaceMixin
    implements VibratePluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VibratePluginPlatform initialPlatform = VibratePluginPlatform.instance;

  test('$MethodChannelVibratePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVibratePlugin>());
  });

  test('getPlatformVersion', () async {
    VibratePlugin vibratePlugin = VibratePlugin();
    MockVibratePluginPlatform fakePlatform = MockVibratePluginPlatform();
    VibratePluginPlatform.instance = fakePlatform;

    expect(await vibratePlugin.getPlatformVersion(), '42');
  });
}
