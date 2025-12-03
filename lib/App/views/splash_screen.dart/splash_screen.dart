import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/validation.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import 'package:jet_picks_app/App/widgets/custom_dropdown.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_ordercard.dart';
import '../../widgets/custom_searchbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/icon_text.dart';
import '../../widgets/rememberme_row.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final nameController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool useMyLocation = false;
  String? selectedCountry;

  List<String> countryList = ["Pakistan", "UAE", "Saudi Arabia", "Turkey"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash Screen')),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
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

              CustomTextField(
                label: "Username",
                hintText: "Esther Howard",
                prefixIcon: AppImages.profileIcon,
                validator: Validation.valueExists,
              ),
              20.h.ph,
              CustomTextField(
                label: "Password",
                hintText: "••••••",
                isPassword: true,
                prefixIcon: AppImages.passwordIcon,
                obscureText: isPasswordHidden,
                onTogglePassword: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),

              20.h.ph,
              RememberTermsWidget(rememberMe: true, iAgree: true),
              20.h.ph,
              CustomDropDown(
                selectedValue: selectedCountry,
                hintText: "Country",
                labelText: "Departure country and city",
                prefixIcon: AppImages.locationLineIcon,
                items: countryList,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              CustomDivider(),
              20.h.ph,
              IconText(
                labelText: 'Arrival Time',
                prefixIcon: AppImages.agreeIcon,
              ),
              20.h.ph,
              RadioText(
                text: 'Use my location',
                isSelected: useMyLocation,
                onChanged: () {
                  setState(() {
                    useMyLocation = !useMyLocation;
                  });
                },
              ),
              SharePictures(imagePath: AppImages.jetPickerImage),
              20.h.ph,
              OrderSummaryCard(),
              20.h.ph,
              CustomSearchBar(hint: 'Browse jet Orders'),
              20.h.ph,
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (!_form.currentState!.validate()) {
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
