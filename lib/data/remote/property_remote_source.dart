import 'dart:convert';

import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/domain/Usecases/notpaid_usecase.dart';
import 'package:admin/domain/Usecases/update_property_usecase.dart';
import 'package:admin/resources/Managers/strings_manager.dart';
import 'package:http/http.dart' as http;

//MONGO DB DATA
class PropertyRemoteSource {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Create new property
  Future<PropertyModel> createProperty(PropertyModel property) async {
    try {
      Map<String, dynamic> propertyData = property.toJson();
      String requestBody = json.encode(propertyData);
      final String token = await AppPreferences.getToken();

      final response = await http.post(
        Uri.parse("http://localhost:5000/properties/add"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: requestBody, // Pass the encoded JSON data
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        property.id = body['_id'];
        return property;
      }
      throw Exception("INVALID REQUEST");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //Overwrites the property data in the Firebase
  Future<void> updateProperty(UpdatePropertyParams params) async {
    try {
      Map<String, dynamic> propertyData = params.updatedData;
      String requestBody = json.encode(propertyData);
      final String token = await AppPreferences.getToken();

      final response = await http.put(
        Uri.parse(
            "http://localhost:5000/properties/updateproperty/${params.propertyId}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: requestBody, // Pass the encoded JSON data
      );
      if (response.statusCode == 200) {
        return;
      }
      throw Exception("INVALID REQUEST");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> setPropertyNotPaid(SetNotPaidParams params) async {
    try {
      Map<String, dynamic> propertyData = {"properties": params.updatedData};
      String requestBody = json.encode(propertyData);
      final String token = await AppPreferences.getToken();
      print("request made");
      final response = await http.put(
          Uri.parse("http://localhost:5000/properties/updateproperties"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: requestBody // Pass the encoded JSON data
          );
      print(" the response is ${response.body}");
      if (response.statusCode == 200) {
        return;
      }
      throw Exception("INVALID REQUEST");
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

// get all properties in the remote DB
  Future<List<PropertyModel>> getProperties() async {
    try {
      print("GETTING DATA FROM REMOTE DB....");
      final String token = await AppPreferences.getToken();
      final response = await http.get(
        Uri.parse("http://localhost:5000/properties/all"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      final List<PropertyModel> properties = [];
      // print(" no of properties ${snapshot.docs.length}");
      // print(" no of properties ${snapshot.docs.last.data()}");
      final List<dynamic> bodyJson = json.decode(response.body);

      print("Initializing the Property Models....");

      if (response.statusCode == 200) {
        bodyJson.forEach((propertyJson) {
          // print("${propertyJson.data()}");
          return properties.add(
            PropertyModel.fromJson(
              propertyJson as Map<String, dynamic>,
            ),
          );
        });
        return properties;
      }
      throw Exception("INVALID REQUEST");
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}




// FIREBASE DATA
// class PropertyRemoteSource {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// // Create new property
//   Future<PropertyModel> createProperty(PropertyModel property) async {
//     final String id = _firestore
//         .collection("allproperties")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .collection("properties")
//         .doc()
//         .id;

//     property.id = id;

//     await _firestore
//         .collection("allproperties")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .collection("properties")
//         .doc(id)
//         .set(property.toJson());
//     return property;
//   }

//   //Overwrites the property data in the Firebase
//   Future<void> updateProperty(UpdatePropertyParams params) async {
//     DocumentReference docRef = _firestore
//         .collection("allproperties")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .collection("properties")
//         .doc(params.model.id);

//     DocumentSnapshot doc = await docRef.get();

//     if (doc.exists) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       List<dynamic> installments = data['installments'];

//       params.updatedIndices.forEach((index) {
//         installments[index]["type"] = AppStrings.PaidType;
//       });

//       data["installments"] = installments;
//       data["paid"] = params.model.paid;
//       data["notpaid"] = params.model.notPaid;
//       data["type"] = params.model.type;

//       // Get the installment array from the data
//       await docRef.update(data);
//     }
//   }

//   Future<void> setPropertyNotPaid(SetNotPaidParams params) async {
//     DocumentReference docRef = _firestore
//         .collection("allproperties")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .collection("properties")
//         .doc(params.model.id);

//     DocumentSnapshot doc = await docRef.get();

//     if (doc.exists) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       List<dynamic> installments = data['installments'];

//       params.notPaidIndices.forEach((index) {
//         installments[index]["type"] = AppStrings.NotPaidType;
//       });

//       data["installments"] = installments;
//       data["paid"] = params.model.paid;
//       data["notpaid"] = params.model.notPaid;
//       data["type"] = params.model.type;

//       // Get the installment array from the data
//       await docRef.update(data);
//     }
//   }

// // get all properties in the remote DB
//   Future<List<PropertyModel>> getProperties() async {
//     print("GETTING DATA FROM REMOTE DB....");
//     final QuerySnapshot snapshot = await _firestore
//         .collection("allproperties")
//         .doc(_firebaseAuth.currentUser!.uid)
//         .collection("properties")
//         .get();

//     final List<PropertyModel> properties = [];
//     // print(" no of properties ${snapshot.docs.length}");
//     // print(" no of properties ${snapshot.docs.last.data()}");

//     print("Initializing the Property Models....");

//     snapshot.docs.forEach((propertyJson) {
//       // print("${propertyJson.data()}");
//       return properties.add(
//         PropertyModel.fromJson(
//           propertyJson.data() as Map<String, dynamic>,
//         ),
//       );
//     });
//     return properties;
//   }
// }
