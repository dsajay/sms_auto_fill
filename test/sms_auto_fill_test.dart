import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sms_read_form_retriever_api/sms_auto_fill_platform_interface.dart';

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


}
