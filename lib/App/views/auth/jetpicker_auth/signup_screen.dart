import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

import '../../../constants/app_images.dart';
import '../../../constants/validation.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/rememberme_row.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        leadingIcon: true,
        appBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.signUp,
        alignment: Alignment.bottomCenter,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.h.ph,
              Text(
                AppStrings.signUpSubtitle2,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.red1),
              ),
              70.h.ph,
              CustomTextField(
                controller: _nameController,
                label: AppStrings.userName,
                hintText: AppStrings.userNameHint,
                prefixIcon: AppImages.profileIcon,
                keyboardType: TextInputType.name,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _phoneNumberController,
                label: AppStrings.phoneNumber,
                hintText: AppStrings.phoneNumberHint,
                prefixIcon: AppImages.phoneIcon,
                keyboardType: TextInputType.phone,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _emailController,
                label: AppStrings.emailAddress,
                hintText: AppStrings.emailAddressHint,
                prefixIcon: AppImages.emailIcon,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validation.validateEmail(value),
              ),
              9.h.ph,
              CustomTextField(
                controller: _passwordController,
                label: AppStrings.password,
                hintText: AppStrings.passwordHint,
                prefixIcon: AppImages.passwordIcon,
                isPassword: true,
                obscureText: isPasswordHidden,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validation.passwordCorrect(value),
                onTogglePassword: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
              9.h.ph,
              CustomTextField(
                controller: _confirmPassController,
                label: AppStrings.confirmPassword,
                hintText: AppStrings.passwordHint,
                prefixIcon: AppImages.passwordIcon,
                isPassword: true,
                obscureText: isConfirmPasswordHidden,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validation.passwordConfirmed(
                  value,
                  _passwordController.text,
                ),
                onTogglePassword: () {
                  setState(() {
                    isConfirmPasswordHidden = !isConfirmPasswordHidden;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: RememberTermsWidget(rememberMe: true, iAgree: true),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: AppStrings.signUp,
        btnHeight: 60,
        radius: 0.r,
        onPressed: () {
          // if (!_formKey.currentState!.validate()) return;
          Navigator.pushNamed(context, AppRoutes.loginScreen);
        },
      ),
    );
  }
}
