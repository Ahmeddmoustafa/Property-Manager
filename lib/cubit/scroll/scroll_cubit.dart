import 'package:admin/data/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(ScrollState());
  ScrollController propertiesScrollController = ScrollController();
  List<PropertyModel> properties = [];
  bool loading = false;
  int page = 1;
  int step = 50;

  void toogleLoading() {
    loading = !loading;
    emit(state.copyWith());
  }

  bool incrementPagination() {
    if (page * step > properties.length) {
      return false;
    }
    page++;
    return true;
  }

  // void updateHover(int index) {
  //   hoveredIndex = index;
  //   emit(state.copyWith());
  // }
}
