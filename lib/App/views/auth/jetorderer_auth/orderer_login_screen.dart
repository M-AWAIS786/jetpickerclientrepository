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

class OrdererLoginScreen extends StatefulWidget {
  const OrdererLoginScreen({super.key});

  @override
  State<OrdererLoginScreen> createState() => _OrdererLoginScreenState();
}

class _OrdererLoginScreenState extends State<OrdererLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        title: AppStrings.welcomeBack,
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
                AppStrings.logInSubtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.labelGray),
              ),
              70.h.ph,
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
                hintColor: AppColors.black,
                cursorColor: AppColors.black,
                sufixColor: AppColors.black,
                validator: (value) => Validation.passwordCorrect(value),
                onTogglePassword: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
              280.h.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppStrings.accountConfirm,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.labelGray,
                          height: 1.h,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.termandCondition,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: AppStrings.logIn,
        btnHeight: 60,
        radius: 0.r,
        textColor: AppColors.black,
        color: AppColors.yellow3,
        onPressed: () {
          // if (!_formKey.currentState!.validate()) return;
          Navigator.pushNamed(context, AppRoutes.ordererProfileSetupScreen);
        },
      ),
    );
  }
}
