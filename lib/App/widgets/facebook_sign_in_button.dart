import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/auth/facebook_auth_view_model.dart';

/// Reusable "Continue with Facebook" button matching web's Auth.tsx
///
/// [role] controls where the user lands after a successful existing-user login:
///   - 'PICKER'  → pickerBottomBarScreen
///   - 'ORDERER' → ordererBottomBarScreen
///
/// New users always go to profile setup regardless of role.
class FacebookSignInButton extends ConsumerWidget {
  final String role; // 'PICKER' or 'ORDERER'

  const FacebookSignInButton({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(facebookAuthProvider);

    // Listen and navigate / show error
    ref.listen<FacebookAuthState>(facebookAuthProvider, (previous, next) {
      // Error
      if (previous?.errorMessage == null && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red57,
          ),
        );
        ref.read(facebookAuthProvider.notifier).resetState();
        return;
      }

      // Success — isNewUser flipped from null to a value
      if (previous?.isNewUser == null && next.isNewUser != null) {
        ref.read(facebookAuthProvider.notifier).resetState();
        if (next.isNewUser == true) {
          // New user → profile setup (matches web: navigate('/profile-setup'))
          context.go(AppRoutes.ordererProfileSetupScreen);
        } else {
          // Existing user → correct dashboard
          if (role == 'PICKER') {
            context.go(AppRoutes.pickerBottomBarScreen);
          } else {
            context.go(AppRoutes.ordererBottomBarScreen);
          }
        }
      }
    });

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        onPressed: state.isLoading
            ? null
            : () => ref.read(facebookAuthProvider.notifier).signInWithFacebook(),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: const Color(0xFFDDDDDD), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          disabledBackgroundColor: Colors.white.withOpacity(0.6),
        ),
        child: state.isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.labelGray,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook logo - matching web's SVG
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: CustomPaint(painter: _FacebookLogoPainter()),
                  ),
                  12.w.pw,
                  Text(
                    'Continue with Facebook',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: TextWeight.semiBold,
                      color: AppColors.black,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Facebook logo painter - matching web's SVG path
class _FacebookLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1877F2)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final sx = w / 24;
    final sy = h / 24;

    final path = Path()
      ..moveTo(22.675 * sx, 0)
      ..lineTo(1.325 * sx, 0)
      ..cubicTo(0.593 * sx, 0, 0, 0.593 * sy, 0, 1.325 * sy)
      ..lineTo(0, 22.676 * sy)
      ..cubicTo(0, 23.407 * sy, 0.593 * sx, 24 * sy, 1.325 * sx, 24 * sy)
      ..lineTo(12.82 * sx, 24 * sy)
      ..lineTo(12.82 * sx, 14.706 * sy)
      ..lineTo(9.692 * sx, 14.706 * sy)
      ..lineTo(9.692 * sx, 11.04 * sy)
      ..lineTo(12.82 * sx, 11.04 * sy)
      ..lineTo(12.82 * sx, 8.414 * sy)
      ..cubicTo(12.82 * sx, 5.314 * sy, 14.713 * sx, 3.626 * sy, 17.479 * sx, 3.626 * sy)
      ..cubicTo(18.804 * sx, 3.626 * sy, 19.942 * sx, 3.725 * sy, 20.273 * sx, 3.769 * sy)
      ..lineTo(20.273 * sx, 7.009 * sy)
      ..lineTo(18.355 * sx, 7.01 * sy)
      ..cubicTo(16.851 * sx, 7.01 * sy, 16.56 * sx, 7.726 * sy, 16.56 * sx, 8.773 * sy)
      ..lineTo(16.56 * sx, 11.04 * sy)
      ..lineTo(20.147 * sx, 11.04 * sy)
      ..lineTo(19.68 * sx, 14.706 * sy)
      ..lineTo(16.56 * sx, 14.706 * sy)
      ..lineTo(16.56 * sx, 24 * sy)
      ..lineTo(22.676 * sx, 24 * sy)
      ..cubicTo(23.407 * sx, 24 * sy, 24 * sx, 23.407 * sy, 24 * sx, 22.676 * sy)
      ..lineTo(24 * sx, 1.325 * sy)
      ..cubicTo(24 * sx, 0.593 * sy, 23.407 * sx, 0, 22.675 * sx, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
