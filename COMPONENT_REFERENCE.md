# 📚 THRIFTLY - Component Reference

Dokumentasi lengkap untuk semua komponen yang telah dibuat.

---

## 🎨 Theme Configuration

### `AppTheme` Class (`lib/config/app_theme.dart`)

Konfigurasi tema global untuk aplikasi.

#### Colors

```dart
static const Color primary = Color(0xFF19E680);      // Hijau terang
static const Color primaryDark = Color(0xFF15C26B);  // Hijau gelap
static const Color backgroundLight = Color(0xFFF6F8F7);
static const Color backgroundDark = Color(0xFF112119);
static const Color surfaceLight = Color(0xFFFFFFFF);
static const Color surfaceDark = Color(0xFF1C3026);
static const Color textMain = Color(0xFF111814);
static const Color textSecondary = Color(0xFF638875);
```

#### Usage

```dart
// Di main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  ...
)

// Di widget
Container(
  color: AppTheme.primary,
)
```

---

## 📦 Models

### `Product` Model (`lib/models/product.dart`)

Model data untuk produk.

#### Properties

```dart
String id;              // Unique identifier
String name;            // Nama produk
String brand;           // Brand/merek
String description;     // Deskripsi lengkap
double price;           // Harga dalam Rupiah
String condition;       // "LIKE NEW", "GOOD", "RARE", "DEFECT"
String category;        // "Atasan", "Celana", "Jaket", "Sepatu"
String imageUrl;        // URL gambar produk
String timeAgo;         // "2 jam lalu", "1 hari lalu"
bool isFavorite;        // Status favorit
```

#### Usage

```dart
// Create product
final product = Product(
  id: '1',
  name: 'Jaket Denim',
  brand: 'Levi\'s',
  description: 'Jaket denim vintage',
  price: 250000,
  condition: 'LIKE NEW',
  category: 'Jaket',
  imageUrl: 'https://...',
  timeAgo: '2 jam lalu',
);

// Get sample products
final products = Product.getSampleProducts();

// Convert to/from JSON
final json = product.toJson();
final product = Product.fromJson(json);
```

---

## 📱 Screens

### 1. `SplashScreen` (`lib/screens/splash_screen.dart`)

Layar pembuka aplikasi dengan animasi.

#### Features
- ✅ Fade animation untuk logo
- ✅ Animated loading dots
- ✅ Dot pattern background
- ✅ Auto-redirect ke Onboarding (2.5s)

#### Navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => SplashScreen()),
);
```

---

### 2. `OnboardingScreen` (`lib/screens/onboarding_screen.dart`)

Pengenalan fitur aplikasi dengan 3 slide.

#### Features
- ✅ 3 halaman onboarding
- ✅ Swipeable page view
- ✅ Smooth page indicator
- ✅ Skip button
- ✅ Next/Start button

#### Customization

```dart
// Edit data onboarding di _pages
final List<OnboardingData> _pages = [
  OnboardingData(
    icon: Icons.recycling,
    title: 'Judul',
    description: 'Deskripsi',
    color: AppTheme.primary,
  ),
];
```

---

### 3. `LoginScreen` (`lib/screens/login_screen.dart`)

Halaman login pengguna.

#### Features
- ✅ Email/Username input
- ✅ Password input (toggle visibility)
- ✅ Form validation
- ✅ Social login buttons (Google, Apple)
- ✅ Forgot password link
- ✅ Register link

#### Form Validation

```dart
// Email validation
if (!value.contains('@')) {
  return 'Email tidak valid';
}

