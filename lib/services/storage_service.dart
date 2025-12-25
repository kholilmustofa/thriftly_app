import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Storage service untuk handle upload/download files dari Firebase Storage
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw 'Error memilih gambar: $e';
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw 'Error mengambil foto: $e';
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.length > maxImages) {
        throw 'Maksimal $maxImages gambar';
      }

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      throw 'Error memilih gambar: $e';
    }
  }

  /// Upload single image to Firebase Storage
  Future<String> uploadImage({
    required File file,
    required String path,
    Function(double)? onProgress,
  }) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = _storage.ref().child('$path/$fileName.jpg');

      final UploadTask uploadTask = ref.putFile(file);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw 'Upload gagal: ${e.message}';
    } catch (e) {
      throw 'Upload gagal: $e';
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages({
    required List<File> files,
    required String path,
    Function(int current, int total)? onProgress,
  }) async {
    try {
      final List<String> downloadUrls = [];

      for (int i = 0; i < files.length; i++) {
        onProgress?.call(i + 1, files.length);

        final url = await uploadImage(file: files[i], path: path);

        downloadUrls.add(url);
      }

      return downloadUrls;
    } catch (e) {
      throw 'Upload gambar gagal: $e';
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw 'Hapus gambar gagal: ${e.message}';
    } catch (e) {
      throw 'Hapus gambar gagal: $e';
    }
  }

  /// Delete multiple images
  Future<void> deleteMultipleImages(List<String> imageUrls) async {
    try {
      for (final url in imageUrls) {
        await deleteImage(url);
      }
    } catch (e) {
      throw 'Hapus gambar gagal: $e';
    }
  }

  /// Upload product images
  Future<List<String>> uploadProductImages({
    required List<File> images,
    required String productId,
    Function(int current, int total)? onProgress,
  }) async {
    return await uploadMultipleImages(
      files: images,
      path: 'products/$productId',
      onProgress: onProgress,
    );
  }

  /// Upload user profile picture
  Future<String> uploadProfilePicture({
    required File image,
    required String userId,
    Function(double)? onProgress,
  }) async {
    return await uploadImage(
      file: image,
      path: 'users/$userId',
      onProgress: onProgress,
    );
  }

  /// Show image source dialog helper
  /// Returns null if user cancels
  Future<File?> showImageSourceDialog({
    required Function() onCameraSelected,
    required Function() onGallerySelected,
  }) async {
    // This is a helper method
    // Implement your own dialog in the UI layer
    // This is just a placeholder
    return null;
  }
}
