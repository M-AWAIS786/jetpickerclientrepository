import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/validation.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/rememberme_row.dart';

class OrdererSignupScreen extends StatefulWidget {
  const OrdererSignupScreen({super.key});

  @override
  State<OrdererSignupScreen> createState() => _OrdererSignupScreenState();
}

class _OrdererSignupScreenState extends State<OrdererSignupScreen> {
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
        statusBarIconBrightness: Brightness.dark,
        appBarColor: AppColors.white,
        backBtnColor: AppColors.yellow3,
        backIconColor: AppColors.black,
        titleColor: AppColors.black,
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
                ).textTheme.bodyLarge?.copyWith(color: AppColors.labelGray),
              ),
              70.h.ph,
              CustomTextField(
                controller: _nameController,
                label: AppStrings.userName,
                hintText: AppStrings.userNameHint,
                prefixIcon: AppImages.profileIcon,
                keyboardType: TextInputType.name,
                fillColor: AppColors.yellow1,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _phoneNumberController,
                label: AppStrings.phoneNumber,
                hintText: AppStrings.phoneNumberHint,
                prefixIcon: AppImages.phoneIcon,
                keyboardType: TextInputType.phone,
                fillColor: AppColors.yellow1,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _emailController,
                label: AppStrings.emailAddress,
                hintText: AppStrings.emailAddressHint,
                prefixIcon: AppImages.emailIcon,
                keyboardType: TextInputType.emailAddress,
                fillColor: AppColors.yellow1,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
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
                fillColor: AppColors.yellow1,
                prefixColor: AppColors.black,
                sufixColor: AppColors.black,
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
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
                fillColor: AppColors.yellow1,
                prefixColor: AppColors.black,
                sufixColor: AppColors.black,
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
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
                child: RememberTermsWidget(
                  rememberMe: true,
                  iAgree: true,
                  activeTrackColor: AppColors.black,
                  inActiveTrackColor: AppColors.yellow1,
                  agreeTextColor: AppColors.black,
                  textColor: AppColors.black,
                  agreeIconActiveColor: AppColors.black,
                  agreeIconinActiveColor: AppColors.yellow1,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomButton(
          text: AppStrings.signUp,
          btnHeight: 60,
          radius: 0.r,
          textColor: AppColors.black,
          color: AppColors.yellow3,
          onPressed: () {
            // if (!_formKey.currentState!.validate()) return;
            Navigator.pushNamed(context, AppRoutes.ordererLoginScreen);
          },
        ),
      ),
    );
  }
}
