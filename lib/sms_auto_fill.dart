import 'sms_auto_fill_platform_interface.dart';

class SmsAutoFill {
  Future<String?> getPlatformVersion() {
    return SmsAutoFillPlatform.instance.getPlatformVersion();
  }

  Future<String?> registerReceiver() {
    return SmsAutoFillPlatform.instance.registerReceiver();
  }

  Future<String?> unRegisterReceiver() {
    return SmsAutoFillPlatform.instance.registerReceiver();
  }
}
