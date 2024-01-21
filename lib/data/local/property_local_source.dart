import 'package:admin/data/models/property_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PropertyLocalSource {
  Future<List<PropertyModel>> getProperties(int index) async {
    final List<PropertyModel> propertyModels;
    switch (index) {
      case 0:
        propertyModels = await _getAllPropertiess();
        // print("number of properties ${propertyModels.length}");

        return propertyModels;

      case 1:
        propertyModels = await _getPaidPropertiess();
        // print("number of properties ${propertyModels.length}");

        return propertyModels;

      case 2:
        propertyModels = await _getUpcomingPropertiess();
        // print("number of properties ${propertyModels.length}");

        return propertyModels;

      case 3:
        propertyModels = await _getNotPaidPropertiess();
        return propertyModels;
    }
    propertyModels = await _getAllPropertiess();
    return propertyModels;

    // final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    // final List<PropertyModel> propertyModels =
    //     propertyBox.values.toList() as List<PropertyModel>;
    // print("number of properties ${propertyModels.length}");
  }

  Future<List<PropertyModel>> _getAllPropertiess() async {
    final Box box = await Hive.openBox<PropertyModel>("properties");
    final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
    final List<PropertyModel> notPaidProperties = [];
    list.forEach((property) async {
      if (property.isNotPaid()) {
        notPaidProperties.add(property);
        // await _addNotPaidProperty(property);
      }
    });
    await _addNotPaidProperty(notPaidProperties);
    await box.close();
    return list;
  }

  Future<List<PropertyModel>> _getPaidPropertiess() async {
    final Box box = await Hive.openBox<PropertyModel>("Paidproperties");
    final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
    await box.close();
    return list;
  }

  Future<List<PropertyModel>> _getUpcomingPropertiess() async {
    final Box box = await Hive.openBox<PropertyModel>("Upcomingproperties");
    final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
    await box.close();
    return list;
  }

  Future<void> _addNotPaidProperty(List<PropertyModel> list) async {
    final Box box = await Hive.openBox<PropertyModel>("NotPaidproperties");
    list.forEach((property) async {
      if (!box.containsKey(property.id)) {
        await box.put(property.id, property);
      }
    });

    await box.close();
  }

  Future<List<PropertyModel>> _getNotPaidPropertiess() async {
    final Box box = await Hive.openBox<PropertyModel>("Notpaidproperties");
    final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
    print("number of notpaidproperties ${list.length}");

    await box.close();
    return list;
  }

  Future<void> addProperties(List<PropertyModel> list) async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    await propertyBox.addAll(list);
    await propertyBox.close();
  }

  Future<void> clearProperties() async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    final Box notpaidBox =
        await Hive.openBox<PropertyModel>("Notpaidproperties");

    await propertyBox.clear();
    await notpaidBox.clear();
    await propertyBox.close();
    await notpaidBox.close();
  }
}
