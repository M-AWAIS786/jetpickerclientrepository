import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_strings.dart';
import '../../constants/validation.dart';

import '../../utils/profile_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({super.key});

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
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
        title: AppStrings.personalDetail,
        titleColor: AppColors.white,
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
                // controller: _emailController,
                label: AppStrings.country,
                hintText: AppStrings.country,
                prefixIcon: AppImages.flagIcon,

                validator: Validation.valueExists,
              ),
              9.h.ph,
              CustomTextField(
                // controller: _emailController,
                label: AppStrings.languages,
                hintText: AppStrings.languages,
                prefixIcon: AppImages.languageIcon,
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
