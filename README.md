# 🛍️ Thriftly - Sustainable Thrift Shopping App

![Flutter](https://img.shields.io/badge/Flutter-3.10.4-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Thriftly** adalah aplikasi marketplace untuk jual-beli barang bekas (thrift) yang sustainable dan ramah lingkungan. Dibangun dengan Flutter dan Firebase.

---

## ✨ Features

### 🎯 Completed Features
- ✅ **Splash Screen** - Animasi loading yang smooth
- ✅ **Onboarding** - 3 slides pengenalan aplikasi
- ✅ **Authentication** 
  - Email/Password login & register
  - Password reset
  - Profile management
- ✅ **Home Screen** - Tampilan produk dengan categories
- ✅ **Firebase Integration**
  - Authentication service
  - Firestore database
  - Cloud Storage untuk upload gambar
- ✅ **Product Management** - CRUD operations ready
- ✅ **Dark Mode Support**

### 🚧 In Development
- ⏳ Product Detail Screen
- ⏳ Shopping Cart
- ⏳ Upload Product dengan image picker
- ⏳ Search & Filter
- ⏳ User Profile
- ⏳ Chat Seller
- ⏳ Payment Integration

---

## 📱 Screenshots

> Screenshots akan ditambahkan setelah UI selesai

---

## 🏗️ Tech Stack

- **Framework**: Flutter 3.10.4
- **Language**: Dart
- **Backend**: Firebase
  - Firebase Auth - Authentication
  - Cloud Firestore - Database
  - Firebase Storage - File storage
- **State Management**: Provider
- **UI/UX**: Material Design 3

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.3
  firebase_storage: ^12.3.7
  provider: ^6.1.2
  google_fonts: ^6.1.0
  image_picker: ^1.1.2
  smooth_page_indicator: ^1.1.0
  intl: ^0.20.1
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.10.4 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/thriftly_app.git
   cd thriftly_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create Firebase project di [Firebase Console](https://console.firebase.google.com/)
   
   b. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   
   c. Configure Firebase:
   ```bash
   flutterfire configure
   ```
   
   d. Enable Firebase services:
   - Authentication (Email/Password)
   - Firestore Database
   - Firebase Storage
   
   e. Uncomment di `lib/main.dart`:
   ```dart
   import 'firebase_options.dart';
   
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```
   
   📖 **Detailed guide**: Lihat [`FIREBASE_SETUP_GUIDE.md`](FIREBASE_SETUP_GUIDE.md)

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```
lib/
├── config/
│   └── app_theme.dart          # Theme configuration
├── models/
│   └── product_model.dart      # Product data model
├── screens/
│   ├── splash_screen.dart      # Splash screen
│   ├── onboarding_screen.dart  # Onboarding slides
│   ├── login_screen.dart       # Login page
│   ├── register_screen.dart    # Register page
│   └── home_screen.dart        # Home page
├── services/
│   ├── auth_service.dart       # Authentication logic
│   ├── firestore_service.dart  # Database operations
│   └── storage_service.dart    # File upload/download
├── widgets/
│   ├── product_card.dart       # Product card widget
│   ├── category_chip.dart      # Category chip widget
│   └── promo_banner.dart       # Promo banner widget
├── utils/
│   └── color_extension.dart    # Color utilities
└── main.dart                   # App entry point
```

---

## 🎨 Design

Design mockup tersedia di folder `assets/stitch_halaman_beranda/`:
- Splash Screen
- Onboarding (3 variants)
- Login & Register
- Home
- Product Detail
- Shopping Cart
- Upload Product
- Profile
- Search & Filter

---

## 🔥 Firebase Services

### Authentication
```dart
final authService = context.read<AuthService>();

// Login
await authService.loginWithEmail(
  email: 'user@example.com',
  password: 'password',
);

// Register
await authService.registerWithEmail(
  email: 'user@example.com',
  password: 'password',
  name: 'John Doe',
);
```

### Firestore
```dart
final firestoreService = context.read<FirestoreService>();

// Get products
StreamBuilder<List<ProductModel>>(
  stream: firestoreService.getProducts(),
  builder: (context, snapshot) {
    // Display products
  },
)
```

### Storage
```dart
final storageService = context.read<StorageService>();

// Upload image
final url = await storageService.uploadImage(
  file: imageFile,
  path: 'products',
);
```

📖 **More examples**: Lihat [`FIREBASE_QUICK_REFERENCE.md`](FIREBASE_QUICK_REFERENCE.md)

---

## 📝 Documentation

- [`FIREBASE_SETUP_GUIDE.md`](FIREBASE_SETUP_GUIDE.md) - Panduan setup Firebase lengkap
- [`FIREBASE_QUICK_REFERENCE.md`](FIREBASE_QUICK_REFERENCE.md) - Contoh kode Firebase
- [`FIREBASE_SETUP_SUMMARY.md`](FIREBASE_SETUP_SUMMARY.md) - Summary progress Firebase
- [`TODO.md`](TODO.md) - Development roadmap & checklist
- [`COMPONENT_REFERENCE.md`](COMPONENT_REFERENCE.md) - Widget components guide
- [`PROJECT_SUMMARY.md`](PROJECT_SUMMARY.md) - Project overview
- [`ERROR_FIX_LOG.md`](ERROR_FIX_LOG.md) - Bug fixes history

---

## 🗺️ Roadmap

- [x] **Fase 1**: Setup & Basic Screens ✅
- [x] **Fase 2**: Firebase Integration (60%) 🚧
- [ ] **Fase 3**: Core Features (Product Detail, Cart, Upload)
- [ ] **Fase 4**: Search & Filter
- [ ] **Fase 5**: User Profile & Settings
- [ ] **Fase 6**: Chat Feature
- [ ] **Fase 7**: Payment Integration
- [ ] **Fase 8**: Notifications
- [ ] **Fase 9**: Testing
- [ ] **Fase 10**: Production Release

Lihat [`TODO.md`](TODO.md) untuk detail lengkap.

---

## 🤝 Contributing

Contributions are welcome! Silakan fork repository ini dan submit pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@your_username](https://github.com/your_username)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- Design inspiration: Modern thrift shopping apps
- Icons: Material Icons
- Fonts: Google Fonts
- Backend: Firebase
- Framework: Flutter

---

## 📞 Support

Jika ada pertanyaan atau issue, silakan:
1. Buka [Issues](https://github.com/your_username/thriftly_app/issues)
2. Email: your.email@example.com

---

**Made with ❤️ and Flutter**

---

## ⚠️ Notes

- Firebase configuration files (`firebase_options.dart`, `google-services.json`) akan di-generate setelah menjalankan `flutterfire configure`
- Untuk development, gunakan Test Mode di Firebase Console
- Sebelum production, update security rules di Firestore dan Storage
- API keys di Firebase config aman untuk di-commit karena ada security rules di backend

---

**Status**: 🚧 In Development (60% Complete)  
**Last Updated**: 2025-12-25
