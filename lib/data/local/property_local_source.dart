import 'package:admin/data/models/property_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PropertyLocalSource {
  Future<List<PropertyModel>> getProperties() async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    final List<PropertyModel> propertyModels =
        propertyBox.values.toList() as List<PropertyModel>;
    print("number of properties ${propertyModels.length}");
    await propertyBox.close();

    return propertyModels;
  }

  Future<void> addProperties(List<PropertyModel> list) async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    await propertyBox.addAll(list);
    await propertyBox.close();
  }

  Future<void> clearProperties() async {
    final Box propertyBox = await Hive.openBox<PropertyModel>("properties");
    await propertyBox.clear();
    await propertyBox.close();
  }
}
