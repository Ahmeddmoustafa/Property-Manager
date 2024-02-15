import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(ScrollState());
  final ScrollController propertiesScrollController = ScrollController();
  bool loading = false;
  int page = 1;

  // void updateHover(int index) {
  //   hoveredIndex = index;
  //   emit(state.copyWith());
  // }
}
