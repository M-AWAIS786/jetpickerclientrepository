import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/validation.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class OpersonalDetailScreen extends StatefulWidget {
  const OpersonalDetailScreen({super.key});

  @override
  State<OpersonalDetailScreen> createState() => _OpersonalDetailScreenState();
}

class _OpersonalDetailScreenState extends State<OpersonalDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _countryController = TextEditingController();
  final _languageController = TextEditingController();
  bool isPasswordHidden = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        statusBarIconBrightness: Brightness.dark,
        title: AppStrings.personalDetail,
        appBarColor: AppColors.yellow3,
        titleColor: AppColors.black,
        bellColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              70.h.ph,
              CustomTextField(
                controller: _nameController,
                label: AppStrings.userName,
                hintText: AppStrings.userNameHint,
                prefixIcon: AppImages.profileIcon,
                keyboardType: TextInputType.name,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,

                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _phoneNumberController,
                label: AppStrings.phoneNumber,
                hintText: AppStrings.phoneNumberHint,
                prefixIcon: AppImages.phoneIcon,
                keyboardType: TextInputType.phone,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _emailController,
                label: AppStrings.emailAddress,
                hintText: AppStrings.emailAddressHint,
                prefixIcon: AppImages.emailIcon,
                keyboardType: TextInputType.emailAddress,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,
                validator: (value) => Validation.validateEmail(value),
              ),
              9.h.ph,
              CustomTextField(
                controller: _countryController,
                label: AppStrings.country,
                hintText: AppStrings.country,
                prefixIcon: AppImages.flagIcon,
                keyboardType: TextInputType.text,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,
                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                controller: _languageController,
                label: AppStrings.languages,
                hintText: AppStrings.languages,
                prefixIcon: AppImages.languageIcon,
                keyboardType: TextInputType.text,
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,
                validator: Validation.valueExists,
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
                prefixColor: AppColors.black,
                hintColor: AppColors.black,
                fillColor: AppColors.yellow1,
                textColor: AppColors.black,
                sufixColor: AppColors.black,
                validator: (value) => Validation.passwordCorrect(value),
                onTogglePassword: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
              50.h.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  text: AppStrings.save,
                  textColor: AppColors.black,
                  color: AppColors.yellow3,
                  onPressed: () {
                    // if (!_formKey.currentState!.validate()) return;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
