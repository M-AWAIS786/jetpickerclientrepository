import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash Screen')),
      body: Column(
        children: [
          Center(
            child: Text(
              'Welcome to Jet Picks!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          20.h.ph,
          Center(
            child: Text(
              'Welcome to Jet Picks!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          20.h.ph,
          CustomButton(text: 'Continue', onPressed: () {}),
          20.h.ph,
          CustomTextField(label: "Username", hintText: "Esther Howard"),
          20.h.ph,
          CustomTextField(
            label: "Password",
            hintText: "••••••",
            isPassword: true,
            obscureText: isPasswordHidden,
            onTogglePassword: () {
              setState(() {
                isPasswordHidden = !isPasswordHidden;
              });
            },
          ),
        ],
      ),
    );
  }
}
