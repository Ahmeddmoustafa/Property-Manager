import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final TextEditingController searchController = TextEditingController();
  late int filterOption = 1;

  final PropertyLocalSource localSource = PropertyLocalSource();
  int selectedCategory = -1;
  Color categoryColor = ColorManager.PrimaryColor;
  String icon = AssetsManager.AllPropertiesIcon;
  List<PropertyModel> properties = [];
  bool loading = false;
  bool hasError = false;
  String error = '';
  PropertyCubit() : super(PropertyState(properties: []));

  void getProperties(int index) async {
    loading = true;
    try {
      // await localSource.addProperties(demoPropertyModels);
      final List<PropertyModel> list = await localSource.getProperties();
      // final List<PropertyModel> list = [];
      switch (index) {
        case 0:
          selectedCategory = 0;
          icon = AssetsManager.AllPropertiesIcon;
          properties = list;
          categoryColor = ColorManager.PrimaryColor;
          loading = false;
          hasError = false;
          emit(state.copyWith(list: list));
          return;
        case 1:
          selectedCategory = 1;
          icon = AssetsManager.PaidPropertiesIcon;
          categoryColor = ColorManager.Green;
          loading = false;
          hasError = false;
          properties = list;

          emit(state.copyWith(list: list));
          return;
        case 2:
          selectedCategory = 2;
          icon = AssetsManager.UpcomingPropertiesIcon;
          categoryColor = ColorManager.Orange;
          loading = false;
          hasError = false;
          properties = list;

          emit(state.copyWith(list: list));
          return;
        case 3:
          selectedCategory = 3;
          categoryColor = ColorManager.error;
          icon = AssetsManager.NotPaidPropertiesIcon;
          loading = false;
          hasError = false;
          properties = list;

          emit(state.copyWith(list: list));
          return;
      }
    } catch (err) {
      hasError = true;
      error = err.toString();
      emit(state.copyWith(list: []));

      // emit(PropertyFailed());
    }
  }

  void setFilter(int filter) {
    filterOption = filter;
    // emit(state.copyWith(list: properties));
  }

  void applyFilter(String filterText) {
    switch (filterOption) {
      case 1:
        emit(state.copyWith(
            list: properties.where((property) {
          return property.description
              .toUpperCase()
              .contains(filterText.toUpperCase());
        }).toList()));
        return;
      case 2:
        emit(state.copyWith(
            list: properties.where((property) {
          return property.buyerName
              .toUpperCase()
              .contains(filterText.toUpperCase());
        }).toList()));
        return;
      case 3:
        emit(state.copyWith(
            list: properties.where((property) {
          return property.buyerNumber
              .toUpperCase()
              .contains(filterText.toUpperCase());
        }).toList()));
        return;
    }
  }
}
