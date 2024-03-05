import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordState());
  bool loading = true;
  bool isfailed = false;
  late String confirmPassError;
  late String passwordError;
  bool confirmPassHasError = false;
  bool passwordHasError = false;
  late String password;
  late String confirmPassword;

  String error = "";
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void initVariables() {
    confirmPassword = confirmPasswordController.text;
    password = passwordController.text;
    confirmPassError = "";
    passwordError = "";
  }

  Future<void> signIn() async {
    initVariables();
    confirmPassHasError = false;
    passwordHasError = false;
    isfailed = false;
    loading = true;
    emit(state.copyWith());

    if (password != confirmPassword) {
      passwordError = "Passwords Is Not The Same";
      passwordHasError = true;
    }

    if (passwordHasError) {
      loading = false;
      emit(state.copyWith());
      return;
    }

    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      try {
        // await authservice.signIn(email, password);
        // await loginUsecase(LoginParams(email: email, password: password));
        loading = false;
        emit(state.copyWith());
      } catch (err) {
        isfailed = true;
        error = err.toString();
        emit(state.copyWith());
      }
      return;
    }
  }
}
