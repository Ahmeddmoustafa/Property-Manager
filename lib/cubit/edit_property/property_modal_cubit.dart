import 'package:admin/data/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'property_modal_state.dart';

class PropertyModalCubit extends Cubit<PropertyModalCubitState> {
  PropertyModel? property;
  late List<Installment> paidInstallments = [];
  PropertyModalCubit() : super(PropertyModalCubitState(property: null));

  void openPropety(PropertyModel propertyModel) {
    property = propertyModel;
    emit(state.copyWith(prop: property!));
  }

  void payInstallment(PropertyModel property, int installmentIndex) {
    print("user paid ${property.installments[installmentIndex].name}");
    paidInstallments.add(property.installments[installmentIndex]);
  }
}
