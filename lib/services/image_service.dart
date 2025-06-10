import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:habitsync/services/profile_cache_service.dart';
import 'package:habitsync/features/profile/data/profile_service.dart';

class ImageService {
  static const String cloudName = "dukierzbe";
  static const String uploadPreset = "profile_images";
  static const String uploadUrl =
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  final ImagePicker _imagePicker = ImagePicker();

  /// Picks an image from [source], uploads it to Cloudinary, and returns the image URL.
  Future<String?> pickAndUploadImage(ImageSource source) async {
    try {
      if (kIsWeb) {
        // Web: Pick and upload as bytes
        XFile? picked = await _imagePicker.pickImage(source: source);
        if (picked == null) return null;
        Uint8List bytes = await picked.readAsBytes();
        return await uploadImage(webImage: bytes);
      } else {
        // Mobile: Pick and upload as file
        XFile? picked = await _imagePicker.pickImage(source: source);
        if (picked == null) return null;
        File file = File(picked.path);
        return await uploadImage(imageFile: file);
      }
    } catch (e) {
      print("Error picking/uploading image: $e");
      return null;
    }
  }

  Future<String?> uploadImage({File? imageFile, Uint8List? webImage}) async {
    try {
      FormData formData;

      if (kIsWeb && webImage != null) {
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(webImage, filename: "upload.jpg"),
          "upload_preset": uploadPreset,
          "folder": "user_profiles",
        });
      } else if (imageFile != null) {
        String fileName = imageFile.path.split('/').last;
        formData = FormData.fromMap({
          "file":
              await MultipartFile.fromFile(imageFile.path, filename: fileName),
          "upload_preset": uploadPreset,
          "folder": "profiles",
        });
      } else {
        print("No image file provided.");
        return null;
      }

      Dio dio = Dio();
      Response response = await dio.post(uploadUrl, data: formData);

      if (response.statusCode == 200) {
        String imageUrl = response.data["secure_url"];
        print("Upload successful: $imageUrl");
        return imageUrl;
      } else {
        print("Cloudinary upload failed with status: ${response.statusCode}");
        print("Response data: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<bool> pickUploadAndUpdateAvatar(ImageSource source) async {
    // 1. Pick and upload image
    final imageUrl = await pickAndUploadImage(source);
    if (imageUrl == null) return false;

    // 2. Get cached user
    final user = await ProfileCacheService.getCachedUserProfile();
    if (user == null) return false;

    // 3. Update avatar and send to backend
    final updatedUser = user.copyWith(avatar: imageUrl);
    await ProfileService().updateProfile(updatedUser);

    // 4. Update local cache
    await ProfileCacheService.cacheUserProfile(updatedUser);

    return true;
  }
}
