import 'package:admin/constants.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/resources/Managers/routes_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PropertyCubit(),
        ),
        BlocProvider(
          create: (context) => PropertyModalCubit(),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            // PointerDeviceKind.touch,
            // PointerDeviceKind.stylus,
            // PointerDeviceKind.unknown
          },
        ),
        debugShowCheckedModeBanner: false,
        title: 'Properties Dashboard',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        // home: MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider(
        //       create: (context) => MenuAppController(),
        //     ),
        //   ],
        //   child: MainScreen(),
        // ),
        initialRoute: Routes.homeRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}

void init() {
  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(InstallmentAdapter());
}
