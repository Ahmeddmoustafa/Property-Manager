import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> selectInstallmentDate(BuildContext context, int index) async {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();
  DateTime startDate = formCubit.getStartDate(index);
  DateTime initialDate;
  if (formCubit.installmentDates[index] != null &&
      startDate.isBefore(formCubit.installmentDates[index]!))
    initialDate = formCubit.installmentDates[index]!;
  else
    initialDate = startDate;

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: startDate,
    lastDate: formCubit.getEndDate(index),
  );

  if (pickedDate != null) {
    // setState(() {
    //   contractDate = pickedDate;
    // });
    formCubit.addInstallmentDate(pickedDate, index);
  }
}

Future<void> selectSubmissionDate(BuildContext context) async {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != formCubit.submissionDate) {
    formCubit.submissionDate = pickedDate;
  }
}

Future<void> selectContractDate(BuildContext context) async {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime(2010),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != formCubit.submissionDate) {
    formCubit.contractDate = pickedDate;
    // setState(() {
    //   contractDate = pickedDate;
    // });
  }
}

Future<void> selectFirstInstallmentDate(BuildContext context) async {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: formCubit.firstInstallment,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != formCubit.firstInstallment) {
    formCubit.selectFirstInstallment(pickedDate);
  }
}

Future<void> selectLastInstallmentDate(BuildContext context) async {
  final AddPropertyCubit formCubit = context.read<AddPropertyCubit>();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: formCubit.lastInstallment,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != formCubit.lastInstallment) {
    formCubit.selectLastInstallment(pickedDate);
  }
}
