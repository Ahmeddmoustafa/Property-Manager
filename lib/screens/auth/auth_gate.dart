import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/cubit/auth/login_cubit.dart';
import 'package:admin/screens/auth/login_page.dart';
import 'package:admin/screens/main/components/loading_widget.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginCubit cubit = BlocProvider.of<LoginCubit>(context);
    return FutureBuilder(
        future: cubit.isLoggedIn(),
        builder: (context, snapshot) {
          return BlocBuilder<LoginCubit, LoginState>(
            // stream: channel.stream,
            builder: (context, state) {
              print("signed in ${cubit.signedIn}");
              if (cubit.signedIn) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MenuAppController(),
                    ),
                  ],
                  child: MainScreen(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  !cubit.signedIn) {
                return LoginScreen();
              }
              return SizedBox.shrink();
            },
          );
        });
  }
}

// FIREBASE AUTH GATE
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       // stream: channel.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return MultiProvider(
//             providers: [
//               ChangeNotifierProvider(
//                 create: (context) => MenuAppController(),
//               ),
//             ],
//             child: MainScreen(),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return LoadPage();
//         }
//         return LoginScreen();
//       },
//     );
//   }
// }
