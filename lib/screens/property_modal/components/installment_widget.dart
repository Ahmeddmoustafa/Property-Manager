import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstallmentsStepperWidget extends StatefulWidget {
  const InstallmentsStepperWidget({super.key, required this.propertyModel});
  final PropertyModel propertyModel;

  @override
  State<InstallmentsStepperWidget> createState() =>
      _InstallmentsStepperWidgetState();
}

class _InstallmentsStepperWidgetState extends State<InstallmentsStepperWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Property Installments:",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: defaultPadding * 2,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.propertyModel.installments.length,
            itemBuilder: (context, index) => getInstallments(index)),
      ],
    );
  }

  Widget getInstallments(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(formatDate(widget.propertyModel.installments[i].date)),
        Column(
          children: [
            if (i != 0)
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
                _showConfirmationDialog(context, widget.propertyModel, i);
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: ColorManager.Orange, shape: BoxShape.circle),
              ),
            ),
            Text("1,000,000 EGP"),
          ],
        )
      ],
    );
  }

  void _showConfirmationDialog(
      BuildContext context, PropertyModel model, int inst) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorManager.BackgroundColor,
          title: Text('Please Confirm'),
          content: Text('Client Paid 1,000,000 EGP ?'),
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
        BlocProvider.of<PropertyModalCubit>(context)
            .payInstallment(model, inst);
      } else {
        // User pressed "No" or closed the dialog
        print('User pressed No or closed the dialog');
      }
    });
  }
}
