import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/resources/Utils/functions.dart';
import 'package:admin/screens/add_property/components/dates_selection.dart';
import 'package:admin/screens/add_property/components/input_price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DataRow getRegularInstallmentRow(BuildContext context, double width) {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            InkWell(
                onTap: () async => await selectFirstInstallmentDate(context),
                child: Icon(Icons.date_range_rounded)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formatDate(formCubit.firstInstallment),
                )),
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            InkWell(
                onTap: () async => await selectLastInstallmentDate(context),
                child: Icon(Icons.date_range_rounded)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formatDate(formCubit.lastInstallment),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Center(
          child: SizedBox(
            width: width * 0.1,
            child: TextField(
              maxLength: 20,
              controller: formCubit.installmentsAmountController,
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
        ),
      ),
      DataCell(
        Center(
          child: SizedBox(
            width: width * 0.1,
            child: TextField(
              maxLength: 3,
              controller: formCubit.installmentsDurationController,
              // textAlignVertical: TextAlignVertical.top,
              onChanged: (value) {
                // formCubit.updateEmail(value);
              },

              decoration: InputDecoration(
                counterText: "",
                hintText: "Days",
                // labelText: 'Price In EGP',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: InputBorder.none,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                // PriceInputFormatter(), // Custom formatter
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

DataRow installmentDataRow(BuildContext context, double width, int index) {
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
              onTap: () async => await selectInstallmentDate(context, index),
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
