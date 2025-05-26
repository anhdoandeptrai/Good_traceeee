import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static const String _apiKey = 'f809a6baf1d9f4d447d8b4943c367e15';

  static Future<File?> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('Failed to pick image', e.toString());
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('Failed to pick image', e.toString());
      return null;
    }
  }

  static Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
      final request = http.MultipartRequest('POST', uri);

      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['data']['url'];
      } else {
        _showErrorSnackbar('Failed to upload image to ImgBB',
            'Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _showErrorSnackbar('Failed to upload image', e.toString());
      return null;
    }
  }

  static void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static Future<File?> showImageSourceSheet() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose Image Source',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.photo_library, color: Colors.white),
            ),
            title: const Text('Gallery'),
            subtitle: const Text('Pick from your gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            title: const Text('Camera'),
            subtitle: const Text('Take a new photo'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (source == null) return null;

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      _showErrorSnackbar('Error picking image', e.toString());
    }

    return null;
  }
}
