# 🚀 Flutter GetX Boilerplate

Boilerplate Flutter + GetX yang scalable dan production-ready untuk project jangka panjang.

> **Flutter 3.41.2 | Dart 3.11.0**

---

## 📁 Struktur Folder

```
lib/
├── app/                        # Entry point & konfigurasi app
│   ├── bindings/               # InitialBinding (inject global dependencies)
│   ├── middlewares/            # Auth & Guest middleware
│   └── app.dart                # GetMaterialApp config
│
├── core/                       # Fondasi global (tidak spesifik ke fitur)
│   ├── constants/              # Warna, string, dimensi, API endpoint
│   ├── errors/                 # Exceptions & Failures
│   ├── network/                # Dio client + interceptors
│   ├── services/               # StorageService, AuthService
│   ├── theme/                  # AppTheme, TextStyles
│   └── utils/                  # Validators, Formatters, Helpers
│
├── data/                       # Data layer (Repository Pattern)
│   ├── models/                 # Data models (fromJson / toJson)
│   ├── providers/              # Raw API calls (Dio)
│   └── repositories/           # Business logic, transform data
│
├── modules/                    # Feature-first modules
│   ├── auth/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── views/
│   │   └── widgets/
│   ├── dashboard/
│   └── profile/
│
├── routes/                     # Centralized routing
│   ├── app_pages.dart
│   └── app_routes.dart
│
└── main.dart
```

---

## 🏃 Quick Start

```bash
# 1. Clone / copy project
# 2. Install dependencies
flutter pub get

# 3. Jalankan app
flutter run
```

---

## ⚙️ Konfigurasi

### 1. Ganti Base URL API
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://api.yourapp.com/v1';
```

### 2. Tambah Endpoint Baru
```dart
// api_constants.dart
static const String products = '/products';
static const String orders   = '/orders';
```

### 3. Tambah Module Baru
```
modules/
└── product/
    ├── bindings/product_binding.dart
    ├── controllers/product_controller.dart
    ├── views/product_view.dart
    └── widgets/product_card.dart
```

Daftarkan di `app_routes.dart` dan `app_pages.dart`.

---

## 🧩 Cara Pakai

### Navigasi
```dart
Get.toNamed(AppRoutes.PROFILE);
Get.offAllNamed(AppRoutes.LOGIN);
Get.back();
```

### Snackbar / Dialog
```dart
AppHelpers.showSuccess('Berhasil disimpan!');
AppHelpers.showError('Terjadi kesalahan');
AppHelpers.showLoading();
AppHelpers.hideLoading();

final ok = await AppHelpers.showConfirm(
  title: 'Hapus?',
  message: 'Data akan dihapus permanen',
);
```

### Reactive State
```dart
// Di controller
final count = 0.obs;
void increment() => count.value++;

// Di view
Obx(() => Text('${controller.count.value}'))
```

### Format Tanggal & Angka
```dart
AppFormatters.formatDate(DateTime.now());           // '05 Apr 2026'
AppFormatters.formatCurrency(150000);               // 'Rp150.000'
AppFormatters.timeAgo(DateTime.now().subtract(...)); // '2h ago'
```

---

## 📦 Dependencies

| Package | Kegunaan |
|---|---|
| `get` | State management, routing, DI |
| `dio` | HTTP client |
| `get_storage` | Local key-value storage |
| `flutter_secure_storage` | Secure token storage |
| `cached_network_image` | Image caching |
| `shimmer` | Loading skeleton |
| `intl` | Format tanggal & angka |

---

## ✅ Best Practices yang Diterapkan

- **Feature-first** — setiap fitur terisolasi dalam folder sendiri
- **Repository Pattern** — pisah Provider (HTTP) dari Repository (logika)
- **Dependency Injection** via `Binding` — tidak ada `Get.put()` di View
- **Centralized routing** — semua route didefinisikan di satu tempat
- **Interceptors** — auth token, error handling, dan logging otomatis
- **Reactive state** — gunakan `.obs` + `Obx()`, bukan `setState`
- **Middleware** — proteksi route dengan `AuthMiddleware` dan `GuestMiddleware`

---

## 🗂️ Konvensi Penamaan

| Item | Format | Contoh |
|---|---|---|
| File | snake_case | `user_model.dart` |
| Class | PascalCase | `UserModel` |
| Variable | camelCase | `currentUser` |
| Constant | UPPER_SNAKE | `BASE_URL` |
| Route | `/kebab-case` | `/user-profile` |

---

## 📝 License

MIT — bebas digunakan untuk project komersial maupun pribadi.
