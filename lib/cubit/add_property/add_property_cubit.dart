import 'package:admin/data/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  // final List<PropertyModel> _models = demoPropertyModels;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerNumberController = TextEditingController();
  late List<TextEditingController> installmentsConttrollers =
      getInstallmentControllers(5);
  late List<DateTime?> installmentDates = getInstallmentDates(5);

  AddPropertyCubit() : super(AddPropertyInitial());

  void addInstallmentDate(DateTime date, int index) {
    installmentDates.insert(index, date);
    emit(AddPropertyLoading());
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
    emit(AddPropertyLoading());
  }

  void removeInstallment(int index) {
    installmentDates.removeAt(index);
    installmentsConttrollers.removeAt(index);
    emit(AddPropertyLoading());
  }

  void addProperty() {
    // emit(AddPropertyLoading());
    //init variables
    final String description = descriptionController.text;
    final String price = priceController.text.replaceAll(',', '');
    final String paidAmount = paidAmountController.text.replaceAll(',', '');
    final String buyerName = buyerNameController.text;
    final String buyerNumber = buyerNumberController.text;
    //
    bool descriptionError = false;
    bool priceError = false;
    bool paidAmountError = false;
    bool buyerNameError = false;
    bool buyerNumberError = false;
    //
    description.isEmpty ? descriptionError = true : descriptionError = false;
    price.isEmpty ? priceError = true : priceError = false;
    paidAmount.isEmpty ? paidAmountError = true : paidAmountError = false;
    buyerName.isEmpty ? buyerNameError = true : buyerNameError = false;
    buyerNumber.isEmpty ? buyerNumberError = true : buyerNumberError = false;

    if (descriptionError ||
        priceError ||
        paidAmountError ||
        buyerNameError ||
        buyerNumberError) {
      print("property error");
      emit(AddPropertyError());
    } else {
      final model = PropertyModel(
        id: "5",
        description: description,
        price: price,
        paid: paidAmount,
        buyerName: buyerName,
        buyerNumber: buyerNumber,
        installments: [],
      );
      print(model);

      emit(PropertyAdded(propertyModel: model));

      // _models.add(model);
      // add property
    }
  }
}
