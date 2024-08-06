import 'package:flutter_test/flutter_test.dart';
import 'package:sms_auto_fill/sms_auto_fill.dart';
import 'package:sms_auto_fill/sms_auto_fill_platform_interface.dart';
import 'package:sms_auto_fill/sms_auto_fill_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSmsAutoFillPlatform
    with MockPlatformInterfaceMixin
    implements SmsAutoFillPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');



  @override
  Future<String?> registerReceiver() {
    // TODO: implement registerReceiver
    throw UnimplementedError();
  }

  @override
  Future<String?> unRegisterReceiver() {
    // TODO: implement unRegisterReceiver
    throw UnimplementedError();
  }
}

void main() {
  final SmsAutoFillPlatform initialPlatform = SmsAutoFillPlatform.instance;

  test('$MethodChannelSmsAutoFill is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSmsAutoFill>());
  });

  test('getPlatformVersion', () async {
    SmsAutoFill smsAutoFillPlugin = SmsAutoFill();
    MockSmsAutoFillPlatform fakePlatform = MockSmsAutoFillPlatform();
    SmsAutoFillPlatform.instance = fakePlatform;

    expect(await smsAutoFillPlugin.getPlatformVersion(), '42');
  });
}
