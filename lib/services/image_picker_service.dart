import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } on PlatformException catch (e) {
      if (e.code == 'camera-permission-denied') {
        throw Exception('Camera permission denied');
      }
      if (e.code == 'camera-permission-denied-permanently') {
        throw Exception('Camera permission permanently denied');
      }
      if (e.code == 'channel-error') {
        throw Exception('Channel error');
      }
      if (e.code == 'photo-access-denied') {
        throw Exception('Photo access denied');
      }
      if (e.code == 'photo-access-denied-permanently') {
        throw Exception('Photo access permanently denied');
      }
      throw Exception('Failed to pick image: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  Future<File?> showSourceImageDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    try {
                      final image = await pickImage(ImageSource.camera);
                      Navigator.pop(context, image);
                    } catch (e) {
                      print(e);
                      _showErrorDialog(context, e.toString());
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () async {
                    try {
                      final image = await pickImage(ImageSource.gallery);
                      Navigator.pop(context, image);
                    } catch (e) {
                      print(e);
                      _showErrorDialog(context, e.toString());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
