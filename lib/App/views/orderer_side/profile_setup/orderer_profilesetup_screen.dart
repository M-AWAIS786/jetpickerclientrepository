import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/location/location_view_model.dart';
import 'package:jet_picks_app/App/view_model/user_profile/user_profile_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/profile_setup_data.dart';
import '../../../utils/profile_appbar.dart';
import '../../../widgets/custom_dropdown.dart';

class OrdererProfileSetupScreen extends ConsumerStatefulWidget {
  const OrdererProfileSetupScreen({super.key});

  @override
  ConsumerState<OrdererProfileSetupScreen> createState() =>
      _OrdererProfileSetupScreenState();
}

class _OrdererProfileSetupScreenState extends ConsumerState<OrdererProfileSetupScreen> {
  String? selectedCountry;
  final List<String> _selectedLanguages = [];
  File? _selectedImage;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProfileViewModelProvider.notifier).getMyProfile();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  void _openCountrySheet(List<String> countries) {
    final searchController = TextEditingController();
    var filtered = List<String>.from(countries);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: 0.75.sh,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  12.h.ph,
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  16.h.ph,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        SharePictures(
                          imagePath: AppImages.flagIcon,
                          width: 18.w,
                          height: 18.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        10.w.pw,
                        Text(
                          'Select country',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  12.h.ph,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow1,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        controller: searchController,
                        cursorColor: AppColors.yellow3,
                        decoration: InputDecoration(
                          hintText: 'Search country...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.labelGray),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.black,
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            filtered = countries
                                .where((country) => country
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  12.h.ph,
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: AppColors.lightGray.withOpacity(0.5),
                      ),
                      itemBuilder: (_, index) {
                        final country = filtered[index];
                        final isSelected = selectedCountry == country;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            country,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isSelected
                                          ? AppColors.black
                                          : AppColors.labelGray,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.yellow3,
                                  size: 18.sp,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              selectedCountry = country;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(searchController.dispose);
  }

  void _openLanguageSheet() {
    final tempSelected = List<String>.from(_selectedLanguages);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: 0.7.sh,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  12.h.ph,
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  16.h.ph,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        SharePictures(
                          imagePath: AppImages.languageIcon,
                          width: 18.w,
                          height: 18.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        10.w.pw,
                        Text(
                          AppStrings.languages,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '${tempSelected.length} selected',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.labelGray),
                        ),
                      ],
                    ),
                  ),
                  12.h.ph,
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: languagesList.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: AppColors.lightGray.withOpacity(0.5),
                      ),
                      itemBuilder: (_, index) {
                        final lang = languagesList[index];
                        final isSelected = tempSelected.contains(lang);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            lang,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? AppColors.black
                                      : AppColors.labelGray,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                          ),
                          trailing: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected
                                ? AppColors.yellow3
                                : AppColors.lightGray,
                          ),
                          onTap: () {
                            setSheetState(() {
                              if (isSelected) {
                                tempSelected.remove(lang);
                              } else {
                                tempSelected.add(lang);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: CustomButton(
                      text: 'Done',
                      color: AppColors.yellow3,
                      textColor: AppColors.black,
                      onPressed: () {
                        setState(() {
                          _selectedLanguages
                            ..clear()
                            ..addAll(tempSelected);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _prefillProfile(UserProfileState state) {
    if (_prefilled || state.profile == null) return;
    _prefilled = true;
    selectedCountry = state.profile!.country;
    _selectedLanguages
      ..clear()
      ..addAll(state.profile!.languages);
  }

  Future<void> _continue() async {
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your nationality.')),
      );
      return;
    }

    if (_selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one language.')),
      );
      return;
    }

    await ref.read(userProfileViewModelProvider.notifier).updateProfile(
          country: selectedCountry,
          languages: _selectedLanguages,
          image: _selectedImage,
        );

    final nextState = ref.read(userProfileViewModelProvider);
    if (!mounted) return;
    if (nextState.errorMessage == null) {
      context.go(AppRoutes.ordererBottomBarScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final locationState = ref.watch(locationViewModelProvider);
    final countryItems = locationState.countries.map((c) => c.name).toList();
    _prefillProfile(profileState);

    ref.listen<UserProfileState>(userProfileViewModelProvider, (prev, next) {
      if (next.successMessage != null && next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      }
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      }
    });

    return Scaffold(
      appBar: ProfileAppBar(
        leadingIcon: true,
        statusBarIconBrightness: Brightness.dark,
        appBarColor: AppColors.white,
        title: AppStrings.profileSetup,
        titleColor: AppColors.black,
        backIconColor: AppColors.black,
        backBtnColor: AppColors.yellow3,
        alignment: Alignment.bottomCenter,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.h.ph,
              profileImage(profileState),
              12.h.ph,
              Text(
                AppStrings.uploadProfilePhoto,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              48.h.ph,

              GestureDetector(
                onTap: locationState.loadingCountries || countryItems.isEmpty
                    ? null
                    : () => _openCountrySheet(countryItems),
                child: AbsorbPointer(
                  child: CustomDropDown(
                    selectedValue: null,
                    hintText: locationState.loadingCountries
                        ? 'Loading countries...'
                        : (selectedCountry?.isNotEmpty == true
                            ? selectedCountry!
                            : AppStrings.country),
                    labelText: AppStrings.yourNationality,
                    prefixIcon: AppImages.flagIcon,
                    preficIconColor: AppColors.black,
                    hintTextColor: AppColors.black,
                    labelTextColor: AppColors.black,
                    items: countryItems,
                    onChanged: (_) {},
                  ),
                ),
              ),
              CustomDivider(dividerThickness: 1),
              7.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.usedToConnect,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              32.h.ph,
              GestureDetector(
                onTap: _openLanguageSheet,
                child: AbsorbPointer(
                  child: CustomDropDown(
                    selectedValue: null,
                    hintText: _selectedLanguages.isEmpty
                        ? AppStrings.languages
                        : '${_selectedLanguages.length} selected',
                    labelText: AppStrings.languages,
                    prefixIcon: AppImages.languageIcon,
                    preficIconColor: AppColors.black,
                    hintTextColor: AppColors.black,
                    labelTextColor: AppColors.black,
                    items: languagesList,
                    onChanged: (_) {},
                  ),
                ),
              ),
              CustomDivider(dividerThickness: 1),
              7.h.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.selectMultipleLanguages,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              118.h.ph,
              CustomButton(
                text: AppStrings.continueText,
                color: AppColors.yellow3,
                textColor: AppColors.black,
                isLoading: profileState.isUpdating || profileState.isLoading,
                onPressed: (profileState.isUpdating || profileState.isLoading)
                    ? null
                    : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileImage(UserProfileState profileState) {
    final avatarUrl = profileState.profile?.avatarUrl;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            shape: BoxShape.circle,
            border: Border.all(width: 1.w, color: AppColors.black),
          ),
          child: ClipOval(
            child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : (avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      )
                    : null),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.yellow1,
              shape: BoxShape.circle,
              border: Border.all(width: 1.w, color: AppColors.black),
            ),
            child: Transform.scale(
              scale: 0.6,
              child: SharePictures(
                imagePath: AppImages.cameraIcon,
                colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
