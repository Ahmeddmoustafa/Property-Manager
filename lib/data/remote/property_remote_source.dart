import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyRemoteSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Create new property
  Future<PropertyModel> createProperty(PropertyModel property) async {
    final String id = _firestore
        .collection("allproperties")
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("properties")
        .doc()
        .id;

    property.id = id;

    await _firestore
        .collection("allproperties")
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("properties")
        .doc(id)
        .set(property.toJson());
    return property;
  }

  //Overwrites the property data in the Firebase
  Future<void> updateProperty(UpdatePropertyParams params) async {
    DocumentReference docRef = _firestore
        .collection("allproperties")
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("properties")
        .doc(params.model.id);

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> installments = data['installments'];

      params.updatedIndices.forEach((index) {
        installments[index]["type"] = AppStrings.PaidType;
      });

      data["installments"] = installments;
      data["paid"] = params.model.paid;
      data["notpaid"] = params.model.notPaid;
      data["type"] = params.model.type;

      // Get the installment array from the data
      await docRef.update(data);
    }
  }

  Future<void> setPropertyNotPaid(SetNotPaidParams params) async {
    DocumentReference docRef = _firestore
        .collection("allproperties")
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("properties")
        .doc(params.model.id);

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> installments = data['installments'];

      params.notPaidIndices.forEach((index) {
        installments[index]["type"] = AppStrings.NotPaidType;
      });

      data["installments"] = installments;
      data["paid"] = params.model.paid;
      data["notpaid"] = params.model.notPaid;
      data["type"] = params.model.type;

      // Get the installment array from the data
      await docRef.update(data);
    }
  }

// get all properties in the remote DB
  Future<List<PropertyModel>> getProperties() async {
    print("GETTING DATA FROM REMOTE DB....");
    final QuerySnapshot snapshot = await _firestore
        .collection("allproperties")
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("properties")
        .get();

    final List<PropertyModel> properties = [];
    // print(" no of properties ${snapshot.docs.length}");
    // print(" no of properties ${snapshot.docs.last.data()}");

    print("Initializing the Property Models....");

    snapshot.docs.forEach((propertyJson) {
      // print("${propertyJson.data()}");
      return properties.add(
        PropertyModel.fromJson(
          propertyJson.data() as Map<String, dynamic>,
        ),
      );
    });
    return properties;
  }
}
