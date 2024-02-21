import 'package:admin/constants.dart';
import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/add_property/components/installments_widget.dart';
import 'package:admin/screens/add_property/components/property_inputs_widget.dart';
import 'package:admin/screens/main/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPropertyModal extends StatefulWidget {
  const AddPropertyModal({Key? key, required this.height, required this.width})
      : super(key: key);
  final double height;
  final double width;

  @override
  State<AddPropertyModal> createState() => _AddPropertyModalState();
}

class _AddPropertyModalState extends State<AddPropertyModal> {
  DateTime contractDate = DateTime.now();
  DateTime submissionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<AddPropertyCubit>().addTestData();
  }

  @override
  Widget build(BuildContext context) {
    final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();
    final PropertyCubit propertyCubit = context.read<PropertyCubit>();

    final double height = widget.height;
    final double width = widget.width;

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: BlocConsumer<AddPropertyCubit, AddPropertyState>(
            listener: (context, state) {
              if (formCubit.loading == true) {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent users from dismissing the dialog by tapping outside
                  builder: (BuildContext context) {
                    return AddPropertyLoadingScreen();
                  },
                );
              }
            },
            builder: (context, state) {
              // print("installment not filled ${formCubit.installmentError}");

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Please Enter Property Details",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          backgroundColor: ColorManager.SecondaryColor,
                          onPressed: () => Navigator.pop(context),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  PropertyInputsWidget(height: height, width: width),
                  SizedBox(height: AppSize.s40),
                  Row(
                    children: [
                      Text(
                        "Please Enter Payment Installments",
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s16,
                  ),
                  Center(
                    child: Column(
                      children: [
                        DataTable(
                          columnSpacing: Responsive.isMobile(context)
                              ? AppSize.s25
                              : AppSize.s50,
                          columns: [
                            DataColumn(
                              label: Flexible(
                                  child: Text(
                                "First Installment Date",
                                overflow: TextOverflow.fade,
                              )),
                            ),
                            DataColumn(
                              label: Flexible(
                                  child: Text(
                                "Last Installment Date",
                                overflow: TextOverflow.visible,
                              )),
                            ),
                            DataColumn(
                              label: Flexible(
                                  child: Text(
                                "Installment Amount",
                                overflow: TextOverflow.visible,
                              )),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  "Installment Duration",
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(
                            1,
                            (index) => getRegularInstallmentRow(context, width),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.s25),
                  Center(
                    child: SizedBox(
                      width: width * 0.25,
                      height: height * 0.07,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Perform form submission logic here
                          // You can access the form data using formCubit.state
                          // print('Username: ${formCubit.state.username}');
                          // print('Email: ${formCubit.state.email}');
                          formCubit.generateRegularInstallments();
                        },
                        child: Text(
                          'Generate Installments',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  formCubit.regularInstallmentsGenerated
                      ? Center(
                          child: Column(
                            children: [
                              DataTable(
                                columnSpacing: Responsive.isMobile(context)
                                    ? AppSize.s25
                                    : AppSize.s100,
                                columns: [
                                  DataColumn(
                                    label: Text("Installments"),
                                  ),
                                  DataColumn(
                                    label: Text("Date"),
                                  ),
                                  DataColumn(
                                    label: Text("Payment Amount"),
                                  ),
                                ],
                                rows: List.generate(
                                  formCubit.installmentsConttrollers.length,
                                  (index) =>
                                      installmentDataRow(context, width, index),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      formCubit.addInstallmentController();
                                    },
                                    icon: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: AppSize.s20,
                                        ),
                                        child: Icon(Icons.add_circle)),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: AppSize.s50),
                  formCubit.installmentError
                      ? Center(
                          child: Text(
                            "Please Fill or Remove Unneccessary Installments *",
                            style: TextStyle(color: ColorManager.error),
                            textAlign: TextAlign.start,
                          ),
                        )
                      : SizedBox.shrink(),
                  formCubit.priceValidationError
                      ? Center(
                          child: Text(
                            "Total Price not equal Installments + Paid amount *",
                            style: TextStyle(color: ColorManager.error),
                            textAlign: TextAlign.start,
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: AppSize.s10),
                  Center(
                    child: SizedBox(
                      width: width * 0.2,
                      height: height * 0.1,
                      child: ElevatedButton(
                        onPressed: !formCubit.loading
                            ? () async {
                                // Perform form submission logic here
                                // You can access the form data using formCubit.state
                                // print('Username: ${formCubit.state.username}');
                                // print('Email: ${formCubit.state.email}');

                                PropertyModel? model =
                                    await formCubit.addProperty();
                                print(formCubit.hasError());
                                if (!formCubit.hasError() && model != null) {
                                  propertyCubit.addProperty(model);
                                  await propertyCubit.categorize();
                                  Navigator.pop(context);
                                  // Navigator.pushReplacementNamed(
                                  //     context, Routes.homeRoute);
                                }
                              }
                            : null,
                        child: Text('Add Property'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
