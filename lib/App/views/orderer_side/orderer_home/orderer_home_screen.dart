import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet_picks_app/App/constants/app_colors.dart';
import 'package:jet_picks_app/App/constants/app_fontweight.dart';
import 'package:jet_picks_app/App/constants/app_images.dart';
import 'package:jet_picks_app/App/constants/app_strings.dart';
import 'package:jet_picks_app/App/view_model/order_discovery/order_discovery_view_model.dart';
import 'package:jet_picks_app/App/widgets/custom_button.dart';
import 'package:jet_picks_app/App/widgets/custom_searchbar.dart';
import 'package:jet_picks_app/App/widgets/orderer_home_card.dart';
import 'package:jet_picks_app/App/utils/profile_appbar.dart';
import 'package:jet_picks_app/App/utils/share_pictures.dart';

class OrdererHomeScreen extends ConsumerStatefulWidget {
  const OrdererHomeScreen({super.key});

  @override
  ConsumerState<OrdererHomeScreen> createState() => _OrdererHomeScreenState();
}

class _OrdererHomeScreenState extends ConsumerState<OrdererHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordererDiscoveryViewModelProvider.notifier).fetchOrdererDiscovery();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      ref.read(ordererDiscoveryViewModelProvider.notifier).loadMoreOrderers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordererDiscoveryViewModelProvider);
    final viewModel = ref.read(ordererDiscoveryViewModelProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => viewModel.refreshOrderers(),
        child: Column(
          children: [
            ProfileAppBar(
              statusBarIconBrightness: Brightness.dark,
              title: AppStrings.fromLondonToMadrid,
              fontSize: 14.sp,
              fontWeight: TextWeight.medium,
              titleColor: AppColors.black,
              appBarColor: AppColors.yellow3,
              bellColor: AppColors.black,
              imagePath: AppImages.profileIcon,
              bottomHeight: 30.h,
            ),
            Transform.translate(
              offset: Offset(0.0, -20.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomSearchBar(
                  controller: _searchController,
                  prefixColor: AppColors.labelGray,
                  sufixColor: AppColors.labelGray,
                  onChanged: viewModel.setSearchQuery,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildBody(state, viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(OrdererDiscoveryState state, OrdererDiscoveryViewModel viewModel) {
    if (state.isLoading && state.orderers == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            20.0.verticalSpace,
            CustomButton(
              text: 'Retry',
              onPressed: () => viewModel.fetchOrdererDiscovery(refresh: true),
            ),
          ],
        ),
      );
    }

    if (state.isEmpty) {
      return const Center(
        child: Text('No orderers found'),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Transform.scale(
            scale: 1.1,
            child: SharePictures(imagePath: AppImages.jetPickerImage),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.availableJetPickersNearYou,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                width: 70.w,
                height: 35.h,
                child: CustomButton(
                  text: AppStrings.seeAll,
                  textColor: AppColors.black,
                  color: AppColors.yellow3,
                  radius: 20.r,
                  fontSize: 14.sp,
                  onPressed: () {
                    // Navigate to all orderers screen
                  },
                ),
              ),
            ],
          ),
          10.0.verticalSpace,
          SizedBox(
            height: 450.h,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.itemCount + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.itemCount) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final orderer = state.orderers![index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 25.h),
                  child: OrdererHomeCard(
                    order: orderer,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}