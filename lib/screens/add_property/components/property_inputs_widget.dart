import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:admin/screens/add_property/components/dates_selection.dart';
import 'package:admin/screens/add_property/components/input_price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyInputsWidget extends StatefulWidget {
  const PropertyInputsWidget(
      {super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  State<PropertyInputsWidget> createState() => _PropertyInputsWidgetState();
}

class _PropertyInputsWidgetState extends State<PropertyInputsWidget> {
  @override
  Widget build(BuildContext context) {
    final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

    return SizedBox(
      height: widget.height * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: widget.width * 0.3,
                child: TextFormField(
                  maxLength: 100,
                  controller: formCubit.descriptionController,
                  onChanged: (value) {
                    // formCubit.updateUsername(value);
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      labelText: 'Property Description',
                      counterText: "",
                      errorText: formCubit.descriptionError
                          ? "Please Enter Valid Desription"
                          : null),
                ),
              ),
              // SizedBox(height: 16),
              SizedBox(
                width: widget.width * 0.2,
                child: TextFormField(
                  maxLength: 20,
                  controller: formCubit.priceController,
                  onChanged: (value) {
                    // formCubit.updateEmail(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PriceInputFormatter(), // Custom formatter
                  ],
                  decoration: InputDecoration(
                      labelText: 'Price In EGP',
                      counterText: "",
                      errorText: formCubit.priceError
                          ? "Please Enter Valid Price"
                          : null),
                ),
              ),
              // SizedBox(height: 16),
              SizedBox(
                width: widget.width * 0.2,
                child: TextFormField(
                  maxLength: 20,
                  controller: formCubit.paidAmountController,
                  onChanged: (value) {
                    // formCubit.updateEmail(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PriceInputFormatter(), // Custom formatter
                  ],
                  decoration: InputDecoration(
                      labelText: 'Paid Amount In EGP',
                      counterText: "",
                      errorText: formCubit.paidAmountError
                          ? "Please Enter Valid Amount"
                          : null),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: widget.width * 0.3,
                child: TextFormField(
                  maxLength: 50,
                  controller: formCubit.buyerNameController,
                  onChanged: (value) {
                    // formCubit.updateUsername(value);
                  },
                  decoration: InputDecoration(
                      labelText: 'Buyer Name',
                      counterText: "",
                      errorText: formCubit.buyerNameError
                          ? "Please Enter Valid Name"
                          : null),
                ),
              ),
              // SizedBox(height: 16),
              SizedBox(
                width: widget.width * 0.2,
                child: TextFormField(
                  maxLength: 11,
                  controller: formCubit.buyerNumberController,
                  onChanged: (value) {
                    // formCubit.updateEmail(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      labelText: 'Buyer Phone Number',
                      counterText: "",
                      errorText: formCubit.buyerNumberError
                          ? "Please Enter Valid Number"
                          : null),
                ),
              ),
              // SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                      onTap: () async => await selectContractDate(context),
                      child: Icon(Icons.date_range_rounded)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Contract Date: ",
                          style: TextStyle(
                            color: ColorManager.LightSilver,
                          ),
                        ),
                        Text(
                          "${formatDate(formCubit.contractDate)}",
                          style: TextStyle(
                            color: ColorManager.LightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () async => await selectSubmissionDate(context),
                      child: Icon(Icons.date_range_rounded)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Submission Date: ",
                          style: TextStyle(color: ColorManager.LightSilver),
                        ),
                        Text(
                          "${formatDate(formCubit.submissionDate)}",
                          style: TextStyle(
                            color: ColorManager.LightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
