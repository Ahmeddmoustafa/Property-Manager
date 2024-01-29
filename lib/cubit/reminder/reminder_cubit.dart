// import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:flutter_sms/flutter_sms.dart';

part "reminder_state.dart";

class ReminderCubit extends Cubit<ReminderState> {
  SmsSender sender = new SmsSender();

  ReminderCubit() : super(ReminderState());

  Future<void> sendSms() async {
    // String address = "01100888552";
    // SmsMessage message = new SmsMessage(
    //     address, 'We would like to remind you of a late installment');
    // message.onStateChanged.listen((state) {
    //   if (state == SmsMessageState.Sent) {
    //     print("SMS is sent!");
    //   } else if (state == SmsMessageState.Delivered) {
    //     print("SMS is delivered!");
    //   }
    // });
    // sender.sendSms(message);

    // final SmsStatus result = await BackgroundSms.sendMessage(
    //     phoneNumber: "01100888552",
    //     message: "We would like to remind you of a late installment");
    // if (result == SmsStatus.sent) {
    //   print("Sent");
    // } else {
    //   print("Failed");
    // }

    String _result =
        await sendSMS(message: "message", recipients: ["201100888552"])
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
