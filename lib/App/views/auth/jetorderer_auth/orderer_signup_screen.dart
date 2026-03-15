import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/auth/signup_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_text.dart';
import 'package:jet_picks_app/App/widgets/google_sign_in_button.dart';
import 'package:jet_picks_app/App/widgets/facebook_sign_in_button.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/validation.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/rememberme_row.dart';

class OrdererSignupScreen extends ConsumerStatefulWidget {
  const OrdererSignupScreen({super.key});

  @override
  ConsumerState<OrdererSignupScreen> createState() =>
      _OrdererSignupScreenState();
}

class _OrdererSignupScreenState extends ConsumerState<OrdererSignupScreen> {
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

  void _onSignupPressed() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(signupViewModelProvider.notifier).signup(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPassController.text,
          roles: ['ORDERER', 'PICKER'],
          preferredRole: 'ORDERER',
        );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupViewModelProvider);

    ref.listen<SignupState>(signupViewModelProvider, (previous, next) {
      if (next.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.response!.message),
            backgroundColor: Colors.green,
          ),
        );
        goRouter.go(AppRoutes.ordererProfileSetupScreen);
        ref.read(signupViewModelProvider.notifier).resetState();
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red1,
          ),
        );
      }
    });

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                5.h.ph,
                Text(
                  AppStrings.signUpSubtitle2,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.labelGray),
                ),
                40.h.ph,
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
                  labelColor: AppColors.black,
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
                  labelColor: AppColors.black,
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
                  labelColor: AppColors.black,
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
                  labelColor: AppColors.black,
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
                  labelColor: AppColors.black,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: CustomButton(
                    text: AppStrings.signUp,
                    btnHeight: 60,
                    radius: 12.r,
                    textColor: AppColors.black,
                    color: AppColors.yellow3,
                    onPressed:
                        signupState.isLoading ? null : _onSignupPressed,
                    isLoading: signupState.isLoading,
                  ),
                ),
                // ── OR divider ──
                const OrDivider(),
                16.h.ph,
                // ── Google Sign-In ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GoogleSignInButton(role: 'ORDERER'),
                ),
                12.h.ph,
                // ── Facebook Sign-In ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FacebookSignInButton(role: 'ORDERER'),
                ),
                16.h.ph,
                InkWell(
                  onTap: () => goRouter.push(AppRoutes.ordererLoginScreen),
                  child: customText(
                    text: "Have an account? Login",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                24.h.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
