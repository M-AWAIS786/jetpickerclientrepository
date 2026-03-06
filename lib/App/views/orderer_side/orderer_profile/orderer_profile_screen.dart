import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/user_profile/user_profile_view_model.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/widgets/role_toggle.dart';

class OrdererProfileScreen extends ConsumerStatefulWidget {
  const OrdererProfileScreen({super.key});

  @override
  ConsumerState<OrdererProfileScreen> createState() =>
      _OrdererProfileScreenState();
}

class _OrdererProfileScreenState extends ConsumerState<OrdererProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileViewModelProvider.notifier).getMyProfile();
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final file = File(picked.path);
    if (!mounted) return;
    ref.read(userProfileViewModelProvider.notifier).updateAvatar(file);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);

    ref.listen<UserProfileState>(userProfileViewModelProvider,
        (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.green1E,
          ),
        );
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red1,
          ),
        );
        ref.read(userProfileViewModelProvider.notifier).resetMessages();
      }
    });

    final profile = profileState.profile;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: profileState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.yellow3),
              )
            : Column(
                children: [
                  // ── Header ─────────────────────────────────
                  Container(
                    padding: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: AppColors.yellow3,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28.r),
                        bottomRight: Radius.circular(28.r),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          // Title row
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.profiletext,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppColors.black,
                                        fontWeight: TextWeight.bold,
                                      ),
                                ),
                                Row(
                                  children: [
                                    const RoleToggle(currentRole: 'ORDERER'),
                                    12.w.pw,
                                    GestureDetector(
                                      onTap: () {},
                                      child: SharePictures(
                                        imagePath: AppImages.bellIcon,
                                        width: 22.w,
                                        height: 22.h,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          20.h.ph,

                          // Avatar + info
                          GestureDetector(
                            onTap: profileState.isUploadingAvatar
                                ? null
                                : _pickAndUploadAvatar,
                            child: Stack(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightGray,
                                    border: Border.all(
                                      width: 3.w,
                                      color: AppColors.black
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: profile?.avatarUrl != null &&
                                            profile!.avatarUrl!.isNotEmpty
                                        ? Image.network(
                                            profile.avatarUrl!,
                                            fit: BoxFit.cover,
                                            width: 80.w,
                                            height: 80.h,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person_rounded,
                                              color: AppColors.black,
                                              size: 40.sp,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person_rounded,
                                            color: AppColors.black,
                                            size: 40.sp,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 26.w,
                                    height: 26.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2.w,
                                        color: AppColors.yellow3,
                                      ),
                                    ),
                                    child: profileState.isUploadingAvatar
                                        ? Padding(
                                            padding: EdgeInsets.all(4.r),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.yellow3,
                                            ),
                                          )
                                        : Icon(
                                            Icons.camera_alt_rounded,
                                            color: AppColors.yellow3,
                                            size: 13.sp,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.h.ph,

                          // Name
                          Text(
                            profile?.fullName ?? '—',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: TextWeight.bold,
                                ),
                          ),
                          4.h.ph,
                          // Email
                          Text(
                            profile?.email ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.black
                                          .withValues(alpha: 0.6),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Scrollable content ─────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Account section ──────────────────
                          _SectionLabel(label: 'Account'),
                          12.h.ph,
                          _MenuCard(
                            children: [
                              _MenuTile(
                                icon: AppImages.profileIcon,
                                label: AppStrings.personalDetail,
                                onTap: () => goRouter
                                    .push(AppRoutes.oPersonalDetailScreen),
                              ),
                              _MenuTile(
                                icon: AppImages.paymentcardsIcon,
                                label: AppStrings.paymentMethods,
                                onTap: () => goRouter
                                    .push(AppRoutes.oPaymentMethodScreen),
                                showDivider: false,
                              ),
                            ],
                          ),

                          20.h.ph,

                          // ── Preferences section ──────────────
                          _SectionLabel(label: 'Preferences'),
                          12.h.ph,
                          _MenuCard(
                            children: [
                              _MenuTile(
                                icon: AppImages.settingIcon,
                                label: AppStrings.settings,
                                onTap: () =>
                                    goRouter.push(AppRoutes.oSettingScreen),
                              ),
                              _MenuTile(
                                icon: AppImages.helpIcon,
                                label: AppStrings.helpAndSupport,
                                onTap: () {},
                                showDivider: false,
                              ),
                            ],
                          ),

                          20.h.ph,

                          // ── Logout ───────────────────────────
                          _MenuCard(
                            color: AppColors.red57.withValues(alpha: 0.08),
                            borderColor:
                                AppColors.red57.withValues(alpha: 0.15),
                            children: [
                              _MenuTile(
                                icon: AppImages.logoutIcon,
                                label: AppStrings.logout,
                                iconColor: AppColors.red57,
                                textColor: AppColors.red57,
                                arrowColor: AppColors.red57,
                                iconBgColor:
                                    AppColors.red57.withValues(alpha: 0.1),
                                showDivider: false,
                                onTap: () async {
                                  await UserPreferences.clearAll();
                                  if (context.mounted) {
                                    goRouter.go(AppRoutes.ordererLoginScreen);
                                  }
                                },
                              ),
                            ],
                          ),

                          24.h.ph,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.labelGray,
              fontWeight: TextWeight.semiBold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

// ── Card container that groups menu tiles ─────────────────────────
class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final Color? borderColor;

  const _MenuCard({
    required this.children,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.yellow1,
        borderRadius: BorderRadius.circular(14.r),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Column(children: children),
    );
  }
}

// ── Single menu tile ──────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;
  final Color? iconColor;
  final Color? textColor;
  final Color? arrowColor;
  final Color? iconBgColor;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
    this.iconColor,
    this.textColor,
    this.arrowColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color:
                        iconBgColor ?? AppColors.yellow3.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: SharePictures(
                      imagePath: icon,
                      width: 17.w,
                      height: 17.h,
                      colorFilter: ColorFilter.mode(
                        iconColor ?? AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                14.w.pw,
                // Label
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor ?? AppColors.black,
                          fontWeight: TextWeight.medium,
                        ),
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: arrowColor ?? AppColors.labelGray,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 64.w, right: 16.w),
            child: Divider(
              height: 1,
              color: AppColors.lightGray.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}
