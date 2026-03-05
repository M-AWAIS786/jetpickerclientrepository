import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/models/travel/travel_journey_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/travel/travel_journey_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class TravelDetailScreen extends ConsumerStatefulWidget {
  const TravelDetailScreen({super.key});

  @override
  ConsumerState<TravelDetailScreen> createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends ConsumerState<TravelDetailScreen> {
  static const List<String> _luggageOptions = [
    '5 kg', '10 kg', '15 kg', '20 kg',
    '25 kg', '30 kg'
  ];

  String? _selectedLuggage;
  bool _luggageInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchJourneys();
  }

  void _fetchJourneys() {
    _luggageInitialized = false;
    Future.microtask(() {
      ref.read(travelJourneyViewModelProvider.notifier).fetchTravelJourneys();
    });
  }

  String? _normalizeLuggage(String raw) {
    final cleaned = raw.trim().replaceAllMapped(
      RegExp(r'^(\d+)\s*kg$', caseSensitive: false),
      (m) => '${m[1]} kg',
    );
    return _luggageOptions.contains(cleaned) ? cleaned : null;
  }

  Future<void> _saveluggage() async {
    if (_selectedLuggage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a luggage weight.')),
      );
      return;
    }
    final success = await ref
        .read(travelJourneyViewModelProvider.notifier)
        .updateLuggage(_selectedLuggage!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Luggage capacity updated successfully.'
            : ref.read(travelJourneyViewModelProvider).error ??
                'Failed to update luggage.'),
        backgroundColor: success ? AppColors.green1E : AppColors.red1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journeyState = ref.watch(travelJourneyViewModelProvider);
    final active = journeyState.activeJourney;

    if (!_luggageInitialized && !journeyState.isLoading) {
      _luggageInitialized = true;
      if (active != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedLuggage = _normalizeLuggage(active.luggageWeightCapacity);
            });
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        leadingIcon: true,
        title: AppStrings.travelDetails,
        titleColor: AppColors.white,
      ),
      body: journeyState.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.red3))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  28.h.ph,

                  // ── Travel History Section ────────────────────────────
                  _sectionLabel(context, AppStrings.travelHistory,
                      icon: AppImages.travelDetailIcon),
                  16.h.ph,

                  if (journeyState.journeys.isEmpty)
                    _emptyJourneysCard(context)
                  else
                    ...journeyState.journeys.map(
                      (j) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _JourneyCard(journey: j),
                      ),
                    ),

                  16.h.ph,
                  CustomButton(
                    text: AppStrings.createNewJourney,
                    onPressed: () async {
                      await goRouter.push(AppRoutes.travelDetailSetupScreen);
                      _fetchJourneys();
                    },
                  ),

                  32.h.ph,

                  // ── Weight Capacity Section ───────────────────────────
                  _sectionLabel(context, AppStrings.updateWeightCapacity,
                      icon: AppImages.lagageIcon),
                  12.h.ph,

                  if (active == null)
                    _noActiveJourneyNote(context)
                  else
                    _activeJourneyNote(context, active),

                  12.h.ph,

                  // Luggage field card
                  _luggageFieldCard(context, active),

                  32.h.ph,

                  journeyState.isSaving
                      ? Center(
                          child: CircularProgressIndicator(color: AppColors.red3))
                      : CustomButton(
                          text: AppStrings.save,
                          onPressed: active != null ? _saveluggage : null,
                          color: active != null
                              ? AppColors.red3
                              : AppColors.lightGray,
                        ),

                  36.h.ph,
                ],
              ),
            ),
    );
  }

  // ── Section label with accent bar ──────────────────────────────────────
  Widget _sectionLabel(BuildContext ctx, String label, {String? icon}) {
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
        if (icon != null) ...[
          SharePictures(
            imagePath: icon,
            width: 16.w,
            height: 16.h,
            colorFilter:
                ColorFilter.mode(AppColors.red3, BlendMode.srcIn),
          ),
          6.w.pw,
        ],
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

  // ── Empty journeys state ────────────────────────────────────────────────
  Widget _emptyJourneysCard(BuildContext ctx) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          SharePictures(
            imagePath: AppImages.travelDetailIcon,
            width: 36.w,
            height: 36.h,
            colorFilter: ColorFilter.mode(
                AppColors.red3.withOpacity(0.35), BlendMode.srcIn),
          ),
          12.h.ph,
          Text(
            'No travel journeys yet',
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: AppColors.labelGray,
                  fontWeight: TextWeight.semiBold,
                ),
          ),
          4.h.ph,
          Text(
            'Create your first journey to get started',
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: AppColors.labelGray,
                ),
          ),
        ],
      ),
    );
  }

  // ── No active journey note ──────────────────────────────────────────────
  Widget _noActiveJourneyNote(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.yellow1,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.yellow3.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.starsColor, size: 18.sp),
          8.w.pw,
          Expanded(
            child: Text(
              'Create a journey first to update your luggage capacity.',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active journey note ─────────────────────────────────────────────────
  Widget _activeJourneyNote(BuildContext ctx, dynamic active) {
    final route =
        '${active.departureCity} → ${active.arrivalCity}';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(10.r),
        border:
            Border.all(color: AppColors.red3.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          SharePictures(
            imagePath: AppImages.planIcon,
            width: 18.w,
            height: 18.h,
            colorFilter:
                ColorFilter.mode(AppColors.red3, BlendMode.srcIn),
          ),
          8.w.pw,
          Expanded(
            child: Text(
              'Active journey: $route',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: AppColors.red3,
                    fontWeight: TextWeight.semiBold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Luggage field card ──────────────────────────────────────────────────
  Widget _luggageFieldCard(BuildContext ctx, dynamic active) {
    final enabled = active != null;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: enabled ? AppColors.redLight : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _selectedLuggage != null
              ? AppColors.red3.withOpacity(0.4)
              : Colors.transparent,
          width: _selectedLuggage != null ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SharePictures(
                imagePath: AppImages.lagageIcon,
                width: 16.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                    AppColors.red3.withOpacity(0.55), BlendMode.srcIn),
              ),
              8.w.pw,
              Text(
                AppStrings.luggage,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: AppColors.labelGray,
                      fontWeight: TextWeight.semiBold,
                    ),
              ),
            ],
          ),
          4.h.ph,
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLuggage,
                isExpanded: true,
                isDense: true,
                hint: Text(
                  AppStrings.selectWeight,
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                        color: AppColors.labelGray,
                      ),
                ),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.red3, size: 20.sp),
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: AppColors.red3,
                      fontWeight: TextWeight.medium,
                    ),
                onChanged: enabled
                    ? (val) => setState(() => _selectedLuggage = val)
                    : null,
                items: _luggageOptions
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Journey Card ────────────────────────────────────────────────────────────
class _JourneyCard extends StatelessWidget {
  final TravelJourneyModel journey;
  const _JourneyCard({required this.journey});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d, yyyy').format(journey.departureDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.red3.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.red3.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SharePictures(
                imagePath: AppImages.planIcon,
                width: 18.w,
                height: 18.h,
                colorFilter:
                    ColorFilter.mode(AppColors.red3, BlendMode.srcIn),
              ),
            ),
          ),
          12.w.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${journey.departureCity}, ${journey.departureCountry}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppColors.labelGray,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(Icons.arrow_forward_rounded,
                          color: AppColors.red3, size: 14.sp),
                    ),
                    Expanded(
                      child: Text(
                        '${journey.arrivalCity}, ${journey.arrivalCountry}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppColors.labelGray,
                            ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                6.h.ph,
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: AppColors.red3.withOpacity(0.6),
                        size: 12.sp),
                    4.w.pw,
                    Text(
                      date,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: AppColors.red3,
                            fontWeight: TextWeight.semiBold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
