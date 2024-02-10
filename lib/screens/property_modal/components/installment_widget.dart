import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/cubit/stepper/stepper_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstallmentsStepperWidget extends StatefulWidget {
  const InstallmentsStepperWidget(
      {super.key,
      required this.propertyModel,
      required this.start,
      required this.end,
      this.stepperIndex});
  final PropertyModel propertyModel;
  final stepperIndex;
  final int start;
  final int end;

  @override
  State<InstallmentsStepperWidget> createState() =>
      _InstallmentsStepperWidgetState();
}

class _InstallmentsStepperWidgetState extends State<InstallmentsStepperWidget> {
  @override
  Widget build(BuildContext context) {
    final StepperCubit steppercubit = BlocProvider.of<StepperCubit>(context);

    return BlocBuilder<StepperCubit, StepperState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: defaultPadding * 2),
                child: SizedBox(
                  // width should be changed
                  width: 400,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 0.5,
                        color: steppercubit.getStepperColor(widget
                            .propertyModel.installments
                            .sublist(widget.start, widget.end)),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => steppercubit.openStepper(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(formatDate(widget
                              .propertyModel.installments[widget.start].date)),
                          Text("To"),
                          Text(formatDate(widget.propertyModel
                              .installments[widget.end - 1].date)),
                          Icon(steppercubit.opened
                              ? Icons.arrow_drop_down
                              : Icons.arrow_left)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: defaultPadding * 2,
            // ),
            steppercubit.opened
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.propertyModel.installments
                        .sublist(widget.start, widget.end)
                        .length,
                    itemBuilder: (context, index) =>
                        getInstallments(index + widget.start))
                : SizedBox.shrink()
          ],
        );
      },
    );
  }

  Widget getInstallments(int i) {
    final PropertyModalCubit cubit = context.read<PropertyModalCubit>();
    final bool isPaid = cubit.isPaid(i);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${formatDate(widget.propertyModel.installments[i].date)}",
        ),
        Column(
          children: [
            if (i != widget.start)
              Container(
                margin: EdgeInsets.symmetric(vertical: defaultPadding),
                child: SizedBox(
                  height: 100,
                  child: VerticalDivider(
                    color: ColorManager.DarkGrey,
                  ),
                ),
              ),
            InkWell(
              onTap: () {
                if (!isPaid)
                  _showConfirmationDialog(context, widget.propertyModel, i);
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: getInstallmentColor(i, isPaid),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              "${formatPrice(
                widget.propertyModel.installments[i].amount,
              )} EGP",
            ),
          ],
        )
      ],
    );
  }

  Color getInstallmentColor(index, bool ispaid) {
    final Installment installment = widget.propertyModel.installments[index];
    if (installment.getType() == AppStrings.UpcomingType) {
      if (ispaid) return ColorManager.Green;
      return ColorManager.Orange;
    }
    if (installment.getType() == AppStrings.NotPaidType) {
      if (ispaid) return ColorManager.Green;
      return ColorManager.error;
    }
    return ColorManager.Green;
  }

  void _showConfirmationDialog(
      BuildContext context, PropertyModel model, int inst) {
    if (model.installments[inst].getType() != AppStrings.PaidType)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ColorManager.BackgroundColor,
            title: Text('Please Confirm'),
            content:
                Text('Client Paid ${model.installments[inst].amount} EGP ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Perform action when "Yes" is pressed
                  Navigator.of(context)
                      .pop(true); // Close the dialog and return true
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  // Perform action when "No" is pressed
                  Navigator.of(context)
                      .pop(false); // Close the dialog and return false
                },
                child: Text('No'),
              ),
            ],
          );
        },
      ).then((result) {
        // The "result" variable contains the value returned by the dialog
        if (result != null && result) {
          // User pressed "Yes"
          print('User pressed Yes');
          BlocProvider.of<PropertyModalCubit>(context).payInstallment(inst);
        } else {
          // User pressed "No" or closed the dialog
          print('User pressed No or closed the dialog');
        }
      });
  }
}
