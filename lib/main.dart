import 'package:admin/Core/injection_control.dart' as di;
import 'package:admin/constants.dart';
import 'package:admin/cubit/add_property/add_property_cubit.dart';
import 'package:admin/cubit/auth/login_cubit.dart';
import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
// import 'package:admin/cubit/edit_property/property_modal_cubit.dart';
import 'package:admin/cubit/get_property/property_cubit.dart';
import 'package:admin/cubit/reminder/reminder_cubit.dart';
import 'package:admin/cubit/scroll/scroll_cubit.dart';
import 'package:admin/data/models/property_model.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/resources/Managers/routes_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  hiveInit();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<PropertyCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => PropertyModalCubit(),
        // ),
        BlocProvider(
          create: (context) => di.sl<PropertyModalCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AddPropertyCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => ReminderCubit(),
        ),
        BlocProvider(
          create: (context) => ScrollCubit(),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            // PointerDeviceKind.mouse,
            // PointerDeviceKind.trackpad,
            // PointerDeviceKind.touch,
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
        initialRoute: Routes.authRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}

void hiveInit() {
  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(InstallmentAdapter());
}
