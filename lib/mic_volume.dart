import 'mic_volume_platform_interface.dart';

class MicVolume {
  Future<double?> getMicVolume() {
    return MicVolumePlatform.instance.getMicVolume();
  }

  Future<dynamic> startCheckVolume() async {
    await MicVolumePlatform.instance.startCheck();
  }

  Future<dynamic> stopCheckVolume() async {
    await MicVolumePlatform.instance.stopCheck();
  }
}
