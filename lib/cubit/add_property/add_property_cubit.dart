import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/create_property_usecase.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  final CreatePropertyUsecase createPropertyUsecase;
  String type = AppStrings.UpcomingType;
  double notpaid = 0;
  // final List<PropertyModel> _models = demoPropertyModels;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerNumberController = TextEditingController();
  late List<TextEditingController> installmentsConttrollers = [];
  late List<DateTime?> installmentDates = [];
  DateTime firstInstallment = DateTime.now();
  DateTime lastInstallment = DateTime.now();
  final TextEditingController installmentsAmountController =
      TextEditingController();
  final TextEditingController installmentsDurationController =
      TextEditingController();

  DateTime contractDate = DateTime.now();
  DateTime submissionDate = DateTime.now();

  bool regularInstallmentsGenerated = false;

  bool descriptionError = false;
  bool priceError = false;
  bool paidAmountError = false;
  bool buyerNameError = false;
  bool buyerNumberError = false;
  bool priceValidationError = false;
  bool installmentError = false;

  AddPropertyCubit({required this.createPropertyUsecase})
      : super(AddPropertyState(error: true));

  void generateRegularInstallments() {
    if (lastInstallment.isAfter(firstInstallment)) {
      installmentsConttrollers = [];
      installmentDates = [];
      double installmentAmount =
          double.parse(installmentsAmountController.text.replaceAll(',', ''));
      print(lastInstallment.difference(firstInstallment).inDays);
      int numberOfInstallments =
          (lastInstallment.difference(firstInstallment).inDays /
                      int.parse(installmentsDurationController.text))
                  .ceil() +
              1;

      Duration installmentPeriod =
          Duration(days: int.parse(installmentsDurationController.text));

      for (int i = 0; i < numberOfInstallments; i++) {
        DateTime dueDate = firstInstallment.add(installmentPeriod * i);
        if (dueDate.isAfter(lastInstallment.add(Duration(days: 1)))) break;
        installmentsConttrollers.add(
          TextEditingController(
            text: installmentAmount.toString(),
          ),
        );
        installmentDates.add(dueDate);
        // installments
        //     .add(Installment(dueDate: dueDate, amount: installmentAmount));
      }
      regularInstallmentsGenerated = true;
      emit(state.copyWith(err: false));
    }
  }

  void selectFirstInstallment(DateTime date) {
    firstInstallment = date;
    emit(state.copyWith(err: false));
  }

  void selectLastInstallment(DateTime date) {
    lastInstallment = date;
    emit(state.copyWith(err: false));
  }

  void addInstallmentDate(DateTime date, int index) {
    installmentDates[index] = date;
    emit(state.copyWith(err: false));
  }

  List<DateTime?> getInstallmentDates(int number) {
    return List<DateTime?>.generate(number, (index) => null);
  }

  List<TextEditingController> getInstallmentControllers(int number) {
    return List<TextEditingController>.generate(
      number,
      (index) => TextEditingController(),
    );
  }

  void addInstallmentController() {
    installmentDates.add(null);
    installmentsConttrollers.add(TextEditingController());
    emit(state.copyWith(err: false));
  }

  void removeInstallment(int index) {
    installmentDates.removeAt(index);
    installmentsConttrollers.removeAt(index);
    emit(state.copyWith(err: false));
  }

  Future<PropertyModel?> addProperty() async {
    // emit(state.copyWith(err: true));
    //init variables
    final String description = descriptionController.text;
    final String price = priceController.text.replaceAll(',', '');
    final String paidAmount = paidAmountController.text.replaceAll(',', '');

    final String buyerName = buyerNameController.text;
    final String buyerNumber = buyerNumberController.text;
    //

    //
    description.isEmpty ? descriptionError = true : descriptionError = false;
    price.isEmpty ? priceError = true : priceError = false;
    paidAmount.isEmpty ? paidAmountError = true : paidAmountError = false;
    buyerName.isEmpty ? buyerNameError = true : buyerNameError = false;
    buyerNumber.isEmpty ? buyerNumberError = true : buyerNumberError = false;
    validatePrice();

    if (hasError()) {
      print("errror in the modal");
      emit(state.copyWith(err: true));
      return null;
    } else {
      List<Installment> installments = controllerToInstallments();
      final model = PropertyModel(
        id: "",
        installments: installments,
        type: type,
        description: description,
        price: double.parse(price),
        paid: double.parse(paidAmount),
        notPaid: notpaid,
        buyerName: buyerName,
        buyerNumber: buyerNumber,
        submissionDate: submissionDate,
        contractDate: contractDate,
      );
      await createPropertyUsecase(model);
      // print(
      //     "${model.description} ${model.price} ${model.paid} ${model.buyerName} ${model.buyerNumber} ${model.installments[1].date}");

      emit(state.copyWith(err: false));
      return model;

      // _models.add(model);
      // add property
    }
  }

  bool hasError() {
    return descriptionError ||
        priceValidationError ||
        priceError ||
        paidAmountError ||
        buyerNameError ||
        installmentError ||
        buyerNumberError;
  }

  void validatePrice() {
    double installmentsPrice = 0.0;
    installmentError = false;

    //Check if the user selected installment date
    // and validate all installments Prices
    for (int i = 0; i < installmentDates.length; i++) {
      if (installmentsConttrollers[i].text.isEmpty ||
          installmentDates[i] == null) {
        installmentError = true;
        break;
      }
      installmentsPrice +=
          double.parse(installmentsConttrollers[i].text.replaceAll(',', ''));
    }
    // installmentsConttrollers.forEach((inst) {
    //   if (inst.text.isEmpty) {
    //     installmentError = true;
    //     return;
    //   }
    //   installmentsPrice += double.parse(inst.text);
    // });

    // check if there is no form error
    if (priceError || paidAmountError) {
      priceValidationError = true;
      return;
    }

    //check that total price = instalmments + paid
    if (installmentsPrice +
            double.parse(paidAmountController.text.replaceAll(',', '')) !=
        double.parse(priceController.text.replaceAll(',', ''))) {
      priceValidationError = true;
    } else
      priceValidationError = false;
  }

  List<Installment> controllerToInstallments() {
    List<Installment> installments = [];

    for (int i = 0; i < installmentDates.length; i++) {
      if (installmentDates[i]!.isBefore(DateTime.now())) {
        type = AppStrings.NotPaidType;
        notpaid +=
            double.parse(installmentsConttrollers[i].text.replaceAll(',', ''));
      }
      installments.add(Installment(
          remindedOn: DateTime.now(),
          reminded: false,
          type: installmentDates[i]!.isBefore(DateTime.now())
              ? AppStrings.NotPaidType
              : AppStrings.UpcomingType,
          id: i.toString(),
          name: "Installment $i",
          date: installmentDates[i]!,
          amount: double.parse(
              installmentsConttrollers[i].text.replaceAll(',', ''))));
    }
    return installments;
  }

  DateTime getStartDate(index) {
    for (int i = index - 1; i >= 0; i--) {
      if (installmentDates[i] != null) {
        print("start date is ${installmentDates[i]}");
        return installmentDates[i]!;
      }
    }
    return DateTime(2000);
  }

  DateTime getEndDate(index) {
    for (int i = index + 1; i < installmentDates.length; i++) {
      if (installmentDates[i] != null) {
        print("start date is ${installmentDates[i]}");

        return installmentDates[i]!;
      }
    }
    return DateTime(2070);
  }
}
