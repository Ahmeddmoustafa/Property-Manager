import 'package:admin/domain/Usecases/login_usercase.dart';
import 'package:admin/domain/Usecases/logout_usecase.dart';
import 'package:admin/domain/Usecases/usecase.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "login_state.dart";

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  bool loading = true;
  bool signedIn = false;
  bool isfailed = false;
  String error = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String email;
  late String password;
  late String emailError;
  late String passwordError;
  bool emailHasError = false;
  bool passwordHasError = false;
  LoginCubit({required this.loginUsecase, required this.logoutUsecase})
      : super(LoginState());

  void initVariables() {
    email = emailController.text;
    password = passwordController.text;
    emailError = "";
    passwordError = "";
  }

  void signIn() async {
    initVariables();
    emailHasError = false;
    passwordHasError = false;

    isfailed = false;
    loading = true;

    if (!EmailValidator.validate(email)) {
      emailError = "Invalid Email Address";
      emailHasError = true;
    }
    if (password.length < 8) {
      passwordError = "Please enter password at least 8 characters";
      passwordHasError = true;
    }

    if (emailHasError || passwordHasError) {
      loading = false;
      emit(state.copyWith());
      return;
    }

    if (EmailValidator.validate(email) && password.length >= 8) {
      try {
        // await authservice.signIn(email, password);
        await loginUsecase(LoginParams(email: email, password: password));
        signedIn = true;
        emit(state.copyWith());
      } catch (err) {
        isfailed = true;
        error = err.toString();
        emit(state.copyWith());
      }
      return;
    }
  }

  Future<void> logout() async {
    try {
      final result = await logoutUsecase(NoParams());
      result.fold((l) {
        isfailed = true;
        error = "Something Unexpected Happened";
      }, (r) => null);
    } catch (err) {}
  }
}