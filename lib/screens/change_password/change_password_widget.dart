import 'package:admin/cubit/change_password/change_password_cubit.dart';
import 'package:admin/resources/Managers/colors_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  // late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = 500;
    final double height = 500;
    return Container(
      color: ColorManager.BackgroundColor,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.01),
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Change Your Password",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              width: double.maxFinite,
              height: height * 0.8,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 2,
                onPageChanged: (index) {
                  // _viewModel.onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCurrentPasswordTab();
                  } else {
                    return _buildNewPasswordTab();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordTab() {
    final ChangePasswordCubit cubit = context.read<ChangePasswordCubit>();

    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: cubit.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Current Password',
                      errorText:
                          cubit.passwordHasError ? cubit.passwordError : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cubit.confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Re-enter Current Password',
                      errorText: cubit.confirmPassHasError
                          ? cubit.passwordError
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Perform action with current password
                      // After successful validation, switch to next tab
                      // _formKey.currentState!.reset();
                      await cubit.verifyOldPass();
                      if (cubit.validated) {
                        _pageController.animateToPage(
                          1, // the page number you want to navigate to
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewPasswordTab() {
    final ChangePasswordCubit cubit = context.read<ChangePasswordCubit>();
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: cubit.newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter New Password',
                    errorText:
                        cubit.passwordHasError ? cubit.passwordError : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cubit.newConfirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Re-enter New Password',
                    errorText:
                        cubit.confirmPassHasError ? cubit.passwordError : null,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // if (_formKey.currentState!.validate()) {
                    //   // Perform action with new password
                    //   // After successful validation, you can perform other actions or navigate to other screens
                    // }
                    await cubit.changePassword();
                    if (cubit.validated && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
