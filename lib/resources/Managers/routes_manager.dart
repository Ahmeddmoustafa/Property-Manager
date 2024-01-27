// ignore_for_file: prefer_const_constructors

import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/auth/auth_gate.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String transactionRoute = '/transaction';
  static const String authRoute = '/auth';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            ),
          );
        }
      case Routes.transactionRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: Scaffold(),
            ),
          );
        }
      case Routes.authRoute:
        {
          return MaterialPageRoute(builder: (_) => SafeArea(child: AuthGate()));
        }

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("NOT FOUND"),
        ),
        body: Text("NOT FOUND"),
      ),
    );
  }
}
