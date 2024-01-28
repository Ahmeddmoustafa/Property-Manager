import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/routes_manager.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:admin/screens/add_property/components/input_price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _selectContractDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: contractDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != contractDate) {
      setState(() {
        contractDate = pickedDate;
      });
    }
  }

  Future<void> _selectSubmissionDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: submissionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != submissionDate) {
      setState(() {
        submissionDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();
    final double height = widget.height;
    final double width = widget.width;

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: BlocBuilder<AddPropertyCubit, AddPropertyState>(
            builder: (context, state) {
              print("installment not filled ${formCubit.installmentError}");

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
                  SizedBox(
                    height: height * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.3,
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
                              width: width * 0.2,
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
                              width: width * 0.2,
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
                              width: width * 0.3,
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
                              width: width * 0.2,
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
                                    onTap: () async =>
                                        await _selectContractDate(context),
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
                                        "${formatDate(contractDate)}",
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
                                    onTap: () async =>
                                        await _selectSubmissionDate(context),
                                    child: Icon(Icons.date_range_rounded)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Submission Date: ",
                                        style: TextStyle(
                                            color: ColorManager.LightSilver),
                                      ),
                                      Text(
                                        "${formatDate(submissionDate)}",
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
                  ),
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
                            (index) => installmentDataRow(width, index),
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
                  ),
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
                        onPressed: () async {
                          // Perform form submission logic here
                          // You can access the form data using formCubit.state
                          // print('Username: ${formCubit.state.username}');
                          // print('Email: ${formCubit.state.email}');

                          await formCubit.addProperty();
                          print(formCubit.hasError());
                          if (!formCubit.hasError()) {
                            Navigator.pushReplacementNamed(
                                context, Routes.homeRoute);
                          }
                        },
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

  Future<void> _selectInstallmentDate(BuildContext context, int index) async {
    final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // setState(() {
      //   contractDate = pickedDate;
      // });
      formCubit.addInstallmentDate(pickedDate, index);
    }
  }

  DataRow installmentDataRow(double width, int index) {
    final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

    return DataRow(
      cells: [
        DataCell(
          Text(
            "Installment ${index + 1}",
          ),
        ),
        DataCell(Row(
          children: [
            InkWell(
                onTap: () async => await _selectInstallmentDate(context, index),
                child: Icon(Icons.date_range_rounded)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formCubit.installmentDates[index] != null
                      ? "${formatDate(formCubit.installmentDates[index]!)}"
                      : "Date",
                )),
          ],
        )),
        DataCell(
          Row(
            children: [
              SizedBox(
                width: width * 0.2,
                child: TextField(
                  maxLength: 20,
                  controller: formCubit.installmentsConttrollers[index],
                  // textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {
                    // formCubit.updateEmail(value);
                  },

                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "EGP",
                    // labelText: 'Price In EGP',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: InputBorder.none,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    PriceInputFormatter(), // Custom formatter
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  formCubit.removeInstallment(index);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
