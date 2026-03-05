import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/user_profile/user_profile_view_model.dart';
import 'package:jet_picks_app/App/widgets/listtile_arrow.dart';
import '../../../utils/share_pictures.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile when screen loads
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

    // Show snackbar on success / error from avatar upload
    ref.listen<UserProfileState>(userProfileViewModelProvider, (previous, next) {
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

    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.profile,
        titleColor: AppColors.white,
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red3))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.h.ph,
                _profileImage(
                  avatarUrl: profile?.avatarUrl,
                  isUploading: profileState.isUploadingAvatar,
                ),
                12.h.ph,
                Text(
                  profile?.fullName ?? AppStrings.userNameHint,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.red3),
                ),
                3.h.ph,
                Text(
                  profile?.phoneNumber ?? AppStrings.phoneNumberHint,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.labelGray),
                ),
                48.h.ph,
                ListTileArrow(
                  text: AppStrings.personalInformation,
                  prefixIcon: AppImages.profileIcon,
                  sufixIcon: AppImages.rightArrowIcon,
                  onTap: () => goRouter.push(AppRoutes.personalDetailScreen),
                ),
                12.h.ph,
                ListTileArrow(
                  text: AppStrings.travelDetails,
                  prefixIcon: AppImages.travelDetailIcon,
                  sufixIcon: AppImages.rightArrowIcon,
                  onTap: () => goRouter.push(AppRoutes.travelDetailScreen),
                ),
                12.h.ph,
                ListTileArrow(
                  text: AppStrings.settings,
                  prefixIcon: AppImages.settingIcon,
                  sufixIcon: AppImages.rightArrowIcon,
                  onTap: () => goRouter.push(AppRoutes.settingScreen),
                ),
                12.h.ph,
                ListTileArrow(
                  text: AppStrings.paymentMethods,
                  prefixIcon: AppImages.paymentcardsIcon,
                  sufixIcon: AppImages.rightArrowIcon,
                  onTap: () => goRouter.push(AppRoutes.paymentMethodScreen),
                ),
                12.h.ph,
                ListTileArrow(
                  containerColor: AppColors.white,
                  text: AppStrings.helpAndSupport,
                  prefixIcon: AppImages.helpIcon,
                  onTap: () {},
                ),
                ListTileArrow(
                  containerColor: AppColors.white,
                  text: AppStrings.logout,
                  prefixIcon: AppImages.logoutIcon,
                  onTap: () {},
                ),
              ],
            ),
    );
  }

  Widget _profileImage({String? avatarUrl, required bool isUploading}) {
    return GestureDetector(
      onTap: isUploading ? null : _pickAndUploadAvatar,
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              shape: BoxShape.circle,
              border: Border.all(width: 1.w, color: AppColors.red3),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        color: AppColors.labelGray,
                        size: 50,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: AppColors.labelGray,
                      size: 50,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.redLight,
                shape: BoxShape.circle,
                border: Border.all(width: 1.w, color: AppColors.red3),
              ),
              child: isUploading
                  ? Padding(
                      padding: EdgeInsets.all(6.r),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.red3,
                      ),
                    )
                  : Transform.scale(
                      scale: 0.6,
                      child: SharePictures(imagePath: AppImages.cameraIcon),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
