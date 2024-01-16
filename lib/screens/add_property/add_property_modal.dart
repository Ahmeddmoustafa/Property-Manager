import 'package:admin/data/models/RecentFile.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPropertyModal extends StatefulWidget {
  const AddPropertyModal({Key? key, required this.height, required this.width})
      : super(key: key);
  final double height;
  final double width;

  @override
  State<AddPropertyModal> createState() => _AddPropertyModalState();
}

class _AddPropertyModalState extends State<AddPropertyModal> {
  late int installments = 1;

  @override
  Widget build(BuildContext context) {
    // final formCubit = context.read<FormCubit>();
    final double height = widget.height;
    final double width = widget.width;

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            // formCubit.updateUsername(value);
                          },
                          decoration: InputDecoration(
                              labelText: 'Property Description'),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: width * 0.2,
                        child: TextFormField(
                          onChanged: (value) {
                            // formCubit.updateEmail(value);
                          },
                          decoration:
                              InputDecoration(labelText: 'Price In EGP'),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: width * 0.2,
                        child: TextFormField(
                          onChanged: (value) {
                            // formCubit.updateEmail(value);
                          },
                          decoration:
                              InputDecoration(labelText: 'Paid Amount In EGP'),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            // formCubit.updateUsername(value);
                          },
                          decoration: InputDecoration(labelText: 'Buyer Name'),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: width * 0.2,
                        child: TextFormField(
                          onChanged: (value) {
                            // formCubit.updateEmail(value);
                          },
                          decoration:
                              InputDecoration(labelText: 'Buyer Phone Number'),
                        ),
                      ),
                      // SizedBox(height: 16),
                      // SizedBox(
                      //   width: width * 0.2,
                      //   child: TextFormField(
                      //     onChanged: (value) {
                      //       // formCubit.updateEmail(value);
                      //     },
                      //     decoration:
                      //         InputDecoration(labelText: 'Paid Amount In EGP'),
                      //   ),
                      // ),
                    ],
                  ),
                ],
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
                        installments,
                        (index) => recentFileDataRow(
                            demoRecentFiles[index], width, index),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              installments += 1;
                            });
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

                      Navigator.pop(context);
                    },
                    child: Text('Add Property'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow recentFileDataRow(RecentFile fileInfo, double width, int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            "Installment ${index + 1}",
          ),
        ),
        DataCell(Row(
          children: [
            Icon(Icons.date_range_rounded),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("12-10-2024"),
            ),
          ],
        )),
        DataCell(
          Row(
            children: [
              SizedBox(
                width: width * 0.2,
                child: TextField(
                  // textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {
                    // formCubit.updateEmail(value);
                  },
                  decoration: InputDecoration(
                    hintText: "EGP",
                    // labelText: 'Price In EGP',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: InputBorder.none,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    installments -= 1;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
