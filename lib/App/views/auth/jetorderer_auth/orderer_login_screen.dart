import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/validation.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/profile_appbar.dart';
import '../../../view_model/auth/login_view_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class OrdererLoginScreen extends ConsumerStatefulWidget {
  const OrdererLoginScreen({super.key});

  @override
  ConsumerState<OrdererLoginScreen> createState() =>
      _OrdererLoginScreenState();
}

class _OrdererLoginScreenState extends ConsumerState<OrdererLoginScreen> {
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

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(loginViewModelProvider.notifier).login(
          username: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (previous?.response == null && next.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.response!.message),
            backgroundColor: Colors.green,
          ),
        );
        context.go(AppRoutes.ordererBottomBarScreen);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(loginViewModelProvider.notifier).resetState();
        });
      } else if (previous?.errorMessage == null && next.errorMessage != null) {
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
        title: AppStrings.welcomeBack,
        alignment: Alignment.bottomCenter,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.labelGray,
                                    height: 1.h,
                                  ),
                        ),
                        TextSpan(
                          text: AppStrings.termandCondition,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: CustomButton(
                    text: AppStrings.logIn,
                    btnHeight: 60,
                    radius: 12.r,
                    textColor: AppColors.black,
                    color: AppColors.yellow3,
                    onPressed: loginState.isLoading ? null : _onLoginPressed,
                    isLoading: loginState.isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
