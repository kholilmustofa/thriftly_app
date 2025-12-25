# 🔥 Firebase Setup Guide - Thriftly App

Tutorial lengkap untuk setup Firebase di aplikasi Thriftly.

---

## 📋 Prerequisites

✅ Dependencies sudah terinstall di `pubspec.yaml`:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `image_picker`

---

## Step 1: Buat Firebase Project

### 1.1 Buka Firebase Console
1. Buka browser dan kunjungi: https://console.firebase.google.com/
2. Klik **"Add project"** atau **"Create a project"**

### 1.2 Setup Project
1. **Project name**: `thriftly-app` (atau nama lain yang Anda suka)
2. **Google Analytics**: Anda bisa enable/disable (opsional untuk development)
3. Klik **"Create project"**
4. Tunggu sampai project selesai dibuat
5. Klik **"Continue"**

---

## Step 2: Konfigurasi Firebase dengan FlutterFire CLI

### 2.1 Login ke Firebase
Jalankan command berikut di terminal:

```bash
firebase login
```

Ini akan membuka browser untuk login dengan akun Google Anda.

### 2.2 Konfigurasi FlutterFire
Jalankan command berikut di root folder project:

```bash
flutterfire configure
```

**Proses yang akan terjadi:**
1. CLI akan menampilkan list Firebase projects Anda
2. **Pilih project** yang sudah Anda buat (thriftly-app)
3. **Pilih platforms** yang ingin Anda support:
   - ✅ android
   - ✅ ios (jika develop untuk iOS)
   - ✅ web (opsional)
   - ⬜ macos, windows, linux (skip untuk sekarang)
4. CLI akan otomatis:
   - Generate file `firebase_options.dart`
   - Konfigurasi AndroidManifest.xml
   - Konfigurasi iOS jika dipilih
   - Download `google-services.json` untuk Android
   - Download `GoogleService-Info.plist` untuk iOS

### 2.3 Verifikasi File yang Dibuat
Pastikan file-file ini sudah ada:
- ✅ `lib/firebase_options.dart` (PENTING!)
- ✅ `android/app/google-services.json`
- ✅ `ios/Runner/GoogleService-Info.plist` (jika iOS enabled)

---

## Step 3: Enable Firebase Services di Console

### 3.1 Enable Authentication
1. Di Firebase Console, buka **"Authentication"**
2. Klik **"Get Started"**
3. Tab **"Sign-in method"**:
   - Klik **"Email/Password"**
   - Toggle **"Enable"**
   - **Save**
   
4. (Opsional) Enable **Google Sign-In**:
   - Klik **"Google"**
   - Toggle **"Enable"**
   - Masukkan email support
   - **Save**

### 3.2 Enable Firestore Database
1. Di sidebar, buka **"Firestore Database"**
2. Klik **"Create database"**
3. **Location**: Pilih yang terdekat (asia-southeast1 untuk Indonesia)
4. **Security rules**: Pilih **"Start in test mode"** untuk development
   
   ```
   Test mode: Bisa read/write tanpa auth (untuk testing)
   Production mode: Butuh auth (untuk production)
   ```
   
5. Klik **"Enable"**

### 3.3 Enable Firebase Storage
1. Di sidebar, buka **"Storage"**
2. Klik **"Get started"**
3. **Security rules**: Pilih **"Start in test mode"**
4. **Location**: Sama dengan Firestore (asia-southeast1)
5. Klik **"Done"**

---

## Step 4: Konfigurasi Android

### 4.1 Update build.gradle (Project Level)
File: `android/build.gradle`

Pastikan ada:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

### 4.2 Update build.gradle (App Level)
File: `android/app/build.gradle`

Tambahkan di bagian paling bawah:
```gradle
apply plugin: 'com.google.gms.google-services'
```

Pastikan `minSdkVersion` minimal 21:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimal 21 untuk Firebase
        targetSdkVersion flutter.targetSdkVersion
    }
}
```

### 4.3 Update AndroidManifest.xml
File: `android/app/src/main/AndroidManifest.xml`

Tambahkan internet permission (biasanya sudah ada):
```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <!-- For image picker -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <application ...>
        ...
    </application>
</manifest>
```

---

## Step 5: Initialize Firebase di Flutter App

### 5.1 Update main.dart
File yang sudah dibuat: Akan di-update otomatis di step berikutnya.

---

## Step 6: Setup Firestore Security Rules (Production)

Setelah development, update security rules di Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Products collection
    match /products/{productId} {
      allow read: if true; // Anyone can read products
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.sellerId;
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                    (request.auth.uid == resource.data.buyerId || 
                     request.auth.uid == resource.data.sellerId);
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.buyerId || 
                       request.auth.uid == resource.data.sellerId;
    }
  }
}
```

### 6.2 Storage Security Rules (Production)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /users/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## ✅ Verification Checklist

Sebelum melanjutkan ke coding, pastikan:
- [ ] Firebase project sudah dibuat
- [ ] `firebase_options.dart` sudah ada
- [ ] `google-services.json` ada di `android/app/`
- [ ] Authentication sudah enabled (Email/Password)
- [ ] Firestore Database sudah dibuat
- [ ] Firebase Storage sudah enabled
- [ ] Dependencies sudah terinstall (`flutter pub get`)

---

## 🎯 Next Steps

Setelah Firebase setup selesai:
1. ✅ Initialize Firebase di `main.dart`
2. ✅ Buat Firebase Service classes
3. ✅ Implement Authentication
4. ✅ Implement Firestore CRUD
5. ✅ Implement Storage upload

---

## 🆘 Troubleshooting

### Error: "FlutterFire not found"
```bash
dart pub global activate flutterfire_cli
```

### Error: "Firebase not initialized"
Pastikan `Firebase.initializeApp()` dipanggil sebelum `runApp()`

### Error: "google-services.json not found"
Jalankan ulang: `flutterfire configure`

### Build error di Android
1. Clean project: `flutter clean`
2. Get packages: `flutter pub get`
3. Rebuild: `flutter run`

---

## 📚 Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Auth Docs](https://firebase.flutter.dev/docs/auth/overview)
- [Cloud Firestore Docs](https://firebase.flutter.dev/docs/firestore/overview)
- [Firebase Storage Docs](https://firebase.flutter.dev/docs/storage/overview)

---

**Setup by:** Antigravity AI  
**Date:** 2025-12-25  
**Project:** Thriftly App
