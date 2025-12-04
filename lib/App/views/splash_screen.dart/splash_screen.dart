import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/validation.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/widgets/accepted_order_card.dart';
import 'package:jet_picks_app/App/widgets/chatlist_card.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import 'package:jet_picks_app/App/widgets/custom_dropdown.dart';
import 'package:jet_picks_app/App/widgets/listtile_switch.dart';
import 'package:jet_picks_app/App/widgets/radio_text.dart';
import 'package:jet_picks_app/App/widgets/text_title.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_ordercard.dart';
import '../../widgets/custom_searchbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/icon_text.dart';
import '../../widgets/listtile_arrow.dart';
import '../../widgets/order_detail_card.dart';
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
      appBar: ProfileAppBar(title: 'Profile'),
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
              CustomOrderCard(),
              20.h.ph,
              CustomSearchBar(),
              20.h.ph,
              OrderDetailCard(
                imagePath: AppImages.calendarIcon,
                titleText: 'Apple Mouse',
                trailingText: '\$20',
              ),
              20.h.ph,
              TextTile(titleText: 'titleText', trailingText: '\$360'),
              20.h.ph,
              ChatListCard(
                name: 'Geopart Etdsien',
                lastMessage: 'Your Order Just Arrived!',
                time: '13.47',
              ),
              20.h.ph,
              AcceptedOrderCard(),
              20.h.ph,
              ListTileArrow(
                text: 'Personal Information',
                prefixIcon: AppImages.profileIcon,
                sufixIcon: AppImages.rightArrowIcon,
              ),
              20.h.ph,
              ListTileSwitch(text: 'Push Notification', isSwitch: true),
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
