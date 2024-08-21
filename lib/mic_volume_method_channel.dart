import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mic_volume_platform_interface.dart';

/// An implementation of [MicVolumePlatform] that uses method channels.
class MethodChannelMicVolume extends MicVolumePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mic_volume');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }
  @override
  Future startCheck() async {
    await methodChannel.invokeMethod<String>('startChecking');
  }

  @override
  Future stopCheck() async {
    await methodChannel.invokeMethod<String>('stopChecking');
  }

  @override
  Future<double?> getMicVolume() async {
    final volume = await methodChannel.invokeMethod<double>('getMicLevel');
    return volume;
  }
}
