import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/paid_usecase.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'property_modal_state.dart';

class PropertyModalCubit extends Cubit<PropertyModalState> {
  final UpdatePropertyUsecase updatePropertyUsecase;
  PropertyModel? property;
  late List<Installment> paidInstallments = [];
  late List<int> paidInstallmentsIndex = [];
  late double upcomingToPaid = 0.0;
  late double notpaidToPaid = 0.0;
  PropertyModalCubit({required this.updatePropertyUsecase})
      : super(PropertyModalState(property: null));

  void openPropety(PropertyModel propertyModel) {
    property = propertyModel;
    emit(state.copyWith(prop: property!));
  }

  void payInstallment(int installmentIndex) {
    final Installment installment = property!.installments[installmentIndex];
    if (property != null) {
      print("user paid ${installment.name}");
      paidInstallments.add(installment);
      paidInstallmentsIndex.add(installmentIndex);
      if (installment.getType() == AppStrings.UpcomingType)
        upcomingToPaid += installment.amount;
      else if (installment.getType() == AppStrings.NotPaidType)
        notpaidToPaid += installment.amount;
      // property!.installments[installmentIndex].payInstallment();
      emit(state.copyWith(prop: property!));
    }
  }

  bool isPaid(int index) {
    return paidInstallmentsIndex.contains(index);
  }

  Future<bool> saveProperty() async {
    bool success = true;
    if (property != null) {
      paidInstallmentsIndex.forEach((index) {
        Installment installment = property!.installments[index];
        property!.paid += installment.amount;

        installment.getType() == AppStrings.NotPaidType
            ? property!.notPaid = property!.notPaid - installment.amount
            : null;
        installment.payInstallment();
      });
      property!.updateType();

      print(property!.getType());
      reset();
      // final result = await updatePropertyUsecase(property!);
      // result.fold((f) {
      //   success = false;
      // }, (r) {
      //   success = true;
      // });
    }
    return success;
  }

  void reset() {
    paidInstallments = [];
    paidInstallmentsIndex = [];
    upcomingToPaid = 0.0;
    notpaidToPaid = 0.0;
    emit(state.copyWith(prop: property!));
  }
}
