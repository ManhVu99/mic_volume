import 'package:flutter_test/flutter_test.dart';
import 'package:mic_volume/mic_volume.dart';
import 'package:mic_volume/mic_volume_platform_interface.dart';
import 'package:mic_volume/mic_volume_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMicVolumePlatform
    with MockPlatformInterfaceMixin
    implements MicVolumePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MicVolumePlatform initialPlatform = MicVolumePlatform.instance;

  test('$MethodChannelMicVolume is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMicVolume>());
  });

  test('getPlatformVersion', () async {
    MicVolume micVolumePlugin = MicVolume();
    MockMicVolumePlatform fakePlatform = MockMicVolumePlatform();
    MicVolumePlatform.instance = fakePlatform;

    expect(await micVolumePlugin.getPlatformVersion(), '42');
  });
}
