import 'package:admin/data/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyRemoteSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Create new property
  Future<void> createProperty(PropertyModel property) async {
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
    print(" no of properties ${snapshot.docs.length}");
    // print(" no of properties ${snapshot.docs.last.data()}");

    print("Initializing the Property Models....");

    snapshot.docs.forEach((propertyJson) {
      print("${propertyJson.data()}");
      return properties.add(
        PropertyModel.fromJson(
          propertyJson.data() as Map<String, dynamic>,
        ),
      );
    });
    return properties;
  }
}
