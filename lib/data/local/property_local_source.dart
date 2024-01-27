import 'package:admin/data/models/property_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PropertyLocalSource {
  Future<List<PropertyModel>> getProperties() async {
    final List<PropertyModel> propertyModels;

    propertyModels = await _getAllPropertiess();
    return propertyModels;
  }

  Future<List<PropertyModel>> _getAllPropertiess() async {
    final Box box = await Hive.openBox<PropertyModel>("properties");
    final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
    // final List<PropertyModel> notPaidProperties = [];
    // final List<PropertyModel> upcomingProperties = [];

    // list.forEach((property) {
    //   if (property.getType() == AppStrings.NotPaidType) {
    //     notPaidProperties.add(property);
    //     // await _addNotPaidProperty(property);
    //   } else if (property.getType() == AppStrings.UpcomingType) {
    //     upcomingProperties.add(property);
    //   }
    // });
    // await _addNotPaidProperty(notPaidProperties);
    // await _addUpcomingProperty(upcomingProperties);
    // await box.close();
    return list;
  }

  Future<void> addProperties(List<PropertyModel> list) async {
    final Box box = await Hive.openBox<PropertyModel>("properties");
    // first clear all of the local data
    await box.clear();
    // insert all entries
    await box.addAll(list);

    // list.forEach((property) async {
    //   if (!box.containsKey(property.id)) {
    //     await box.put(property.id, property);
    //   }
    // });

    await box.close();
  }

// Future<List<PropertyModel>> _getPaidPropertiess() async {
//   final Box box = await Hive.openBox<PropertyModel>("Paidproperties");
//   final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
//   await box.close();
//   return list;
// }

// Future<List<PropertyModel>> _getUpcomingPropertiess() async {
//   final Box box = await Hive.openBox<PropertyModel>("Upcomingproperties");
//   final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;
//   // await box.close();
//   return list;
// }

// Future<void> _addNotPaidProperty(List<PropertyModel> list) async {
//   final Box box = await Hive.openBox<PropertyModel>("NotPaidproperties");
//   list.forEach((property) async {
//     if (!box.containsKey(property.id)) {
//       await box.put(property.id, property);
//     }
//   });

//   await box.close();
// }

// Future<void> _addUpcomingProperty(List<PropertyModel> list) async {
//   final Box box = await Hive.openBox<PropertyModel>("Upcomingproperties");
//   list.forEach((property) async {
//     if (!box.containsKey(property.id)) {
//       await box.put(property.id, property);
//     }
//   });

//   await box.close();
// }

// Future<List<PropertyModel>> _getNotPaidPropertiess() async {
//   final Box box = await Hive.openBox<PropertyModel>("Notpaidproperties");
//   final List<PropertyModel> list = box.values.toList() as List<PropertyModel>;

//   // await box.close();
//   return list;
// }

// Future<void> addProperties(List<PropertyModel> list) async {
//   final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
//   await propertyBox.addAll(list);
//   print("added sucesssfuly");
//   // await propertyBox.close();
// }

  Future<void> clearProperties() async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    // final Box notpaidBox =
    //     await Hive.openBox<PropertyModel>("Notpaidproperties");
    // final Box upcomingBox =
    //     await Hive.openBox<PropertyModel>("Upcomingproperties");

    await propertyBox.clear();
    // await notpaidBox.clear();
    await propertyBox.close();
    // await notpaidBox.close();
    // await upcomingBox.clear();
    // await upcomingBox.close();
  }

  Future<void> updateNotPaid(List<PropertyModel> properties) async {
    final Box upcomingbox =
        await Hive.openBox<PropertyModel>("Upcomingproperties");
    final Box notpaidbox =
        await Hive.openBox<PropertyModel>("Notpaidproperties");

    properties.forEach((property) async {
      if (upcomingbox.containsKey(property.id)) {
        await upcomingbox.delete(property.id);
        await notpaidbox.put(property.id, property);
      }
    });
    await notpaidbox.close();
    await upcomingbox.close();
  }

  Future<void> removeAllBoxes() async {
    // Close all open boxes before deleting
    await Hive.close();

    // Delete the entire Hive storage directory
    await Hive.deleteBoxFromDisk('properties');

    await Hive.deleteFromDisk();
  }
}
