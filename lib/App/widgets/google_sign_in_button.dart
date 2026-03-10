import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/auth/google_auth_view_model.dart';

/// Reusable "Continue with Google" button.
///
/// [role] controls where the user lands after a successful existing-user login:
///   - 'PICKER'  → pickerBottomBarScreen
///   - 'ORDERER' → ordererBottomBarScreen
///
/// New users always go to profile setup regardless of role.
class GoogleSignInButton extends ConsumerWidget {
  final String role; // 'PICKER' or 'ORDERER'

  const GoogleSignInButton({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(googleAuthProvider);

    // Listen and navigate / show error
    ref.listen<GoogleAuthState>(googleAuthProvider, (previous, next) {
      // Error
      if (previous?.errorMessage == null && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red57,
          ),
        );
        ref.read(googleAuthProvider.notifier).resetState();
        return;
      }

      // Success — isNewUser flipped from null to a value
      if (previous?.isNewUser == null && next.isNewUser != null) {
        ref.read(googleAuthProvider.notifier).resetState();
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
            : () => ref.read(googleAuthProvider.notifier).signInWithGoogle(),
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
                  // Google 'G' logo — same SVG paths as web frontend
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: CustomPaint(painter: _GoogleLogoPainter()),
                  ),
                  12.w.pw,
                  Text(
                    'Continue with Google',
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

// ─────────────────────────────────────────────────────────────
// Divider row — "OR" separator
// ─────────────────────────────────────────────────────────────
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.greyDD, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: TextWeight.medium,
                color: AppColors.labelGray,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.greyDD, thickness: 1)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Google logo painter — same 4 coloured paths as web SVG
// ─────────────────────────────────────────────────────────────
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Blue — top right
    final blue = Paint()..color = const Color(0xFF4285F4);
    final greenP = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final red = Paint()..color = const Color(0xFFEA4335);

    // Scale factor relative to 24×24 viewBox
    final sx = w / 24;
    final sy = h / 24;

    // Blue path (top / right)
    final bluePath = Path()
      ..moveTo(22.56 * sx, 12.25 * sy)
      ..cubicTo(22.56 * sx, 11.47 * sy, 22.49 * sx, 10.72 * sy,
          22.36 * sx, 10 * sy)
      ..lineTo(12 * sx, 10 * sy)
      ..lineTo(12 * sx, 14.26 * sy)
      ..lineTo(17.92 * sx, 14.26 * sy)
      ..cubicTo(17.66 * sx, 15.63 * sy, 16.88 * sx, 16.79 * sy,
          15.71 * sx, 17.57 * sy)
      ..lineTo(15.71 * sx, 20.34 * sy)
      ..lineTo(19.28 * sx, 20.34 * sy)
      ..cubicTo(21.36 * sx, 18.42 * sy, 22.56 * sx, 15.6 * sy,
          22.56 * sx, 12.25 * sy)
      ..close();
    canvas.drawPath(bluePath, blue);

    // Green path (bottom)
    final greenPath = Path()
      ..moveTo(12 * sx, 23 * sy)
      ..cubicTo(14.97 * sx, 23 * sy, 17.46 * sx, 22.02 * sy,
          19.28 * sx, 20.34 * sy)
      ..lineTo(15.71 * sx, 17.57 * sy)
      ..cubicTo(14.73 * sx, 18.23 * sy, 13.48 * sx, 18.63 * sy,
          12 * sx, 18.63 * sy)
      ..cubicTo(9.14 * sx, 18.63 * sy, 6.71 * sx, 16.7 * sy,
          5.84 * sx, 14.1 * sy)
      ..lineTo(2.18 * sx, 14.1 * sy)
      ..lineTo(2.18 * sx, 16.94 * sy)
      ..cubicTo(3.99 * sx, 20.53 * sy, 7.7 * sx, 23 * sy, 12 * sx, 23 * sy)
      ..close();
    canvas.drawPath(greenPath, greenP);

    // Yellow path (left / bottom-left)
    final yellowPath = Path()
      ..moveTo(5.84 * sx, 14.09 * sy)
      ..cubicTo(5.62 * sx, 13.43 * sy, 5.49 * sx, 12.73 * sy,
          5.49 * sx, 12 * sy)
      ..cubicTo(5.49 * sx, 11.27 * sy, 5.62 * sx, 10.57 * sy,
          5.84 * sx, 9.91 * sy)
      ..lineTo(5.84 * sx, 7.07 * sy)
      ..lineTo(2.18 * sx, 7.07 * sy)
      ..cubicTo(1.43 * sx, 8.55 * sy, 1 * sx, 10.22 * sy, 1 * sx, 12 * sy)
      ..cubicTo(1 * sx, 13.78 * sy, 1.43 * sx, 15.45 * sy,
          2.18 * sx, 16.93 * sy)
      ..lineTo(5.84 * sx, 14.09 * sy)
      ..close();
    canvas.drawPath(yellowPath, yellow);

    // Red path (top-left)
    final redPath = Path()
      ..moveTo(12 * sx, 5.38 * sy)
      ..cubicTo(13.62 * sx, 5.38 * sy, 15.06 * sx, 5.94 * sy,
          16.21 * sx, 7.02 * sy)
      ..lineTo(19.36 * sx, 3.87 * sy)
      ..cubicTo(17.45 * sx, 2.09 * sy, 14.97 * sx, 1 * sy,
          12 * sx, 1 * sy)
      ..cubicTo(7.7 * sx, 1 * sy, 3.99 * sx, 3.47 * sy,
          2.18 * sx, 7.07 * sy)
      ..lineTo(5.84 * sx, 9.91 * sy)
      ..cubicTo(6.71 * sx, 7.31 * sy, 9.14 * sx, 5.38 * sy,
          12 * sx, 5.38 * sy)
      ..close();
    canvas.drawPath(redPath, red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
