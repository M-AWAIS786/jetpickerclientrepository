import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/constants/validation.dart';
import 'package:jet_picks_app/App/models/location/country_model.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/location/location_view_model.dart';
import 'package:jet_picks_app/App/view_model/user_profile/user_profile_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

// ─── Supported languages list ───────────────────────────────────
const List<String> _kLanguages = [
  'English', 'Spanish', 'French', 'German', 'Italian',
  'Portuguese', 'Arabic', 'Chinese', 'Japanese', 'Korean',
  'Hindi', 'Urdu', 'Russian', 'Dutch', 'Turkish',
  'Polish', 'Swedish', 'Norwegian', 'Danish', 'Finnish',
];

class PersonalDetailScreen extends ConsumerStatefulWidget {
  const PersonalDetailScreen({super.key});

  @override
  ConsumerState<PersonalDetailScreen> createState() =>
      _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends ConsumerState<PersonalDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _countrySearchController = TextEditingController();

  String? _selectedCountry;
  final List<String> _selectedLanguages = [];
  bool _prefilled = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _changePassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    _countrySearchController.dispose();
    super.dispose();
  }

  void _prefillOnce(UserProfileState s) {
    if (_prefilled || s.profile == null) return;
    _prefilled = true;
    final p = s.profile!;
    _nameController.text = p.fullName;
    _phoneController.text = p.phoneNumber;
    _selectedCountry = (p.country?.isNotEmpty == true) ? p.country : null;
    _selectedLanguages
      ..clear()
      ..addAll(p.languages);
  }

  // ── Country bottom sheet ─────────────────────────────────────
  void _openCountrySheet(List<CountryModel> countries) {
    _countrySearchController.clear();
    List<CountryModel> filtered = List.from(countries);

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
                  // Handle bar
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
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.red3,
                            BlendMode.srcIn,
                          ),
                        ),
                        10.w.pw,
                        Text(
                          'Select Country',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppColors.red3,
                                fontWeight: TextWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  12.h.ph,
                  // Search field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.redLight,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        controller: _countrySearchController,
                        cursorColor: AppColors.red3,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.red3,
                            ),
                        decoration: InputDecoration(
                          hintText: 'Search country...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.labelGray),
                          prefixIcon: Icon(Icons.search,
                              color: AppColors.red3, size: 20.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 12.w),
                        ),
                        onChanged: (val) {
                          setSheetState(() {
                            filtered = countries
                                .where((c) => c.name
                                    .toLowerCase()
                                    .contains(val.toLowerCase()))
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
                        color: AppColors.lightGray.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final selected = _selectedCountry == c.name;
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 0),
                          title: Text(
                            c.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: selected
                                      ? AppColors.red3
                                      : AppColors.black,
                                  fontWeight: selected
                                      ? TextWeight.bold
                                      : TextWeight.regular,
                                ),
                          ),
                          trailing: selected
                              ? Icon(Icons.check_circle,
                                  color: AppColors.red3, size: 18.sp)
                              : null,
                          onTap: () {
                            setState(() => _selectedCountry = c.name);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  20.h.ph,
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Language bottom sheet ────────────────────────────────────
  void _openLanguageSheet() {
    List<String> tempSelected = List.from(_selectedLanguages);

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
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                              AppColors.red3, BlendMode.srcIn),
                        ),
                        10.w.pw,
                        Text(
                          AppStrings.languages,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppColors.red3,
                                fontWeight: TextWeight.bold,
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
                      itemCount: _kLanguages.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: AppColors.lightGray.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (_, i) {
                        final lang = _kLanguages[i];
                        final isSelected = tempSelected.contains(lang);
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 0),
                          title: Text(
                            lang,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.red3
                                      : AppColors.black,
                                  fontWeight: isSelected
                                      ? TextWeight.semiBold
                                      : TextWeight.regular,
                                ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: AppColors.red3, size: 18.sp)
                              : Icon(Icons.circle_outlined,
                                  color: AppColors.lightGray, size: 18.sp),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    child: CustomButton(
                      text: 'Done',
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

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(userProfileViewModelProvider.notifier).updateProfile(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          country: _selectedCountry,
          languages: _selectedLanguages,
          newPassword: _changePassword && _newPassController.text.isNotEmpty
              ? _newPassController.text
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final locationState = ref.watch(locationViewModelProvider);

    _prefillOnce(profileState);

    ref.listen<UserProfileState>(userProfileViewModelProvider, (prev, next) {
      if (prev?.successMessage == null && next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.successMessage!),
          backgroundColor: AppColors.green1E,
        ));
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      } else if (prev?.errorMessage == null && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.errorMessage!),
          backgroundColor: AppColors.red1,
        ));
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        leadingIcon: true,
        title: AppStrings.personalDetail,
        titleColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              28.h.ph,

              // ── Section: Personal Info ──────────────────────
              _sectionLabel(context, 'Personal Information'),
              16.h.ph,

              _fieldCard(
                context,
                icon: AppImages.profileIcon,
                label: AppStrings.userName,
                child: TextFormField(
                  controller: _nameController,
                  validator: Validation.valueExists,
                  cursorColor: AppColors.red3,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.red3, fontWeight: TextWeight.medium),
                  decoration: _inputDecoration('Esther Howard'),
                ),
              ),
              12.h.ph,

              _fieldCard(
                context,
                icon: AppImages.phoneIcon,
                label: AppStrings.phoneNumber,
                child: TextFormField(
                  controller: _phoneController,
                  validator: Validation.valueExists,
                  keyboardType: TextInputType.phone,
                  cursorColor: AppColors.red3,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.red3, fontWeight: TextWeight.medium),
                  decoration: _inputDecoration('+1 234 567 890'),
                ),
              ),
              12.h.ph,

              // ── Country picker ───────────────────────────────
              GestureDetector(
                onTap: locationState.loadingCountries
                    ? null
                    : () => _openCountrySheet(locationState.countries),
                child: _fieldCard(
                  context,
                  icon: AppImages.flagIcon,
                  label: AppStrings.country,
                  trailing: locationState.loadingCountries
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.red3,
                          ),
                        )
                      : Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.red3, size: 20.sp),
                  child: Text(
                    _selectedCountry ?? 'Tap to select country',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _selectedCountry != null
                              ? AppColors.red3
                              : AppColors.labelGray,
                          fontWeight: _selectedCountry != null
                              ? TextWeight.medium
                              : TextWeight.regular,
                        ),
                  ),
                ),
              ),
              12.h.ph,

              // ── Languages multi-select ───────────────────────
              GestureDetector(
                onTap: _openLanguageSheet,
                child: _fieldCard(
                  context,
                  icon: AppImages.languageIcon,
                  label: AppStrings.languages,
                  trailing: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.red3, size: 20.sp),
                  child: _selectedLanguages.isEmpty
                      ? Text(
                          'Tap to select languages',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.labelGray),
                        )
                      : Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: _selectedLanguages
                              .map((lang) => _langChip(context, lang))
                              .toList(),
                        ),
                ),
              ),

              28.h.ph,

              // ── Section: Change Password ─────────────────────
              _sectionLabel(context, 'Security'),
              12.h.ph,

              // Toggle row
              GestureDetector(
                onTap: () => setState(() {
                  _changePassword = !_changePassword;
                  if (!_changePassword) {
                    _newPassController.clear();
                    _confirmPassController.clear();
                  }
                }),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.redLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      SharePictures(
                        imagePath: AppImages.passwordIcon,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.red3.withValues(alpha: 0.6),
                            BlendMode.srcIn),
                      ),
                      12.w.pw,
                      Expanded(
                        child: Text(
                          'Change Password',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.red3,
                                fontWeight: TextWeight.semiBold,
                              ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _changePassword ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red3, size: 20.sp),
                      ),
                    ],
                  ),
                ),
              ),

              // Animated password fields
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _changePassword
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    12.h.ph,
                    _fieldCard(
                      context,
                      icon: AppImages.passwordIcon,
                      label: 'New Password',
                      trailing: GestureDetector(
                        onTap: () =>
                            setState(() => _showPassword = !_showPassword),
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.red3,
                          size: 18.sp,
                        ),
                      ),
                      child: TextFormField(
                        controller: _newPassController,
                        obscureText: !_showPassword,
                        cursorColor: AppColors.red3,
                        validator: _changePassword
                            ? (v) => Validation.passwordCorrect(v)
                            : null,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.red3, fontWeight: TextWeight.medium),
                        decoration: _inputDecoration('••••••••'),
                      ),
                    ),
                    12.h.ph,
                    _fieldCard(
                      context,
                      icon: AppImages.passwordIcon,
                      label: 'Confirm New Password',
                      trailing: GestureDetector(
                        onTap: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                        child: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.red3,
                          size: 18.sp,
                        ),
                      ),
                      child: TextFormField(
                        controller: _confirmPassController,
                        obscureText: !_showConfirmPassword,
                        cursorColor: AppColors.red3,
                        validator: _changePassword
                            ? (v) => Validation.passwordConfirmed(
                                v, _newPassController.text)
                            : null,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.red3, fontWeight: TextWeight.medium),
                        decoration: _inputDecoration('••••••••'),
                      ),
                    ),
                  ],
                ),
              ),

              36.h.ph,

              CustomButton(
                text: AppStrings.save,
                isLoading: profileState.isUpdating,
                onPressed: profileState.isUpdating ? null : _onSavePressed,
              ),

              32.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext ctx, String label) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.red3,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        8.w.pw,
        Text(
          label,
          style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                color: AppColors.red3,
                fontWeight: TextWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _fieldCard(
    BuildContext ctx, {
    required String icon,
    required String label,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SharePictures(
                imagePath: icon,
                width: 16.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                  AppColors.red3.withValues(alpha: 0.55),
                  BlendMode.srcIn,
                ),
              ),
              8.w.pw,
              Text(
                label,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: AppColors.labelGray,
                      fontWeight: TextWeight.semiBold,
                    ),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          4.h.ph,
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _langChip(BuildContext ctx, String lang) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.red3.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.red3.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang,
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: AppColors.red3,
                  fontWeight: TextWeight.semiBold,
                ),
          ),
          4.w.pw,
          GestureDetector(
            onTap: () => setState(() => _selectedLanguages.remove(lang)),
            child: Icon(Icons.close, size: 12.sp, color: AppColors.red3),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.labelGray,
            fontWeight: TextWeight.regular,
          ),
    );
  }
}
