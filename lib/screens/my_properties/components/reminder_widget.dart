import 'package:admin/constants.dart';
import 'package:admin/cubit/reminder/reminder_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        width: 400,
        color: ColorManager.BackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: getReminderData(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getReminderData() {
    final ReminderCubit cubit = BlocProvider.of<ReminderCubit>(context);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description"),
              SizedBox(
                height: defaultPadding,
              ),
              Text("Buyer Name"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    openWhatsApp("number");
                  },
                  child: Icon(Icons.sms)),
              SizedBox(
                height: defaultPadding,
              ),
              InkWell(
                  onTap: () async {
                    await cubit.sendSms();
                  },
                  child: Icon(Icons.message)),
            ],
          ),
        ],
      ),
      Divider(
        color: ColorManager.LightSilver,
        height: defaultPadding,
        thickness: 0.5,
      ),
    ]);
  }
}
