import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mic_volume_method_channel.dart';

abstract class MicVolumePlatform extends PlatformInterface {
  /// Constructs a MicVolumePlatform.
  MicVolumePlatform() : super(token: _token);

  static final Object _token = Object();

  static MicVolumePlatform _instance = MethodChannelMicVolume();

  /// The default instance of [MicVolumePlatform] to use.
  ///
  /// Defaults to [MethodChannelMicVolume].
  static MicVolumePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MicVolumePlatform] when
  /// they register themselves.
  static set instance(MicVolumePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }

  Future<double?> getMicVolume() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> startCheck() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> stopCheck() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
