# 🔥 Firebase Integration - Quick Reference

Panduan cepat untuk menggunakan Firebase services yang sudah dibuat.

---

## 📁 File Structure

```
lib/
├── services/
│   ├── auth_service.dart       # Authentication
│   ├── firestore_service.dart  # Database operations
│   └── storage_service.dart    # File upload/download
├── models/
│   └── product_model.dart      # Product data model
└── main.dart                   # Firebase initialization
```

---

## 🚀 Quick Start

### 1. Run FlutterFire Configure

**PENTING: Jalankan ini terlebih dahulu!**

```bash
flutterfire configure
```

### 2. Uncomment Firebase Init di main.dart

Setelah `flutterfire configure` selesai:

```dart
// Di main.dart, uncomment baris ini:
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 3. Update Login Screen

```dart
import 'package:provider/provider.dart';
import 'package:thriftly_app/services/auth_service.dart';

// Di _handleLogin():
final authService = context.read<AuthService>();

try {
  await authService.loginWithEmail(
    email: _emailController.text,
    password: _passwordController.text,
  );
  // Success!
} catch (e) {
  // Error handling
  print(e);
}
```

---

## 🔐 Authentication Examples

### Login
```dart
final authService = context.read<AuthService>();

try {
  await authService.loginWithEmail(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Login berhasil!');
} catch (e) {
  print('Error: $e');
}
```

### Register
```dart
final authService = context.read<AuthService>();

try {
  await authService.registerWithEmail(
    email: 'user@example.com',
    password: 'password123',
    name: 'John Doe',
  );
  print('Registrasi berhasil!');
} catch (e) {
  print('Error: $e');
}
```

### Logout
```dart
final authService = context.read<AuthService>();
await authService.logout();
```

### Reset Password
```dart
final authService = context.read<AuthService>();

try {
  await authService.resetPassword(email: 'user@example.com');
  print('Link reset password telah dikirim');
} catch (e) {
  print('Error: $e');
}
```

### Get Current User
```dart
final authService = context.read<AuthService>();
final user = authService.currentUser;

if (user != null) {
  print('User ID: ${user.uid}');
  print('Email: ${user.email}');
  print('Name: ${user.displayName}');
}
```

### Listen to Auth State
```dart
StreamBuilder(
  stream: context.read<AuthService>().authStateChanges,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HomeScreen(); // User logged in
    }
    return LoginScreen(); // User not logged in
  },
)
```

---

## 📦 Firestore Examples

### Get All Products
```dart
final firestoreService = context.read<FirestoreService>();

