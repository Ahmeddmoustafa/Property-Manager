import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRemoteSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": userCredential.user!.email,
      }, SetOptions(merge: true));
      return;
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message);
    }
  }

  Future<void> logout() async {
    try {
      _firebaseAuth.signOut();
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message);
    }
  }
}
