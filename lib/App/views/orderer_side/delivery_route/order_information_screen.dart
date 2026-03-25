import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jet_picks_app/App/utils/sizedbox_extension.dart';
import 'package:jet_picks_app/App/view_model/order/create_order_view_model.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_fontweight.dart';
import '../../../constants/app_strings.dart';

class OrderInformationScreen extends ConsumerStatefulWidget {
  const OrderInformationScreen({super.key});

  @override
  ConsumerState<OrderInformationScreen> createState() =>
      _OrderInformationScreenState();
}

class _OrderInformationScreenState
    extends ConsumerState<OrderInformationScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages(String itemId) async {
    final images = await _picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (images.isNotEmpty) {
      final files = images.map((xFile) => File(xFile.path)).toList();
      ref.read(createOrderProvider.notifier).addItemImages(itemId, files);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOrderProvider);
    final vm = ref.read(createOrderProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.orderInformation,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              8.h.ph,
              Text(
                'Add the items you want to order. You can add multiple items.',
                style: TextStyle(
                  color: AppColors.labelGray,
                  fontSize: 13.sp,
                ),
              ),
              20.h.ph,

              // ── Waiting Days ──
              Text(
                'How long can you wait? (days)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: TextWeight.semiBold,
                    ),
              ),
              10.h.ph,
              _buildTextField(
                value: state.waitingDays,
                hint: 'e.g. 14',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: vm.setWaitingDays,
              ),
              24.h.ph,

              // ── Items List ──
              ...state.items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return _buildItemCard(context, item, idx, state.items.length);
              }),

              // ── Add More Item ──
              Center(
                child: TextButton.icon(
                  onPressed: vm.addItem,
                  icon: Icon(Icons.add_circle_outline,
                      color: AppColors.black, size: 20.sp),
                  label: Text(
                    AppStrings.addMoreItem,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: TextWeight.semiBold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              20.h.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
      BuildContext context, CreateOrderItem item, int index, int total) {
    final vm = ref.read(createOrderProvider.notifier);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Item ${index + 1}',
                style: TextStyle(
                  fontWeight: TextWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              const Spacer(),
              if (total > 1)
                GestureDetector(
                  onTap: () => vm.removeItem(item.id),
                  child: Icon(Icons.close, color: AppColors.red57, size: 20.sp),
                ),
            ],
          ),
          12.h.ph,

          // ── Product Images ──
          Text(
            AppStrings.uploadProductImages,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.black,
                ),
          ),
          10.h.ph,
          SizedBox(
            height: 100.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Existing images
                ...item.images.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 90.w,
                        height: 90.h,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: FileImage(entry.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 10,
                        child: GestureDetector(
                          onTap: () =>
                              vm.removeItemImage(item.id, entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close,
                                color: Colors.white, size: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                // Add more photos
                GestureDetector(
                  onTap: () => _pickImages(item.id),
                  child: Container(
                    width: 90.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: AppColors.labelGray, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 24.sp, color: AppColors.labelGray),
                        4.h.ph,
                        Text(
                          'Add Photo',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.labelGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.h.ph,

          // ── Item Name ──
          _buildLabel(context, AppStrings.itemName),
          8.h.ph,
          _buildTextField(
            value: item.name,
            hint: 'e.g. Watch',
            onChanged: (v) => vm.updateItem(item.id, (i) => i.name = v),
          ),
          16.h.ph,

          // ── Store Link ──
          _buildLabel(context, AppStrings.storeLink),
          8.h.ph,
          _buildTextField(
            value: item.storeLink,
            hint: AppStrings.egAmazone,
            onChanged: (v) => vm.updateItem(item.id, (i) => i.storeLink = v),
          ),
          16.h.ph,

          // ── Weight ──
          _buildLabel(context, AppStrings.weight),
          8.h.ph,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTextField(
                  value: item.weight,
                  hint: '0.5',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) =>
                      vm.updateItem(item.id, (i) => i.weight = v),
                ),
              ),
              8.w.pw,
              Expanded(
                flex: 2,
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyDD),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: item.weightUnit,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'kg', child: Text('kg')),
                        DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                        DropdownMenuItem(value: 'g', child: Text('g')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          vm.updateItem(item.id, (i) => i.weightUnit = v);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.h.ph,

          // ── Price ──
          _buildLabel(context, AppStrings.priceOfItem),
          8.h.ph,
          _buildTextField(
            value: item.price,
            hint: '50',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => vm.updateItem(item.id, (i) => i.price = v),
          ),
          16.h.ph,

          // ── Quantity ──
          _buildLabel(context, AppStrings.quantity),
          8.h.ph,
          _buildTextField(
            value: item.quantity,
            hint: '1',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => vm.updateItem(item.id, (i) => i.quantity = v),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.black,
          ),
    );
  }

  Widget _buildTextField({
    required String value,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 14.sp,
        fontWeight: TextWeight.medium,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.labelGray, fontSize: 14.sp),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.greyDD),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.yellow3, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
    );
  }
}
