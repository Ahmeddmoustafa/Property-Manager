import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stepper_state.dart';

class StepperCubit extends Cubit<StepperState> {
  StepperCubit() : super(StepperState());
  bool opened = false;

  openStepper() {
    opened = !opened;
    emit(state.copyWith());
  }

  Color getStepperColor(List<Installment> installments) {
    Color color = ColorManager.Green;
    for (var installment in installments) {
      if (installment.getType() == AppStrings.NotPaidType) {
        print("found not paid");
        print(color);
        color = ColorManager.error;
        break;
      } else if (installment.getType() == AppStrings.UpcomingType) {
        color = ColorManager.Orange;
      }
    }
    print("got out of the loop");
    print(color);
    return color;
  }
}
