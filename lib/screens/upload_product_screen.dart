import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftly_app/config/app_theme.dart';
import 'package:thriftly_app/models/product_model.dart';
import 'package:thriftly_app/services/auth_service.dart';
import 'package:thriftly_app/services/firestore_service.dart';
import 'package:thriftly_app/services/storage_service.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _sizeController = TextEditingController();

  String _selectedCategory = ProductCategories.pakaian;
  String _selectedCondition = ProductConditions.good;
  List<File> _selectedImages = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final storageService = context.read<StorageService>();
    try {
      final files = await storageService.pickMultipleImages(maxImages: 5);
      setState(() {
        _selectedImages = files;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 gambar produk'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final authService = context.read<AuthService>();
      final storageService = context.read<StorageService>();
      final firestoreService = context.read<FirestoreService>();

      // Check if user is logged in
      if (authService.currentUser == null) {
        throw 'Anda harus login terlebih dahulu';
      }

      // 1. Upload images to Firebase Storage
      final productId = DateTime.now().millisecondsSinceEpoch.toString();
      final imageUrls = await storageService.uploadProductImages(
        images: _selectedImages,
        productId: productId,
        onProgress: (current, total) {
          setState(() {
            _uploadProgress = current / total;
          });
        },
      );

      // 2. Create product model
      final product = ProductModel(
        id: productId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        images: imageUrls,
        sellerId: authService.currentUser!.uid,
        sellerName: authService.currentUser!.displayName ?? 'Unknown',
        condition: _selectedCondition,
        size: _sizeController.text.trim().isNotEmpty
            ? _sizeController.text.trim()
            : null,
        brand: _brandController.text.trim().isNotEmpty
            ? _brandController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      // 3. Save to Firestore
      await firestoreService.createProduct(product);

      if (!mounted) return;

      // 4. Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diupload! 🎉'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 5. Navigate back
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload gagal: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Produk',
          style: TextStyle(
            color: AppTheme.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image picker section
            _buildImageSection(),
            const SizedBox(height: 24),

            // Product name
            _buildTextField(
              controller: _nameController,
              label: 'Nama Produk',
              hint: 'Contoh: Jaket Denim Vintage',
              validator: (v) => v?.isEmpty ?? true ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Category
            _buildDropdown(
              label: 'Kategori',
              value: _selectedCategory,
              items: ProductCategories.all,
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 16),

            // Price
            _buildTextField(
              controller: _priceController,
              label: 'Harga (Rp)',
              hint: '150000',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Harga wajib diisi';
                if (double.tryParse(v!) == null) return 'Harga tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Condition
            _buildDropdown(
              label: 'Kondisi',
              value: _selectedCondition,
              items: ProductConditions.all,
              onChanged: (val) => setState(() => _selectedCondition = val!),
            ),
            const SizedBox(height: 16),

            // Brand (optional)
            _buildTextField(
              controller: _brandController,
              label: 'Brand (Opsional)',
              hint: 'Contoh: Uniqlo, H&M, Zara',
              required: false,
            ),
            const SizedBox(height: 16),

            // Size (optional)
            _buildTextField(
              controller: _sizeController,
              label: 'Ukuran (Opsional)',
              hint: 'Contoh: L, M, XL',
              required: false,
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi',
              hint: 'Tulis deskripsi produk secara detail...',
              maxLines: 5,
              validator: (v) =>
                  v?.isEmpty ?? true ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 32),

            // Upload button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.backgroundDark,
                  disabledBackgroundColor: AppTheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.backgroundDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Uploading ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Upload Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Foto Produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${_selectedImages.length}/5)',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload minimal 1 foto, maksimal 5 foto',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 12),

        // Image grid
        _selectedImages.isEmpty ? _buildAddImageButton() : _buildImageGrid(),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 8),
            Text(
              'Pilih Gambar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedImages.length < 5
          ? _selectedImages.length + 1
          : _selectedImages.length,
      itemBuilder: (context, index) {
        // Add image button
        if (index == _selectedImages.length && _selectedImages.length < 5) {
          return InkWell(
            onTap: _pickImages,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 32,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        }

        // Image preview
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
            // Primary badge
            if (index == 0)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Utama',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain,
              ),
            ),
            if (!required)
              const Text(
                ' (Opsional)',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDCE5E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDCE5E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDCE5E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDCE5E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
