import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stepper_state.dart';

class StepperCubit extends Cubit<StepperState> {
  StepperCubit() : super(StepperState());
  bool opened = false;
  // int lastActiveIndex = 0;

  openStepper() {
    opened = !opened;
    emit(state.copyWith());
  }

  // void setLastActiveIndex(PropertyModel model) {
  //   final DateTime nowDate = DateTime(
  //       DateTime.now().year, DateTime.now().month, DateTime.now().month);
  //   int index = 0;
  //   for (Installment inst in model.installments) {
  //     if (inst.date.isAfter(nowDate)) {
  //       lastActiveIndex = index;
  //       return;
  //     }
  //     index++;
  //   }
  // }

  Color getStepperColor(List<Installment> installments) {
    Color color = ColorManager.Green;
    for (var installment in installments) {
      if (installment.getType() == AppStrings.NotPaidType) {
        color = ColorManager.error;
        break;
      } else if (installment.getType() == AppStrings.UpcomingType) {
        color = ColorManager.Orange;
      }
    }
    return color;
  }
}
