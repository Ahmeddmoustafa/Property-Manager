import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
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
  bool loading = false;
  int lastActiveIndex = 0;
  int newActiveIndices = 0;

  PropertyModalCubit({required this.updatePropertyUsecase})
      : super(PropertyModalState(property: null));

  void openPropety(PropertyModel propertyModel) {
    property = propertyModel;
    emit(state.copyWith(prop: property!));
  }

  void payInstallment(int installmentIndex) {
    final Installment installment = property!.installments[installmentIndex];
    if (property != null) {
      if (installmentIndex ==
          property!.lastActiveIndex + 1 + newActiveIndices) {
        newActiveIndices++;
        print("new indices added $newActiveIndices");
      }
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
    loading = true;
    emit(state.copyWith(prop: property!));

    await Future.delayed(Duration(seconds: 1), () {});

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
      property!.lastActiveIndex += newActiveIndices;
      final result = await updatePropertyUsecase(
        UpdatePropertyParams(
          model: property!,
          propertyId: property!.id,
          updatedData: {
            'price': property!.price,
            'paid': property!.paid,
            'notpaid': property!.notPaid,
            'type': property!.type,
            'installments': getupdatedIndicesData(),
            'lastActiveIndex': property!.lastActiveIndex
          },
        ),
      );
      result.fold((f) {
        success = false;
      }, (r) {
        success = true;
      });
      loading = false;
      reset();
    }
    return success;
  }

  List<Map<String, dynamic>> getupdatedIndicesData() {
    List<Map<String, dynamic>> data = [];
    for (int index in paidInstallmentsIndex) {
      data.add({
        "index": index,
        "type": AppStrings.PaidType,
      });
    }
    return data;
  }

  Map<String, dynamic> getUpdatedInfo() {
    Map<String, dynamic> fields = {
      "paid": property!.paid,
      "notpaid": property!.notPaid,
      "type": property!.type,
    };
    paidInstallmentsIndex.forEach((index) {
      fields.addAll({"installments.$index.type": AppStrings.PaidType});
    });
    return fields;
  }

  void reset() {
    paidInstallments = [];
    paidInstallmentsIndex = [];
    upcomingToPaid = 0.0;
    notpaidToPaid = 0.0;
    newActiveIndices = 0;
    emit(state.copyWith(prop: property!));
  }

  void setLastActiveIndex(PropertyModel model) {
    final DateTime nowDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    int index = 0;
    for (Installment inst in model.installments) {
      print('loop');

      if (inst.date.isAfter(nowDate)) {
        lastActiveIndex = index;
        return;
      }
      index++;
    }
  }
}
