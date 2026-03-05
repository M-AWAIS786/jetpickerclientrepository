import 'dart:io';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/user_profile/user_profile_model.dart';

class UserProfileRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<GetProfileResponseModel> getMyProfile(String token) async {
    final response = await _apiServices.getApi(AppUrls.userProfileUrl, token);
    return GetProfileResponseModel.fromJson(response);
  }

  Future<UpdateProfileResponseModel> updateProfile(
    UpdateProfileRequestModel request,
    String token, {
    File? image,
  }) async {
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.userProfileUrl,
      token,
      isJson: false,
      files: image != null ? [image] : null,
      fileFields: image != null ? ['image'] : null,
    );
    return UpdateProfileResponseModel.fromJson(response);
  }

  Future<UpdateAvatarResponseModel> updateAvatar(
    File image,
    String token,
  ) async {
    final response = await _apiServices.postApi(
      {},
      AppUrls.userAvatarUrl,
      token,
      isJson: false,
      files: [image],
      fileFields: ['image'],
    );
    return UpdateAvatarResponseModel.fromJson(response);
  }
}
