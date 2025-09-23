import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadRecipeImage({
    required File image,
    required String recipeId,
    required String userId,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = path.extension(image.path);
      final fileName = 'recipe_${recipeId}_$timestamp$fileExtension';

      final ref = _firebaseStorage.ref().child(
        'recipe_images/$userId/$fileName',
      );

      final metadata = SettableMetadata(
        contentType: _getContentType(fileExtension),
        customMetadata: {
          'recipeId': recipeId,
          'userId': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = ref.putFile(image, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: e.code,
        message: 'Failed to upload recipe image ${e.message}',
      );
    } catch (e) {
      throw Exception('Failed to upload recipe image $e');
    }
  }

  Future<bool> deleteRecipeImage(String imageUrl) async {
    try {
      final ref = _firebaseStorage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return true;
      }
      print('Failed to delete recipe image ${e.message}');
      return false;
    } catch (e) {
      print('Failed to delete recipe image $e');
      return false;
    }
  }

  Future<List<Reference>> listUserRecipeImages(String userId) async {
    try {
      final listResult =
          await _firebaseStorage.ref().child('recipe_images/$userId').listAll();
      return listResult.items;
    } catch (e) {
      print('Failed to list user recipe images $e');
      return [];
    }
  }

  Reference getRecipeImageReference(String imageUrl) {
    return _firebaseStorage.refFromURL(imageUrl);
  }

  _getContentType(String fileExtension) {
    switch (fileExtension) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