StreamBuilder<List<ProductModel>>(
  stream: firestoreService.getProducts(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final products = snapshot.data!;
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.formattedPrice),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

### Get Products by Category
```dart
final firestoreService = context.read<FirestoreService>();

StreamBuilder<List<ProductModel>>(
  stream: firestoreService.getProducts(category: 'Pakaian'),
  builder: (context, snapshot) {
    // ... sama seperti di atas
  },
)
```

### Search Products
```dart
final firestoreService = context.read<FirestoreService>();

StreamBuilder<List<ProductModel>>(
  stream: firestoreService.getProducts(searchQuery: 'jaket'),
  builder: (context, snapshot) {
    // ... sama seperti di atas
  },
)
```

### Create Product
```dart
final firestoreService = context.read<FirestoreService>();
final authService = context.read<AuthService>();

final product = ProductModel(
  id: '', // Will be auto-generated
  name: 'Jaket Vintage',
  description: 'Jaket vintage kondisi bagus',
  price: 150000,
  category: ProductCategories.pakaian,
  images: ['url1', 'url2'],
  sellerId: authService.currentUser!.uid,
  sellerName: authService.currentUser!.displayName ?? 'Unknown',
  condition: ProductConditions.good,
  size: 'L',
  brand: 'Uniqlo',
  createdAt: DateTime.now(),
);

try {
  final productId = await firestoreService.createProduct(product);
  print('Product created with ID: $productId');
} catch (e) {
  print('Error: $e');
}
```

### Update Product
```dart
final firestoreService = context.read<FirestoreService>();

final updatedProduct = product.copyWith(
  price: 120000,
  description: 'Updated description',
);

await firestoreService.updateProduct(productId, updatedProduct);
```

### Delete Product
```dart
final firestoreService = context.read<FirestoreService>();
await firestoreService.deleteProduct(productId);
```

---

## 📸 Storage Examples

### Pick Image from Gallery
```dart
final storageService = context.read<StorageService>();

final file = await storageService.pickImageFromGallery();
if (file != null) {
  print('Image selected: ${file.path}');
}
```

### Pick Multiple Images
```dart
final storageService = context.read<StorageService>();

final files = await storageService.pickMultipleImages(maxImages: 5);
print('${files.length} images selected');
```

### Upload Single Image
```dart
final storageService = context.read<StorageService>();

final file = await storageService.pickImageFromGallery();
if (file != null) {
  final url = await storageService.uploadImage(
    file: file,
    path: 'products',
    onProgress: (progress) {
      print('Upload progress: ${(progress * 100).toStringAsFixed(0)}%');
    },
  );
  print('Image uploaded: $url');
}
```

### Upload Product Images
```dart
final storageService = context.read<StorageService>();

final files = await storageService.pickMultipleImages();
if (files.isNotEmpty) {
  final urls = await storageService.uploadProductImages(
    images: files,
    productId: 'product-123',
    onProgress: (current, total) {
      print('Uploading $current of $total');
    },
  );
  print('All images uploaded: $urls');
}
```

### Upload Profile Picture
```dart
final storageService = context.read<StorageService>();
final authService = context.read<AuthService>();

final file = await storageService.pickImageFromGallery();
if (file != null) {
  final url = await storageService.uploadProfilePicture(
    image: file,
    userId: authService.currentUser!.uid,
  );
  
  // Update user profile
  await authService.updateProfile(photoUrl: url);
}
```

### Delete Image
```dart
final storageService = context.read<StorageService>();
await storageService.deleteImage(imageUrl);
```

---

## 🎨 Complete Example: Upload Product Screen

```dart
class UploadProductScreen extends StatefulWidget {
  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  
  List<File> _selectedImages = [];
  bool _isUploading = false;
  String _selectedCategory = ProductCategories.pakaian;

  Future<void> _pickImages() async {
    final storageService = context.read<StorageService>();
    final files = await storageService.pickMultipleImages(maxImages: 5);
    setState(() {
      _selectedImages = files;
    });
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih minimal 1 gambar')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final authService = context.read<AuthService>();
      final storageService = context.read<StorageService>();
      final firestoreService = context.read<FirestoreService>();

      // 1. Upload images
      final imageUrls = await storageService.uploadProductImages(
        images: _selectedImages,
        productId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // 2. Create product
      final product = ProductModel(
        id: '',
        name: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        images: imageUrls,
        sellerId: authService.currentUser!.uid,
        sellerName: authService.currentUser!.displayName ?? 'Unknown',
        createdAt: DateTime.now(),
      );

      await firestoreService.createProduct(product);

      // 3. Success!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil diupload!')),
      );
      Navigator.pop(context);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Produk')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Image picker
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pilih Gambar (${_selectedImages.length}/5)'),
            ),
            
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
              validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
            ),
            
            // Price field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
            ),
            
            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ProductCategories.all
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            
            // Description
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
              maxLines: 4,
            ),
            
            SizedBox(height: 20),
            
            // Submit button
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadProduct,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text('Upload Produk'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📋 Checklist Before Running

- [ ] Run `flutterfire configure`
- [ ] Uncomment Firebase init di `main.dart`
- [ ] Uncomment import `firebase_options.dart`
- [ ] Enable Authentication di Firebase Console
- [ ] Enable Firestore di Firebase Console
- [ ] Enable Storage di Firebase Console
- [ ] Run `flutter pub get`
- [ ] Run app: `flutter run`

---

## 🐛 Common Errors

### "Firebase not initialized"
**Fix:** Uncomment Firebase init di main.dart

### "MissingPluginException"
**Fix:** 
```bash
flutter clean
flutter pub get
flutter run
```

### "google-services.json not found"
**Fix:** Run `flutterfire configure` lagi

---

**Happy Coding! 🚀**
