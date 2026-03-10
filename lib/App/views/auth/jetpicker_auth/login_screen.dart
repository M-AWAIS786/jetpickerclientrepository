import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/google_sign_in_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/validation.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../view_model/auth/login_view_model.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordHidden = true;

  @override
  void initState(){
    super.initState();
      _emailController.text = "asim@gmail.com";
      _passwordController.text = "12345678";
  }

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
      // Only act when we go from loading → response received
      if (previous?.response == null && next.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.response!.message),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate first, then reset state after the frame
        context.go(AppRoutes.pickerBottomBarScreen);
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
        appBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
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
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.red1),
                ),
                70.h.ph,
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
                  // validator: (value) => Validation.passwordCorrect(value),
                  onTogglePassword: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),
                24.h.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.accountConfirm,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.red1,
                                height: 1.h,
                              ),
                        ),
                        TextSpan(
                          text: AppStrings.termandCondition,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: AppColors.red3),
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
                    onPressed: loginState.isLoading ? null : _onLoginPressed,
                    isLoading: loginState.isLoading,
                  ),
                ),
                // ── OR divider ──
                const OrDivider(),
                16.h.ph,
                // ── Google Sign-In ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GoogleSignInButton(role: 'PICKER'),
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
