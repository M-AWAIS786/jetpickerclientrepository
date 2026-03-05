import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/models/travel/travel_journey_model.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/location/location_view_model.dart';
import 'package:jet_picks_app/App/view_model/travel/travel_journey_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';

class TravelDetailSetupScreen extends ConsumerStatefulWidget {
  const TravelDetailSetupScreen({super.key});

  @override
  ConsumerState<TravelDetailSetupScreen> createState() =>
      _TravelDetailSetupScreenState();
}

class _TravelDetailSetupScreenState
    extends ConsumerState<TravelDetailSetupScreen> {
  String? _depCountry;
  String? _depCity;
  String? _arrCountry;
  String? _arrCity;
  DateTime? _departureDate;
  DateTime? _arrivalDate;
  String? _luggage;

  // null  = haven't checked yet (reset on every open)
  // false = checked, no journey found
  // true  = pre-fill done
  bool? _prefillStatus;

  static const List<String> _luggageOptions = [
    '5 kg',
    '10 kg',
    '15 kg',
    '20 kg',
    '25 kg',
    '30 kg',
  ];

  @override
  void initState() {
    super.initState();
    // Reset pre-fill flag and re-fetch every time the screen opens
    _prefillStatus = null;
    Future.microtask(() {
      ref.read(travelJourneyViewModelProvider.notifier).fetchTravelJourneys();
    });
  }

  /// Converts a raw kg string from the API (e.g. "20" or "20kg") to
  /// the display format expected by [_luggageOptions] (e.g. "20 kg").
  String? _normalizeLuggage(String raw) {
    // Normalise "20kg" → "20 kg"
    final cleaned = raw.trim().replaceAllMapped(
      RegExp(r'^(\d+)\s*kg$', caseSensitive: false),
      (m) => '${m[1]} kg',
    );
    return _luggageOptions.contains(cleaned) ? cleaned : null;
  }

  void _prefillFromJourney(TravelJourneyModel journey) {
    setState(() {
      _depCountry = journey.departureCountry;
      _depCity = journey.departureCity;
      _arrCountry = journey.arrivalCountry;
      _arrCity = journey.arrivalCity;
      _departureDate = journey.departureDate;
      _arrivalDate = journey.arrivalDate;
      _luggage = _normalizeLuggage(journey.luggageWeightCapacity);
      _prefillStatus = true;
    });

    // Trigger city lists so the pre-filled city values are selectable
    final locVM = ref.read(locationViewModelProvider.notifier);
    locVM.fetchDepartureCities(journey.departureCountry);
    locVM.fetchArrivalCities(journey.arrivalCountry);
  }

  Future<void> _pickDate(BuildContext context,
      {required bool isDeparture}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeparture
          ? (_departureDate ?? now)
          : (_arrivalDate ?? (_departureDate ?? now)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.red3,
            onPrimary: AppColors.white,
            onSurface: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          if (_arrivalDate != null && _arrivalDate!.isBefore(picked)) {
            _arrivalDate = null;
          }
        } else {
          _arrivalDate = picked;
        }
      });
    }
  }

  Future<void> _onSave() async {
    // Validate all fields
    if (_depCountry == null ||
        _depCity == null ||
        _arrCountry == null ||
        _arrCity == null ||
        _departureDate == null ||
        _arrivalDate == null ||
        _luggage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final vm = ref.read(travelJourneyViewModelProvider.notifier);
    final success = await vm.saveJourney(
      departureCountry: _depCountry!,
      departureCity: _depCity!,
      departureDate: DateFormat('yyyy-MM-dd').format(_departureDate!),
      arrivalCountry: _arrCountry!,
      arrivalCity: _arrCity!,
      arrivalDate: DateFormat('yyyy-MM-dd').format(_arrivalDate!),
      luggageDisplay: _luggage!,
    );

    if (!mounted) return;

    if (success) {
      if (context.mounted) context.pop();  // ✅ pop back to TravelDetailScreen
    } else {
      final error = ref.read(travelJourneyViewModelProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to save journey.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locState = ref.watch(locationViewModelProvider);
    final locVM = ref.read(locationViewModelProvider.notifier);
    final countryNames = locState.countries.map((c) => c.name).toList();

    // Watch journey state — pre-fill ONLY after loading completes
    final journeyState = ref.watch(travelJourneyViewModelProvider);

    // _prefillStatus == null means we haven't acted yet
    if (_prefillStatus == null && !journeyState.isLoading) {
      final existing = journeyState.activeJourney;
      if (existing != null) {
        // Schedule after current frame to avoid setState-during-build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _prefillFromJourney(existing);
        });
      }
      // Mark as checked regardless (null → false means "checked, nothing found")
      _prefillStatus = false;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: journeyState.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.red3),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppStrings.shareYourTravelDetail,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.labelGray, height: 1.5),
                          ),
                        ),
                        28.h.ph,

                        // ── Departure ────────────────────────────────────────
                        _SectionLabel(
                          icon: AppImages.locationLineIcon,
                          label: AppStrings.departureCountryandCity,
                        ),
                        12.h.ph,
                        Row(
                          children: [
                            Expanded(
                              child: _ApiDropdown(
                                hint: AppStrings.country,
                                value: _depCountry,
                                items: countryNames,
                                isLoading: locState.loadingCountries,
                                onChanged: (val) {
                                  setState(() {
                                    _depCountry = val;
                                    _depCity = null;
                                  });
                                  if (val != null) {
                                    locVM.fetchDepartureCities(val);
                                  }
                                },
                              ),
                            ),
                            12.w.pw,
                            Expanded(
                              child: _ApiDropdown(
                                hint: AppStrings.city,
                                value: _depCity,
                                items: locState.departureCities,
                                isLoading: locState.loadingDepartureCities,
                                enabled: _depCountry != null,
                                onChanged: (val) =>
                                    setState(() => _depCity = val),
                              ),
                            ),
                          ],
                        ),
                        20.h.ph,

                        // ── Arrival ──────────────────────────────────────────
                        _SectionLabel(
                          icon: AppImages.locationLineIcon,
                          label: AppStrings.arrivalCountryandCity,
                          iconColor: AppColors.red3,
                        ),
                        12.h.ph,
                        Row(
                          children: [
                            Expanded(
                              child: _ApiDropdown(
                                hint: AppStrings.country,
                                value: _arrCountry,
                                items: countryNames,
                                isLoading: locState.loadingCountries,
                                onChanged: (val) {
                                  setState(() {
                                    _arrCountry = val;
                                    _arrCity = null;
                                  });
                                  if (val != null) {
                                    locVM.fetchArrivalCities(val);
                                  }
                                },
                              ),
                            ),
                            12.w.pw,
                            Expanded(
                              child: _ApiDropdown(
                                hint: AppStrings.city,
                                value: _arrCity,
                                items: locState.arrivalCities,
                                isLoading: locState.loadingArrivalCities,
                                enabled: _arrCountry != null,
                                onChanged: (val) =>
                                    setState(() => _arrCity = val),
                              ),
                            ),
                          ],
                        ),
                        24.h.ph,

                        // ── Dates ────────────────────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: _DateTile(
                                icon: AppImages.calendarIcon,
                                label: 'Departure Date',
                                value: _departureDate != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(_departureDate!)
                                    : AppStrings.selectDate,
                                hasValue: _departureDate != null,
                                onTap: () =>
                                    _pickDate(context, isDeparture: true),
                              ),
                            ),
                            12.w.pw,
                            Expanded(
                              child: _DateTile(
                                icon: AppImages.calendarIcon,
                                label: AppStrings.arrivalDate,
                                value: _arrivalDate != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(_arrivalDate!)
                                    : AppStrings.selectDate,
                                hasValue: _arrivalDate != null,
                                onTap: () =>
                                    _pickDate(context, isDeparture: false),
                              ),
                            ),
                          ],
                        ),
                        24.h.ph,

                        // ── Luggage ──────────────────────────────────────────
                        _SectionLabel(
                          icon: AppImages.lagageIcon,
                          label: AppStrings.luggage,
                        ),
                        12.h.ph,
                        _ApiDropdown(
                          hint: AppStrings.selectWeight,
                          value: _luggage,
                          items: _luggageOptions,
                          onChanged: (val) => setState(() => _luggage = val),
                        ),
                        40.h.ph,

                        // ── Save button ──────────────────────────────────────
                        journeyState.isSaving
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.red3),
                              )
                            : CustomButton(
                                text: AppStrings.saveAndContinue,
                                onPressed: _onSave,
                              ),
                        24.h.ph,
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header widget ──────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.red3,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.red2,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_rounded,
                      color: AppColors.white, size: 20.sp),
                ),
              ),
              Expanded(
                child: Text(
                  AppStrings.travelAvailabilitySetup,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Section Label ─────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String icon;
  final String label;
  final Color? iconColor;

  const _SectionLabel({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SharePictures(
          imagePath: icon,
          width: 16.w,
          height: 16.h,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.red3,
            BlendMode.srcIn,
          ),
        ),
        8.w.pw,
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.red2,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

// ── API-backed Dropdown ────────────────────────────────────────────────────
class _ApiDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isLoading;
  final bool enabled;

  const _ApiDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
    this.enabled = true,
  });

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DropdownSheet(
        hint: hint,
        items: items,
        selected: value,
        onSelected: (val) {
          Navigator.pop(context);
          onChanged(val);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled && !isLoading) ? () => _openSheet(context) : null,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: enabled ? AppColors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: value != null ? AppColors.red3 : AppColors.greyDD,
            width: value != null ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.red3,
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      value ?? hint,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: value != null
                                ? AppColors.black
                                : AppColors.labelGray,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: enabled ? AppColors.red3 : AppColors.labelGray,
                    size: 20.sp,
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Bottom Sheet Picker ────────────────────────────────────────────────────
class _DropdownSheet extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _DropdownSheet({
    required this.hint,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_DropdownSheet> createState() => _DropdownSheetState();
}

class _DropdownSheetState extends State<_DropdownSheet> {
  late List<String> _filtered;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _search.addListener(() {
      final q = _search.text.toLowerCase();
      setState(() {
        _filtered = q.isEmpty
            ? widget.items
            : widget.items
                .where((e) => e.toLowerCase().contains(q))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sheet takes max 55% of screen height
    final maxHeight = MediaQuery.of(context).size.height * 0.55;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyDD,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          // title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text(
              widget.hint,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.red3,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          // search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: _search,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.labelGray),
                prefixIcon:
                    Icon(Icons.search, color: AppColors.labelGray, size: 18.sp),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // list
          Flexible(
            child: _filtered.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Text(
                      'No results found',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.labelGray),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: AppColors.greyDD.withOpacity(0.5),
                    ),
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      final isSelected = item == widget.selected;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8.w),
                        title: Text(
                          item,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? AppColors.red3
                                    : AppColors.black,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_rounded,
                                color: AppColors.red3, size: 18.sp)
                            : null,
                        onTap: () => widget.onSelected(item),
                      );
                    },
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
        ],
      ),
    );
  }
}

// ── Date Tile ─────────────────────────────────────────────────────────────
class _DateTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final bool hasValue;
  final VoidCallback onTap;

  const _DateTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.hasValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasValue ? AppColors.red3 : AppColors.greyDD,
            width: hasValue ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SharePictures(
              imagePath: icon,
              width: 16.w,
              height: 16.h,
              colorFilter: ColorFilter.mode(
                hasValue ? AppColors.red3 : AppColors.labelGray,
                BlendMode.srcIn,
              ),
            ),
            8.w.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.red3,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  2.h.ph,
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasValue ? AppColors.black : AppColors.labelGray,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
