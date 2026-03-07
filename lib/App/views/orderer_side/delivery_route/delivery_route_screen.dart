import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';
import 'package:jet_picks_app/App/view_model/location/location_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_divider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_formfeild.dart';

class DeliveryRouteScreen extends ConsumerStatefulWidget {
  const DeliveryRouteScreen({super.key});

  @override
  ConsumerState<DeliveryRouteScreen> createState() =>
      _DeliveryRouteScreenState();
}

class _DeliveryRouteScreenState extends ConsumerState<DeliveryRouteScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationViewModelProvider.notifier).fetchCountries();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(createOrderProvider);
    final locationState = ref.watch(locationViewModelProvider);
    final orderVM = ref.read(createOrderProvider.notifier);
    final locationVM = ref.read(locationViewModelProvider.notifier);

    final countryNames =
        locationState.countries.map((c) => c.name).toList();

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.deliveryRoute,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (orderState.hasPickerRoute) ...[
                12.h.ph,
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8D6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Pre-filled from selected picker route',
                    style: TextStyle(
                        color: AppColors.labelGray, fontSize: 12.sp),
                  ),
                ),
              ],
              35.h.ph,

              // ── Origin Country ──
              CustomDropDown(
                selectedValue: orderState.originCountry.isNotEmpty
                    ? orderState.originCountry
                    : null,
                hintText: AppStrings.country,
                labelText: AppStrings.chooseCountryAndCity,
                prefixIcon: AppImages.locationLineIcon,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                labelTextColor: AppColors.black,
                preficIconColor: AppColors.black,
                sufixColor: AppColors.black,
                items: countryNames,
                onChanged: (value) {
                  if (value != null) {
                    orderVM.setOriginCountry(value);
                    orderVM.setOriginCity('');
                    locationVM.fetchDepartureCities(value);
                  }
                },
              ),
              CustomDivider(indent: 20),
              10.h.ph,

              // ── Origin City ──
              CustomDropDown(
                selectedValue: orderState.originCity.isNotEmpty &&
                        locationState.departureCities
                            .contains(orderState.originCity)
                    ? orderState.originCity
                    : null,
                hintText: AppStrings.city,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                sufixColor: AppColors.black,
                items: locationState.departureCities,
                onChanged: (value) {
                  if (value != null) orderVM.setOriginCity(value);
                },
              ),
              32.h.ph,

              // ── Destination Country ──
              CustomDropDown(
                selectedValue: orderState.destinationCountry.isNotEmpty
                    ? orderState.destinationCountry
                    : null,
                hintText: AppStrings.country,
                labelText: AppStrings.chooseReceivingCountryAndCity,
                prefixIcon: AppImages.locationLineIcon,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                labelTextColor: AppColors.black,
                preficIconColor: AppColors.black,
                sufixColor: AppColors.black,
                items: countryNames,
                onChanged: (value) {
                  if (value != null) {
                    orderVM.setDestinationCountry(value);
                    orderVM.setDestinationCity('');
                    locationVM.fetchArrivalCities(value);
                  }
                },
              ),
              CustomDivider(indent: 20),
              10.h.ph,

              // ── Destination City ──
              CustomDropDown(
                selectedValue: orderState.destinationCity.isNotEmpty &&
                        locationState.arrivalCities
                            .contains(orderState.destinationCity)
                    ? orderState.destinationCity
                    : null,
                hintText: AppStrings.city,
                hintTextColor: AppColors.labelGray,
                dropDownTextColor: AppColors.black,
                sufixColor: AppColors.black,
                items: locationState.arrivalCities,
                onChanged: (value) {
                  if (value != null) orderVM.setDestinationCity(value);
                },
              ),
              51.h.ph,

              // ── Special Notes ──
              Text(
                AppStrings.specialNotes,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              16.h.ph,
              CustomTextFormfeild(
                hintText: 'Write here',
                controller: _notesController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
