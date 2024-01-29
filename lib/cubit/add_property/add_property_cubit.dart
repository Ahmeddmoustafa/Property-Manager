import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/create_property_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  final CreatePropertyUsecase createPropertyUsecase;
  // final List<PropertyModel> _models = demoPropertyModels;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerNumberController = TextEditingController();
  late List<TextEditingController> installmentsConttrollers =
      getInstallmentControllers(5);
  late List<DateTime?> installmentDates = getInstallmentDates(5);
  DateTime contractDate = DateTime.now();
  DateTime submissionDate = DateTime.now();

  bool descriptionError = false;
  bool priceError = false;
  bool paidAmountError = false;
  bool buyerNameError = false;
  bool buyerNumberError = false;
  bool priceValidationError = false;
  bool installmentError = false;

  AddPropertyCubit({required this.createPropertyUsecase})
      : super(AddPropertyState(error: true));

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

  Future<void> addProperty() async {
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
      return;
    } else {
      final model = PropertyModel(
        id: "",
        description: description,
        price: double.parse(price),
        paid: double.parse(paidAmount),
        notPaid: 0,
        buyerName: buyerName,
        buyerNumber: buyerNumber,
        installments: controllerToInstallments(),
        submissionDate: DateTime.now(),
        contractDate: DateTime.now(),
      );
      await createPropertyUsecase(model);
      // print(
      //     "${model.description} ${model.price} ${model.paid} ${model.buyerName} ${model.buyerNumber} ${model.installments[1].date}");

      emit(state.copyWith(err: false));

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
      installments.add(Installment(
          reminded: false,
          id: i.toString(),
          name: "Installment $i",
          date: installmentDates[i]!,
          amount: double.parse(
              installmentsConttrollers[i].text.replaceAll(',', ''))));
    }
    return installments;
  }
}
