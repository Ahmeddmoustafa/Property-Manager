import 'package:admin/cubit/auth/login_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:admin/resources/Managers/fonts_manager.dart';
import 'package:admin/resources/Managers/routes_manager.dart';
import 'package:admin/resources/Managers/values_manager.dart';
import 'package:admin/resources/Utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginCubit cubit = BlocProvider.of<LoginCubit>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // appBar: AppBar(
      //   leading: InkWell(
      //     onTap: () => Navigator.pop(context),
      //     child: const Icon(
      //       Icons.arrow_back,
      //     ),
      //   ),
      //   // automaticallyImplyLeading: false,
      //   title: Image(
      //     width: Responsive.isMobile(context) ? AppSize.s100 : AppSize.s400,
      //     image: AssetImage(AssetsManager.SadImage),
      //   ),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: Responsive.isMobile(context) ? width * 0.9 : width * 0.3,
            height: height * 0.7,
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (cubit.signedIn) {
                  Navigator.pushReplacementNamed(context, Routes.authRoute);
                } else if (cubit.isfailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    showCloseIcon: true,
                    content: Text(cubit.error),
                  ));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign In Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: ColorManager.Pink,
                        fontSize: FontSize.s22,
                      ),
                    ),
                    const SizedBox(height: AppSize.s16),
                    TextFormField(
                      controller: cubit.emailController,
                      // style: textTheme.displaySmall,
                      decoration: InputDecoration(
                        errorText:
                            cubit.emailHasError ? cubit.emailError : null,
                        // labelStyle: textTheme.displaySmall,
                        labelText: 'Email',
                        // errorText: "",
                      ),
                    ),
                    const SizedBox(height: AppSize.s16),
                    TextFormField(
                      controller: cubit.passwordController,
                      // style: textTheme.displaySmall,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText:
                            cubit.passwordHasError ? cubit.passwordError : null,
                        // labelStyle: textTheme.displaySmall,
                        hintStyle: textTheme.displaySmall,
                        labelText: 'Password',
                        // errorText: "nul",
                      ),
                    ),
                    const SizedBox(height: AppSize.s30),
                    InkWell(
                      onTap: () async {
                        await cubit.signIn();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorManager.PrimaryColor,
                            borderRadius: BorderRadius.circular(AppSize.s10)),
                        width: AppSize.s200,
                        height: AppSize.s40,
                        child: const Center(
                          child: Text(
                            "Sign In",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.s25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          // style: Theme.of(context).textTheme.displaySmall,
                        ),
                        // GestureDetector(
                        //   onTap: () => Navigator.pushReplacementNamed(
                        //       context, Routes.signUpRoute),
                        //   child: Text(
                        //     "Signup Now",
                        //     style: Theme.of(context).textTheme.displayMedium,
                        //   ),
                        // ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
