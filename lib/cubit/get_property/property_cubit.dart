import 'package:admin/data/local/property_local_source.dart';
import 'package:admin/data/models/dummy.dart';
// import 'package:admin/data/models/dummy.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/create_property_usecase.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/property_usecase.dart';
import 'package:admin/domain/Usecases/usecase.dart';
// import 'package:admin/domain/Usecases/usecase.dart';
import 'package:admin/resources/Managers/assets_manager.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final GetProperties getProperties;
  final SetNotPaidUsecase setNotPaidUsecase;
  final TextEditingController searchController = TextEditingController();
  late int filterOption = 1;
  String filterQuery = "";

  final PropertyLocalSource localSource = PropertyLocalSource();
  int selectedCategory = -1;
  Color categoryColor = ColorManager.PrimaryColor;
  String icon = AssetsManager.AllPropertiesIcon;
  List<PropertyModel> properties = [];
  List<PropertyModel> notPaidproperties = [];
  List<PropertyModel> upcomingproperties = [];
  List<PropertyModel> paidproperties = [];
  List<PropertyModel> unsoldproperties = [];

  double totalAmount = 0;
  double paidAmount = 0;
  double notPaidAmount = 0;

  bool loading = false;
  bool hasError = false;
  String error = '';

  bool ascending = true;
  String sortBy = "Default";
  PropertyCubit({required this.getProperties, required this.setNotPaidUsecase})
      : super(PropertyState(properties: []));

  void toggleSort() {
    ascending = !ascending;
    getPropertiesByCategory(index: selectedCategory);
  }

  void selectSortCriteria(String critertia) async {
    sortBy = critertia;
    await getPropertiesByCategory(index: selectedCategory);
  }

  List<PropertyModel> sortProperties(List<PropertyModel> list) {
    int order = ascending ? 1 : -1; // 1 for ascending, -1 for descending

    list.sort(
      (a, b) {
        switch (sortBy) {
          case AppStrings.SortByPrice:
            return order * a.price.compareTo(b.price);
          case AppStrings.SortByPaidAmount:
            return order * a.paid.compareTo(b.paid);
          case AppStrings.SortByPaidPercentage:
            return order * (a.price - a.paid).compareTo(b.price - b.paid);
          case AppStrings.SortByDate:
            return order * a.price.compareTo(b.price);
          default:
            return 1;
        }
      },
    );
    return list;
  }

  List<PropertyModel> paginate(List<PropertyModel> list, int pagination) {
    int step = 50;
    int start = 0;
    int end = step * pagination;
    if (end > list.length) end = list.length;
    return list.sublist(start, end);
  }

  Future<void> getPropertiesByCategory(
      {int index = 0, int pagination = 1}) async {
    loading = true;
    error = "";
    // int step = 50;
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
          List<PropertyModel> list = applyFilter(properties);
          list = sortProperties(list);
          list = paginate(list, pagination);
          // print(end);
          emit(state.copyWith(list: list));
          return;
        case 1:
          // paidproperties = await localSource.getProperties(1);

          selectedCategory = 1;
          icon = AssetsManager.PaidPropertiesIcon;
          categoryColor = ColorManager.Green;
          loading = false;
          hasError = false;
          // properties = list;
          List<PropertyModel> list = applyFilter(paidproperties);
          list = sortProperties(list);
          list = paginate(list, pagination);

          emit(state.copyWith(list: list));
          return;
        case 2:
          // upcomingproperties = await localSource.getProperties(2);

          selectedCategory = 2;
          icon = AssetsManager.UpcomingPropertiesIcon;
          categoryColor = ColorManager.Orange;
          loading = false;
          hasError = false;
          // properties = list;
          List<PropertyModel> list = applyFilter(upcomingproperties);
          list = sortProperties(list);
          list = paginate(list, pagination);

          emit(state.copyWith(list: list));
          return;
        case 3:
          // notPaidproperties = await localSource.getProperties(3);

          selectedCategory = 3;
          categoryColor = ColorManager.error;
          icon = AssetsManager.NotPaidPropertiesIcon;
          loading = false;
          hasError = false;
          // properties = list;
          List<PropertyModel> list = applyFilter(notPaidproperties);
          list = sortProperties(list);
          list = paginate(list, pagination);

          emit(state.copyWith(list: list));
          return;
        case 4:
          //  TO BE REMOVED IN PRODUCTION
          // notPaidproperties = await localSource.getProperties(3);

          selectedCategory = 4;
          categoryColor = ColorManager.DarkGrey;
          icon = AssetsManager.AllPropertiesIcon;
          loading = false;
          hasError = false;
          // properties = list;
          List<PropertyModel> list = applyFilter(unsoldproperties);
          list = sortProperties(list);
          list = paginate(list, pagination);

          emit(state.copyWith(list: list));
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

  Future<void> setFilterQuery(String text) async {
    filterQuery = text;
    await getPropertiesByCategory(
      index: selectedCategory,
    );
  }

  List<PropertyModel> applyFilter(List<PropertyModel> list) {
    RegExp regExp = RegExp(filterQuery.toLowerCase().split('').join('.*'));

    switch (filterOption) {
      case 1:
        return list.where((property) {
          return regExp.hasMatch(property.description.toLowerCase());
        }).toList();
      case 2:
        return list.where((property) {
          return regExp.hasMatch(property.buyerName.toLowerCase());
        }).toList();
      case 3:
        return list.where((property) {
          return property.buyerNumber
              .toUpperCase()
              .contains(filterQuery.toUpperCase());
        }).toList();
    }
    return list;
  }

  Future<void> fetchData() async {
    loading = true;
    hasError = false;
    error = "";

    // await localSource.removeAllBoxes();
    // await localSource.clearProperties();
    // await localSource.addProperties(getRandomData());
    try {
      // List<PropertyModel> list = await localSource.getProperties();

      final result = await getProperties(NoParams());
      List<PropertyModel> list =
          result.fold((failure) => properties, (data) => data);
      properties = list;
      // upcomingproperties = [];
      // notPaidproperties = [];
      // paidproperties = [];

      await categorize();

      // properties.forEach((property) {
      //   if (property.getType() == AppStrings.PaidType)
      //     paidproperties.add(property);
      //   else if (property.getType() == AppStrings.UpcomingType)
      //     upcomingproperties.add(property);
      //   else if (property.getType() == AppStrings.NotPaidType)
      //     notPaidproperties.add(property);
      // });
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

  void updateProperty(PropertyModel model) {
    properties.removeWhere((property) => property.id == model.id);
    properties.add(model);
  }

  Future<void> categorize() async {
    upcomingproperties = [];
    notPaidproperties = [];
    paidproperties = [];
    paidAmount = 0;
    notPaidAmount = 0;
    totalAmount = 0;

    properties.forEach((property) {
      totalAmount += property.price;
      paidAmount += property.paid;
      if (property.getType() == AppStrings.PaidType) {
        paidproperties.add(property);
      } else if (property.getType() == AppStrings.UpcomingType)
        upcomingproperties.add(property);
      else if (property.getType() == AppStrings.NotPaidType) {
        notPaidproperties.add(property);
        notPaidAmount += property.notPaid;
      }
    });
    getPropertiesByCategory(index: selectedCategory);
  }

  Future<bool> checkNotPaid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('storedDate', "");

    // Get the stored date (if available)
    String storedDate = prefs.getString('storedDate') ?? '';

    // Get the current date
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    // Check if it's a new day
    if (currentDate != storedDate) {
      List<int> notPaidIndices = [];
      List<SetNotPaidParams> notpaidList = [];
      print("must find not paid");
      bool found = false;
      for (PropertyModel property in notPaidproperties) {
        int index = 0;
        for (Installment installment in property.installments) {
          if (installment.date.compareTo(DateTime.now()) <= 0) {
            if (installment.getType() == AppStrings.UpcomingType) {
              notPaidIndices.add(index);
              installment.setType(AppStrings.NotPaidType);
              property.notPaid += installment.amount;
              notPaidAmount += installment.amount;
              found = true;
            }
          } else {
            break;
          }
          index++;
        }
        if (found) {
          notpaidList.add(SetNotPaidParams(
            notPaidIndices: notPaidIndices,
            model: property,
          ));
        }

        // found? then we must update the not paid array
      }
      upcomingproperties.removeWhere((property) {
        List<int> indices = property.isNotPaid();
        if (indices.isNotEmpty) {
          print("Found Not paid property");
          // property.setType(AppStrings.NotPaidType);
          notPaidAmount += property.notPaid;
          notPaidproperties.add(property);

          notpaidList.add(SetNotPaidParams(
            notPaidIndices: notPaidIndices,
            model: property,
          ));
          return true;
        }
        return false;
      });

      if (notpaidList.isNotEmpty) await setNotPaidUsecase(notpaidList);

      // Execute your function here

      // Update the stored date
      await prefs.setString('storedDate', currentDate);
    }

    return false;
  }

  void addProperty(PropertyModel model) {
    properties.add(model);
  }

  // double calculateAllProperties() {
  //   double price = 0;
  //   properties.forEach((property) {
  //     price += property.price;
  //   });
  //   return price;
  // }

  // double calculatePaidProperties() {
  //   double price = 0;
  //   properties.forEach((property) {
  //     price += property.paid;
  //   });
  //   return price;
  // }

  // double calculateNotPaidProperties() {
  //   double price = 0;
  //   notPaidproperties.forEach((property) {
  //     price += property.calculateNotPaidInstallments();
  //   });
  //   return price;
  // }

  // double calculateUpcomingProperties() {
  //   double price = 0;
  //   properties.forEach((property) {
  //     price += property.price -
  //         property.paid -
  //         property.calculateNotPaidInstallments();
  //   });
  //   return price;
  // }
}
