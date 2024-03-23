import 'dart:convert';
import 'package:admin/Core/Errors/exceptions.dart';
import 'package:admin/data/local/app_preferences.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:http/http.dart' as http;

//NODEJS & MONGODB AUTH
class AuthRemoteSource {
  // final String baseUrl = 'http://localhost:5000';
  final String baseUrl = 'https://property-manager-backend-z2yr.onrender.com';

  Future<String> login(String email, String password) async {
    Map<String, String> loginData = {
      'email': email,
      'password': password,
    };
    String requestBody = json.encode(loginData);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody, // Pass the encoded JSON data
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        AppPreferences.setToken(body["token"]);
        AppPreferences.setRefreshToken(body["refresh_token"]);
        print(" the ref token ${body["refresh_token"]}");
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
      final String refreshToken = await AppPreferences.getRefreshToken();
      print("validated ref token is $refreshToken");
      print("validated acctoken is $token");

      final http.Response response = await http.get(
        Uri.parse("$baseUrl/auth/validate-token"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'Refresh_Token': refreshToken
        },
      );
      // print("the response ${response.headers["authorization"]}");

      await AppPreferences.setToken(response.headers['authorization'] ?? "");

      if (response.statusCode != 200) {
        throw "NOT VALID TOKEN";
      }
      print("valid token");
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
      final String refreshToken = await AppPreferences.getRefreshToken();

      final response = await http.put(
        Uri.parse("$baseUrl/auth/check-password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'Refresh_Token': refreshToken
        },
        body: requestBody, // Pass the encoded JSON data
      );
      await AppPreferences.setToken(response.headers['authorization'] ?? "");

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
      final String refreshToken = await AppPreferences.getRefreshToken();

      Map<String, String> loginData = {
        'oldPassword': params.oldPassword,
        'newPassword': params.newPassword,
      };
      String requestBody = json.encode(loginData);
      final response = await http.put(
        Uri.parse("$baseUrl/auth/change-password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'Refresh_Token': refreshToken
        },
        body: requestBody,
      );
      await AppPreferences.setToken(response.headers['authorization'] ?? "");

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
