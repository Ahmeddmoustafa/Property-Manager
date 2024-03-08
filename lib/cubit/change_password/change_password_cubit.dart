import 'package:admin/domain/Usecases/change_pass_usecase.dart';
import 'package:admin/domain/Usecases/confirm_pass_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required this.confirmCurrentPasswordUseCase,
    required this.changePasswordUseCase,
  }) : super(ChangePasswordState());
  final ChangePasswordUseCase changePasswordUseCase;
  final ConfirmCurrentPasswordUseCase confirmCurrentPasswordUseCase;
  bool loading = true;
  bool isfailed = false;
  late String confirmPassError;
  late String passwordError;
  bool confirmPassHasError = false;
  bool passwordHasError = false;
  late String password;
  late String confirmPassword;

  late String newPassword;
  late String confirmNewPassword;

  bool validated = false;

  String error = "";
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController newConfirmPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void initVariables() {
    confirmPassword = confirmPasswordController.text;
    password = passwordController.text;

    confirmPassError = "";
    passwordError = "";

    confirmPassHasError = false;
    passwordHasError = false;

    newPassword = newPasswordController.text;
    confirmNewPassword = newConfirmPasswordController.text;

    isfailed = false;
    loading = true;
    validated = false;
  }

  Future<void> verifyOldPass() async {
    initVariables();
    emit(state.copyWith());

    if (password != confirmPassword) {
      passwordError = "Passwords Are Not The Same";
      passwordHasError = true;
      loading = false;
      validated = false;
      emit(state.copyWith());
      return;
    }
    if (password.isEmpty) {
      passwordError = "Please Enter Your Password";
      passwordHasError = true;
      loading = false;
      validated = false;
      emit(state.copyWith());
      return;
    }

    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      try {
        final result = await confirmCurrentPasswordUseCase(
          ChangePasswordParams(
            oldPassword: password,
            newPassword: "12345678",
          ),
        );

        result.fold((l) {
          passwordHasError = true;
          passwordError = l.msg;
          validated = false;
        }, (r) {
          passwordHasError = false;
          validated = true;
        });
        loading = false;
        emit(state.copyWith());
      } catch (err) {
        isfailed = true;
        validated = false;
        error = err.toString();
        loading = false;
        emit(state.copyWith());
      }
      return;
    }
    emit(state.copyWith());
  }

  void formFailed(String msg) {
    passwordError = msg;
    passwordHasError = true;
    loading = false;
    validated = false;
    emit(state.copyWith());
  }

  Future<void> changePassword() async {
    initVariables();
    emit(state.copyWith());

    if (newPassword != confirmNewPassword) {
      formFailed("Passwords Are Not The Same");
      return;
    }
    if (newPassword.isEmpty) {
      formFailed("Please Enter Your New Password");
      return;
    }
    if (newPassword.length < 8) {
      formFailed("Please enter password at least 8 character");
      return;
    }
    print(password);

    try {
      final result = await changePasswordUseCase(
        ChangePasswordParams(
          oldPassword: password,
          newPassword: newPassword,
        ),
      );

      result.fold((l) {
        passwordHasError = true;
        passwordError = l.msg;
        validated = false;
      }, (r) {
        passwordHasError = false;
        validated = true;
      });

      loading = false;
      emit(state.copyWith());
    } catch (err) {
      isfailed = true;
      validated = false;
      error = err.toString();
      loading = false;
      emit(state.copyWith());
    }
  }
}