// Password validation
if (value.length < 6) {
  return 'Password minimal 6 karakter';
}
```

---

### 4. `RegisterScreen` (`lib/screens/register_screen.dart`)

Halaman registrasi pengguna baru.

#### Features
- ✅ Nama lengkap input
- ✅ Email input
- ✅ Password input
- ✅ Confirm password input
- ✅ Password matching validation
- ✅ Back to login link

#### Validation

```dart
// Password matching
if (value != _passwordController.text) {
  return 'Password tidak cocok';
}
```

---

### 5. `HomeScreen` (`lib/screens/home_screen.dart`)

Halaman utama aplikasi.

#### Features
- ✅ Header dengan notifikasi
- ✅ Search bar
- ✅ Promo carousel
- ✅ Category filter chips
- ✅ Popular categories grid
- ✅ Product grid (2 columns)
- ✅ Bottom navigation (5 items)
- ✅ Floating Action Button

#### Sections

**Header**
- Menu button
- Title
- Notification bell (dengan badge)
- Shopping bag button

**Search Bar**
- Search icon
- Input field
- Filter button

**Promo Carousel**
- Horizontal scroll
- Banner cards

**Category Chips**
- Horizontal scroll
- Selectable chips
- Active state

**Popular Categories**
- Icon grid (4 items)
- Color-coded icons

**Product Grid**
- 2 kolom
- ProductCard component
- Load more button

**Bottom Navigation**
- Home (active)
- Cari
- Jual (center FAB)
- Suka
- Akun

---

## 🧩 Widgets

### 1. `ProductCard` (`lib/widgets/product_card.dart`)

Card untuk menampilkan produk.

#### Properties

```dart
final Product product;
```

#### Features
- ✅ Product image dengan gradient overlay
- ✅ Condition badge (color-coded)
- ✅ Favorite button
- ✅ Brand label
- ✅ Product name
- ✅ Price (formatted dengan separator ribuan)
- ✅ Time ago

#### Condition Colors

```dart
'LIKE NEW' → Black background
'GOOD' → Green background
'RARE' → Black background
'DEFECT' → Yellow background
```

#### Usage

```dart
ProductCard(
  product: Product(...),
)
```

---

### 2. `CategoryChip` (`lib/widgets/category_chip.dart`)

Chip untuk filter kategori.

#### Properties

```dart
final String label;
final bool isSelected;
final VoidCallback onTap;
```

#### States
- **Selected**: Dark background, white text, shadow
- **Unselected**: White background, dark text, border

#### Usage

```dart
CategoryChip(
  label: 'Atasan',
  isSelected: selectedCategory == 'Atasan',
  onTap: () {
    setState(() {
      selectedCategory = 'Atasan';
    });
  },
)
```

---

### 3. `PromoBanner` (`lib/widgets/promo_banner.dart`)

Banner promosi dengan gradient.

#### Properties

```dart
final String title;
final String subtitle;
final String badge;
final Color color;
```

#### Features
- ✅ Gradient background
- ✅ Dot pattern overlay
- ✅ Custom badge
- ✅ Title & subtitle
- ✅ Shadow effect

#### Usage

```dart
PromoBanner(
  title: 'Koleksi Vintage 90an',
  subtitle: 'Diskon hingga 50%',
  badge: 'PROMO',
  color: AppTheme.primary,
)
```

---

## 🎯 Navigation Flow

```
SplashScreen
    ↓ (2.5s auto)
OnboardingScreen
    ↓ (tap "Mulai")
LoginScreen
    ↓ (tap "Masuk")
HomeScreen
    ├── Tab 1: Home (active)
    ├── Tab 2: Cari
    ├── Tab 3: Jual (FAB)
    ├── Tab 4: Suka
    └── Tab 5: Akun

LoginScreen
    ↓ (tap "Daftar Sekarang")
RegisterScreen
    ↓ (tap "Daftar")
HomeScreen
```

---

## 🛠️ Helper Functions

### Format Price

```dart
// Di ProductCard
String _formatPrice(double price) {
  return price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

// Usage
_formatPrice(250000) // "250.000"
```

---

## 🎨 Custom Painters

### `DotPatternPainter`

Membuat background dot pattern.

#### Usage

```dart
CustomPaint(
  painter: DotPatternPainter(),
)
```

#### Properties
- Spacing: 24px
- Dot radius: 1px
- Color: White
- Opacity: 0.1

---

## 📐 Layout Measurements

### Grid Spacing
- **Padding horizontal**: 16px
- **Gap between cards**: 12px
- **Grid columns**: 2
- **Product card aspect ratio**: 0.65

### Border Radius
- **Small**: 6px (badges)
- **Medium**: 12px (buttons, inputs, cards)
- **Large**: 16px (banners, categories)
- **Extra Large**: 20px (chips)
- **Circle**: 100px (buttons)

### Shadows

```dart
// Light shadow (cards)
BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 8,
  offset: Offset(0, 2),
)

// Medium shadow (buttons)
BoxShadow(
  color: AppTheme.primary.withOpacity(0.3),
  blurRadius: 15,
  offset: Offset(0, 5),
)
```

---

## 🚀 Quick Reference

### Import Statements

```dart
// Screens
import 'package:thriftly_app/screens/splash_screen.dart';
import 'package:thriftly_app/screens/onboarding_screen.dart';
import 'package:thriftly_app/screens/login_screen.dart';
import 'package:thriftly_app/screens/register_screen.dart';
import 'package:thriftly_app/screens/home_screen.dart';

// Widgets
import 'package:thriftly_app/widgets/product_card.dart';
import 'package:thriftly_app/widgets/category_chip.dart';
import 'package:thriftly_app/widgets/promo_banner.dart';

// Config
import 'package:thriftly_app/config/app_theme.dart';

// Models
import 'package:thriftly_app/models/product.dart';
```

### Common Patterns

**Navigate to screen**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => TargetScreen()),
);
```

**Replace screen** (no back button)
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => TargetScreen()),
);
```

**Show snackbar**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

---

## 📝 Tips & Best Practices

1. **State Management**: Gunakan `setState()` untuk now, tapi bersiaplah migrasi ke Provider/Riverpod
2. **Image Loading**: Gunakan `cached_network_image` untuk production
3. **Forms**: Selalu validate input sebelum submit
4. **Navigation**: Gunakan named routes untuk aplikasi besar
5. **Colors**: Selalu gunakan `AppTheme.colorName`, jangan hardcode
6. **Spacing**: Gunakan `SizedBox` untuk spacing, bukan `Padding` jika memungkinkan

---

**Last Updated**: 2025-12-25
