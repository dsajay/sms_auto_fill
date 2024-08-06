import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sms_auto_fill_platform_interface.dart';

/// An implementation of [SmsAutoFillPlatform] that uses method channels.
class MethodChannelSmsAutoFill extends SmsAutoFillPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sms_auto_fill');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> registerReceiver() async{
    final service = await methodChannel.invokeMethod<String>('registerReceiver');
    return service;
  }
  @override
  Future<String?> unRegisterReceiver() async{
    final service = await methodChannel.invokeMethod<String>('unRegisterReceiver');
    return service;
  }
}
