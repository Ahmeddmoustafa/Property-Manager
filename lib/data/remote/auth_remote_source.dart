import 'dart:convert';
import 'package:admin/Core/Errors/exceptions.dart';
import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:http/http.dart' as http;

//NODEJS & MONGODB AUTH
class AuthRemoteSource {
  Future<String> login(String email, String password) async {
    Map<String, String> loginData = {
      'email': email,
      'password': password,
    };
    String requestBody = json.encode(loginData);
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody, // Pass the encoded JSON data
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return body["token"];
      }
      throw Exception("INVALID CREDENTIALS");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> validateToken() async {
    try {
      final String token = await AppPreferences.getToken();
      final response = await http.get(
        Uri.parse("http://localhost:5000/auth/validate-token"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode != 200) {
        throw Exception("NOT VALID TOKEN");
      }
      print("token is valid $token");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> confirmPassword(ChangePasswordParams params) async {
    try {
      Map<String, String> loginData = {
        'password': params.oldPassword,
      };
      String requestBody = json.encode(loginData);
      final String token = await AppPreferences.getToken();
      final response = await http.put(
        Uri.parse("http://localhost:5000/auth/check-password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: requestBody, // Pass the encoded JSON data
      );
      if (response.statusCode == 401) {
        throw "INCORRECT PASSWORD";
      } else if (response.statusCode != 200) {
        throw "REQUEST FAILED";
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> changePassword(ChangePasswordParams params) async {
    try {
      final String token = await AppPreferences.getToken();

      Map<String, String> loginData = {
        'oldPassword': params.oldPassword,
        'newPassword': params.newPassword,
        "token": token
      };
      String requestBody = json.encode(loginData);
      final response = await http.put(
        Uri.parse("http://localhost:5000/auth/change-password"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );
      if (response.statusCode == 401) {
        throw "INCORRECT PASSWORD";
      } else if (response.statusCode != 200) {
        throw "NOT VALID TOKEN";
      }
      // print("token is valid $token");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> logout() async {}
}

//FIREBASE AUTH
// class AuthRemoteSource {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> login(String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       _firestore.collection("users").doc(userCredential.user!.uid).set({
//         "uid": userCredential.user!.uid,
//         "email": userCredential.user!.email,
//       }, SetOptions(merge: true));
//       return;
//     } on FirebaseAuthException catch (err) {
//       throw Exception(err.message);
//     }
//   }

//   Future<void> logout() async {
//     try {
//       _firebaseAuth.signOut();
//     } on FirebaseAuthException catch (err) {
//       throw Exception(err.message);
//     }
//   }
// }
