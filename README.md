# 🌿 Green Recycle App

**Ứng dụng phân loại rác tái chế thông minh sử dụng AI**

[![Flutter](https://img.shields.io/badge/Flutter-3.10.3+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI%20Chatbot-green.svg)](https://ai.google.dev/)

---

## 📋 Giới thiệu

**Green Recycle** là ứng dụng di động Flutter giúp người dùng phân loại rác thải thông minh, góp phần bảo vệ môi trường. Ứng dụng tích hợp AI chatbot (Gemini) để hỗ trợ người dùng hiểu rõ hơn về cách phân loại và tái chế rác.

### ✨ Tính năng chính

| Tính năng | Mô tả |
|-----------|-------|
| 📷 **Quét & Phân loại rác** | Sử dụng camera để nhận diện và phân loại rác thải |
| 🤖 **Chatbot AI** | Trợ lý ảo hỗ trợ giải đáp thắc mắc về phân loại rác |
| 📍 **Điểm thu gom** | Tìm kiếm các điểm thu gom rác tái chế gần bạn |
| 📊 **Thống kê** | Theo dõi lịch sử và thống kê phân loại cá nhân |
| 🎁 **Phần thưởng** | Tích điểm xanh và đổi phần thưởng |
| 👤 **Tài khoản cá nhân** | Quản lý hồ sơ và avatar người dùng |

---

## 🏗️ Cấu trúc dự án

```
graduation-project/
├── 📁 UI-UX/                    # Thiết kế giao diện UI/UX
│   ├── onboarding_*/            # Màn hình giới thiệu
│   ├── trang_chủ_*/             # Thiết kế trang chủ
│   └── đăng_ký, đăng_nhập/      # Màn hình xác thực
│
└── 📁 green_recycle_app/        # Ứng dụng Flutter chính
    ├── lib/
    │   ├── main.dart            # Entry point
    │   ├── app_theme.dart       # Cấu hình theme (Light/Dark)
    │   ├── routes.dart          # Định tuyến ứng dụng
    │   ├── 📁 models/           # Data models
    │   │   └── user_model.dart
    │   ├── 📁 services/         # Business logic services
    │   │   ├── auth_service.dart
    │   │   ├── chatbot_service.dart
    │   │   ├── user_service.dart
    │   │   └── rewards_service.dart
    │   ├── 📁 screens/          # UI Screens
    │   │   ├── auth/            # Đăng nhập, Đăng ký
    │   │   ├── main/            # Các màn hình chính
    │   │   └── onboarding/      # Màn hình giới thiệu
    │   ├── 📁 widgets/          # Reusable widgets
    │   └── 📁 providers/        # State management
    ├── assets/images/           # Hình ảnh tài nguyên
    ├── functions/               # Firebase Cloud Functions
    └── pubspec.yaml             # Dependencies
```

---

## 🛠️ Công nghệ sử dụng

### Frontend
- **Flutter** 3.10.3+ - Cross-platform mobile framework
- **Provider** - State management
- **Google Fonts** - Typography

### Backend & Services
- **Firebase Core** - Nền tảng backend
- **Firebase Auth** - Xác thực người dùng (Email & Google Sign-In)
- **Cloud Firestore** - Database NoSQL realtime
- **Firebase Storage** - Lưu trữ hình ảnh (avatar)
- **Cloud Functions** - Serverless functions

### AI & Tools
- **Gemini AI** - Chatbot thông minh hỗ trợ người dùng
- **Image Picker** - Chọn/chụp ảnh từ thiết bị
- **URL Launcher** - Mở bản đồ và liên kết ngoài

---

## 🚀 Cài đặt & Chạy

### Yêu cầu hệ thống
- Flutter SDK 3.10.3+
- Dart SDK ^3.10.3
- Firebase CLI
- Android Studio / VS Code

### Các bước cài đặt

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd graduation-project/green_recycle_app
   ```

2. **Cài đặt dependencies**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase**
   - Tạo project trên [Firebase Console](https://console.firebase.google.com/)
   - Thêm ứng dụng Android/iOS
   - Tải file `google-services.json` (Android) hoặc `GoogleService-Info.plist` (iOS)
   - Đặt file vào thư mục tương ứng

4. **Cấu hình biến môi trường**
   - Tạo file `.env` trong thư mục `green_recycle_app`
   - Thêm API key cho Gemini (nếu cần):
     ```
     GEMINI_API_KEY=your_api_key_here
     ```

5. **Chạy ứng dụng**
   ```bash
   flutter run
   ```

---

## 📱 Các màn hình chính

| Màn hình | File | Mô tả |
|----------|------|-------|
| Onboarding | `onboarding_screen.dart` | Giới thiệu ứng dụng cho người dùng mới |
| Đăng nhập | `login_screen.dart` | Đăng nhập bằng Email hoặc Google |
| Đăng ký | `register_screen.dart` | Tạo tài khoản mới |
| Trang chủ | `home_screen.dart` | Dashboard chính của ứng dụng |
| Camera | `camera_screen.dart` | Quét và phân loại rác |
| Kết quả | `result_screen.dart` | Hiển thị kết quả phân loại |
| Chatbot | `chatbot_screen.dart` | Trò chuyện với AI trợ lý |
| Điểm thu gom | `collection_points_screen.dart` | Bản đồ điểm thu gom |
| Lịch sử | `history_screen.dart` | Lịch sử phân loại |
| Thống kê | `stats_screen.dart` | Thống kê cá nhân |
| Phần thưởng | `rewards_screen.dart` | Đổi điểm lấy phần thưởng |
| Hồ sơ | `profile_screen.dart` | Thông tin cá nhân |
| Chỉnh sửa hồ sơ | `edit_profile_screen.dart` | Cập nhật thông tin |

---

## 🎨 Theme & Giao diện

Ứng dụng hỗ trợ **2 chế độ giao diện**:
- 🌞 **Light Mode** - Giao diện sáng
- 🌙 **Dark Mode** - Giao diện tối

Quản lý theme thông qua `SettingsProvider` và có thể chuyển đổi trong phần cài đặt.

---

## 📄 License

Dự án này được phát triển cho mục đích tốt nghiệp.

---

## 👥 Tác giả

- **Sinh viên thực hiện**: [Tên sinh viên]
- **Giảng viên hướng dẫn**: [Tên giảng viên]
- **Trường**: [Tên trường]

---

<div align="center">

🌱 *Cùng nhau bảo vệ môi trường xanh - sạch - đẹp* 🌍

</div>
