import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/models/travel/travel_journey_model.dart';
import 'package:jet_picks_app/App/routes/app_routes.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
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
    Future.microtask(() {
      ref.read(travelJourneyViewModelProvider.notifier).fetchTravelJourneys();
    });
  }

  /// Converts API value e.g. "20" or "20kg" → "20 kg" for the dropdown.
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
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journeyState = ref.watch(travelJourneyViewModelProvider);
    final active = journeyState.activeJourney;

    // Pre-select luggage from active journey once data loads
    if (!_luggageInitialized && !journeyState.isLoading && active != null) {
      _luggageInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedLuggage = _normalizeLuggage(active.luggageWeightCapacity);
        });
      });
    }

    return Scaffold(
      appBar: ProfileAppBar(
        title: AppStrings.travelDetails,
        titleColor: AppColors.white,
      ),
      body: journeyState.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.red3))
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.h.ph,

                  // ── Travel History ────────────────────────────────────────
                  Text(
                    AppStrings.travelHistory,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  17.h.ph,

                  if (journeyState.journeys.isEmpty)
                    Text(
                      'No travel journeys found.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.labelGray),
                    )
                  else
                    ...journeyState.journeys.map(
                      (j) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _JourneyRow(journey: j),
                      ),
                    ),

                  24.h.ph,
                  CustomButton(
                    text: AppStrings.createNewJourney,
                    onPressed: () =>
                        goRouter.push(AppRoutes.travelDetailSetupScreen),
                  ),

                  40.h.ph,

                  // ── Update Weight Capacity ────────────────────────────────
                  Text(
                    AppStrings.updateWeightCapacity,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppColors.red3),
                  ),
                  12.h.ph,

                  // Luggage dropdown
                  _LuggageDropdown(
                    value: _selectedLuggage,
                    options: _luggageOptions,
                    enabled: active != null,
                    onChanged: (val) => setState(() => _selectedLuggage = val),
                  ),

                  40.h.ph,

                  journeyState.isSaving
                      ? Center(
                          child: CircularProgressIndicator(
                              color: AppColors.red3),
                        )
                      : CustomButton(
                          text: AppStrings.save,
                          onPressed: active != null ? _saveluggage : null,
                        ),

                  40.h.ph,
                ],
              ),
            ),
    );
  }
}

// ── Journey Row ────────────────────────────────────────────────────────────
class _JourneyRow extends StatelessWidget {
  final TravelJourneyModel journey;
  const _JourneyRow({required this.journey});

  @override
  Widget build(BuildContext context) {
    // "From Islamabad, Pakistan → Islamabad, Pakistan"
    final route =
        'From ${journey.departureCity}, ${journey.departureCountry} '
        '→ ${journey.arrivalCity}, ${journey.arrivalCountry}';

    // "Mar 26"
    final date = DateFormat('MMM d').format(journey.departureDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            route,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.red1),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        8.w.pw,
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: AppColors.red1),
        ),
      ],
    );
  }
}

// ── Luggage Dropdown ───────────────────────────────────────────────────────
class _LuggageDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _LuggageDropdown({
    required this.value,
    required this.options,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: enabled ? AppColors.white : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value != null ? AppColors.red3 : AppColors.greyDD,
          width: value != null ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Select weight',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.labelGray),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.red3, size: 20.sp),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.black),
          onChanged: enabled ? onChanged : null,
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
        ),
      ),
    );
  }
}
