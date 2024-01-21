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
  List<PropertyModel> notPaidproperties = [];
  List<PropertyModel> upcomingproperties = [];
  List<PropertyModel> paidproperties = [];

  bool loading = false;
  bool hasError = false;
  String error = '';
  PropertyCubit() : super(PropertyState(properties: []));

  void getPropertiesByCategory(int index) async {
    loading = true;
    error = "";
    try {
      // await localSource.clearProperties();
      // await localSource.addProperties(demoPropertyModels);
      // final List<PropertyModel> list = [];
      switch (index) {
        case 0:
          properties = await localSource.getProperties(0);

          selectedCategory = 0;
          icon = AssetsManager.AllPropertiesIcon;
          // properties = list;
          categoryColor = ColorManager.PrimaryColor;
          loading = false;
          hasError = false;
          emit(state.copyWith(list: properties));
          return;
        case 1:
          paidproperties = await localSource.getProperties(1);

          selectedCategory = 1;
          icon = AssetsManager.PaidPropertiesIcon;
          categoryColor = ColorManager.Green;
          loading = false;
          hasError = false;
          // properties = list;

          emit(state.copyWith(list: paidproperties));
          return;
        case 2:
          upcomingproperties = await localSource.getProperties(2);

          selectedCategory = 2;
          icon = AssetsManager.UpcomingPropertiesIcon;
          categoryColor = ColorManager.Orange;
          loading = false;
          hasError = false;
          // properties = list;

          emit(state.copyWith(list: upcomingproperties));
          return;
        case 3:
          notPaidproperties = await localSource.getProperties(3);

          selectedCategory = 3;
          categoryColor = ColorManager.error;
          icon = AssetsManager.NotPaidPropertiesIcon;
          loading = false;
          hasError = false;
          // properties = list;

          emit(state.copyWith(list: notPaidproperties));
          return;
      }
    } catch (err) {
      loading = false;
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

  void fetchData() async {
    loading = true;
    hasError = false;
    error = "";

    late List<PropertyModel> list = [];
    try {
      list = await localSource.getProperties(0);
      properties = list;
      list = await localSource.getProperties(1);
      paidproperties = list;
      list = await localSource.getProperties(2);
      upcomingproperties = list;
      list = await localSource.getProperties(3);
      notPaidproperties = list;
      emit(state.copyWith(list: []));
    } catch (err) {
      loading = false;
      hasError = true;
      error = err.toString();
      emit(state.copyWith(list: []));
    }
  }

  String calculateAllProperties() {
    double price = 0;
    properties.forEach((property) {
      price += double.parse(property.price);
    });
    return price.toString();
  }

  String calculatePaidProperties() {
    double price = 0;
    paidproperties.forEach((property) {
      price += double.parse(property.price);
    });
    return price.toString();
  }

  String calculateNotPaidProperties() {
    double price = 0;
    notPaidproperties.forEach((property) {
      price += double.parse(property.price);
    });
    return price.toString();
  }

  String calculateUpcomingProperties() {
    double price = 0;
    upcomingproperties.forEach((property) {
      price += double.parse(property.price);
    });
    return price.toString();
  }
}
