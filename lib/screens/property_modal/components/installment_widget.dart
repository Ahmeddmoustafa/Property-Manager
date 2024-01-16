import 'package:admin/constants.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

class InstallmentsStepperWidget extends StatefulWidget {
  const InstallmentsStepperWidget({super.key});

  @override
  State<InstallmentsStepperWidget> createState() =>
      _InstallmentsStepperWidgetState();
}

class _InstallmentsStepperWidgetState extends State<InstallmentsStepperWidget> {
  @override
  Widget build(BuildContext context) {
    int activeStep = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Property Installments:",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        EasyStepper(
          activeStep: activeStep,
          direction: Axis.vertical,
          lineStyle: LineStyle(
            lineLength: 70,
            lineSpace: 0,
            lineType: LineType.normal,
            defaultLineColor: Colors.white,
            finishedLineColor: ColorManager.Green,
          ),

          activeStepTextColor: ColorManager.Green,
          finishedStepTextColor: ColorManager.Green,
          internalPadding: 0,
          showLoadingAnimation: false,
          stepRadius: 8,
          // showStepBorder: true,
          // lineDotRadius: 1.5,
          steps: [
            EasyStep(
              customStep: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 0 ? ColorManager.Green : Colors.white,
              ),
              title: '1,000,000 EGP',
            ),
            EasyStep(
              customStep: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 1 ? ColorManager.Green : Colors.white,
              ),
              title: '2,000,000 EGP',
              // topTitle: true,
            ),
            EasyStep(
              customStep: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 2 ? ColorManager.Green : Colors.white,
              ),
              title: '2,000,000 EGP',
            ),
            EasyStep(
              customStep: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 3 ? ColorManager.Green : Colors.white,
              ),
              title: '2,000,000 EGP',
              // topTitle: true,
            ),
            EasyStep(
              customStep: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 4 ? ColorManager.Green : Colors.white,
              ),
              title: '1,000,000 EGP',
            ),
          ],
          onStepReached: (index) => setState(() => activeStep = index),
        ),
      ],
    );
  }
}
