import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/auth/login_page.dart';
import 'package:admin/screens/main/components/loading_widget.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuAppController(),
              ),
            ],
            child: MainScreen(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadPage();
        }
        return LoginScreen();
      },
    );
  }
}
