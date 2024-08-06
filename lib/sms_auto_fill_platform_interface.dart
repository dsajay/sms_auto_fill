import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sms_auto_fill_method_channel.dart';

abstract class SmsAutoFillPlatform extends PlatformInterface {
  /// Constructs a SmsAutoFillPlatform.
  SmsAutoFillPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsAutoFillPlatform _instance = MethodChannelSmsAutoFill();

  /// The default instance of [SmsAutoFillPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmsAutoFill].
  static SmsAutoFillPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmsAutoFillPlatform] when
  /// they register themselves.
  static set instance(SmsAutoFillPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> registerReceiver() {
    throw UnimplementedError('registerReceiver() has not been implemented.');
  }

  Future<String?> unRegisterReceiver() {
    throw UnimplementedError('unRegisterReceiver() has not been implemented.');
  }
}
