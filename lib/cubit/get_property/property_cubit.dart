import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/property_usecase.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final GetProperties getProperties;
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
  PropertyCubit({required this.getProperties})
      : super(PropertyState(properties: []));

  Future<void> getPropertiesByCategory(int index) async {
    loading = true;
    error = "";
    try {
      // await localSource.clearProperties();
      // await localSource.addProperties(demoPropertyModels);
      // final List<PropertyModel> list = [];
      switch (index) {
        case 0:
          // properties = await localSource.getProperties(0);

          selectedCategory = 0;
          icon = AssetsManager.AllPropertiesIcon;
          // properties = list;
          categoryColor = ColorManager.PrimaryColor;
          loading = false;
          hasError = false;
          emit(state.copyWith(list: properties));
          return;
        case 1:
          // paidproperties = await localSource.getProperties(1);

          selectedCategory = 1;
          icon = AssetsManager.PaidPropertiesIcon;
          categoryColor = ColorManager.Green;
          loading = false;
          hasError = false;
          // properties = list;

          emit(state.copyWith(list: paidproperties));
          return;
        case 2:
          // upcomingproperties = await localSource.getProperties(2);

          selectedCategory = 2;
          icon = AssetsManager.UpcomingPropertiesIcon;
          categoryColor = ColorManager.Orange;
          loading = false;
          hasError = false;
          // properties = list;

          emit(state.copyWith(list: upcomingproperties));
          return;
        case 3:
          // notPaidproperties = await localSource.getProperties(3);

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

  Future<void> fetchData() async {
    loading = true;
    hasError = false;
    error = "";

    // await localSource.removeAllBoxes();
    // await localSource.clearProperties();
    // await localSource.addProperties(demoPropertyModels);
    try {
      late List<PropertyModel> list = [];
      final result = await getProperties(NoParams());
      list = result.fold((failure) => properties, (data) => data);
      properties = list;
      upcomingproperties = [];
      notPaidproperties = [];
      paidproperties = [];

      properties.forEach((property) {
        if (property.getType() == AppStrings.PaidType)
          paidproperties.add(property);
        else if (property.getType() == AppStrings.UpcomingType)
          upcomingproperties.add(property);
        else if (property.getType() == AppStrings.NotPaidType)
          notPaidproperties.add(property);
      });
      // properties = list;
      // list = await localSource.getProperties(1);
      // paidproperties = list;
      // list = await localSource.getProperties(2);
      // upcomingproperties = list;
      await checkNotPaid();

      // upcomingproperties = list;
      // list = await localSource.getProperties(3);
      // notPaidproperties.addAll(list);
      emit(state.copyWith(list: []));
    } catch (err) {
      loading = false;
      hasError = true;
      error = err.toString();
      emit(state.copyWith(list: []));
    }
  }

  Future<bool> checkNotPaid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // await prefs.setString('storedDate', "");

    // Get the stored date (if available)
    String storedDate = prefs.getString('storedDate') ?? '';

    // Get the current date
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    // Check if it's a new day
    if (currentDate != storedDate) {
      // List<PropertyModel> notPaid = [];
      upcomingproperties.removeWhere((property) {
        if (property.isNotPaid()) {
          print("Found Not paid property");
          property.setType(AppStrings.NotPaidType);
          notPaidproperties.add(property);

          // notPaid.add(property);
          return true;
        }
        return false;
      });

      // if (notPaid.isNotEmpty) await localSource.updateNotPaid(notPaid);
      // Execute your function here

      // Update the stored date
      await prefs.setString('storedDate', currentDate);
    }

    return false;
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
    properties.forEach((property) {
      price += double.parse(property.paid);
    });
    return price.toString();
  }

  String calculateNotPaidProperties() {
    double price = 0;
    notPaidproperties.forEach((property) {
      price += property.calculateNotPaidInstallments();
    });
    return price.toString();
  }

  String calculateUpcomingProperties() {
    double price = 0;
    properties.forEach((property) {
      price += double.parse(property.price) -
          double.parse(property.paid) -
          property.calculateNotPaidInstallments();
    });
    return price.toString();
  }
}
