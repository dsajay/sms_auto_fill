import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sms_read_form_retriever_api/sms_auto_fill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _otpReceiver = 'Not Started';
  final _smsAutoFillPlugin = SmsAutoFill();

  @override
  void initState() {
    super.initState();
  }

  Future<void> startServiceForGetOtp() async {
    setState(() {
      _otpReceiver = "OTP Service Started";
    });
    String otp;
    try {
      otp = await _smsAutoFillPlugin.registerReceiver() ?? 'Not Received OTP';
    } on PlatformException {
      otp = 'Failed to get OTP.';
    }
    if (!mounted) return;

    setState(() {
      _otpReceiver = otp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS retriever'),
        ),
        body: Column(
          children: [
            Center(child: Text('Running on: $_otpReceiver\n'),),
            Center(child: TextButton(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.cyan)
            ),
              onPressed: () {startServiceForGetOtp(); },
              child: const Text('Start Service'),),),
          ],
        ),
      ),
    );
  }
}
