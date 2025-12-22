# 🌿 Green Recycle - Hệ thống Phân loại Rác Thông minh



> **Đồ án tốt nghiệp**: Hệ thống phân loại rác tái chế thông minh sử dụng AI và Deep Learning

---

## 📋 Giới thiệu

**Green Recycle** là một hệ sinh thái hoàn chỉnh giúp người dùng phân loại rác thải một cách thông minh, khoa học và hiệu quả, góp phần bảo vệ môi trường. Dự án bao gồm 3 thành phần chính:

- 📱 **Mobile App** (Flutter): Ứng dụng di động dành cho người dùng cuối
- 💻 **Admin Panel** (React + Vite): Trang quản trị cho admin
- ☁️ **Backend Services**: Firebase (Firestore, Authentication, Storage, Cloud Functions)

### 🎯 Mục tiêu dự án
- Nâng cao nhận thức cộng đồng về phân loại rác
- Ứng dụng công nghệ AI vào bài toán môi trường thực tế
- Khuyến khích thói quen tái chế qua hệ thống điểm thưởng
- Cung cấp thông tin điểm thu gom rác tái chế

---

## ✨ Tính năng chi tiết

### 📱 Mobile App - Green Recycle (Flutter)

#### 🎯 Phân loại rác thông minh
| Tính năng | Mô tả | Công nghệ |
|-----------|-------|-----------|
| **Camera Scanner** | Quét và nhận diện rác real-time | YOLOv11 + TFLite |
| **4 loại rác** | Organic, Inorganic, Recyclable, Hazardous | AI Model Custom |
| **Lịch sử phân loại** | Lưu trữ tất cả lần quét với ảnh và độ tin cậy | Cloud Firestore |
| **Thống kê cá nhân** | Biểu đồ tròn phân bổ loại rác đã quét | Charts & Analytics |

#### 🎁 Hệ thống điểm thưởng
| Tính năng | Mô tả | Chi tiết |
|-----------|-------|----------|
| **Check-in hàng ngày** | Nhận điểm xanh mỗi ngày | +10 điểm/ngày |
| **Chuỗi check-in** | Thưởng thêm khi check-in liên tục | Streak bonus |
| **Đổi thưởng** | Đổi điểm lấy quà eco-friendly | 6 phần thưởng |
| **Lịch sử đổi thưởng** | Theo dõi các lần đã đổi quà | Full history |

**Danh sách phần thưởng:**
- 🖊️ Bút bi tái chế (4,000 điểm)
- 🌱 Hạt giống rau sạch (3,000 điểm)
- 📓 Vở tái chế (35,000 điểm)
- 📔 Sổ tay tái chế (40,000 điểm)
- ♻️ Túi rác phân hủy (5,000 điểm)
- 🌵 Cây cảnh mini (5,000 điểm)

#### 🤖 AI Chatbot - Gemini
| Tính năng | Mô tả |
|-----------|-------|
| **Tư vấn phân loại** | Hướng dẫn phân loại rác chi tiết |
| **Trả lời câu hỏi** | Giải đáp thắc mắc về tái chế |
| **Tiếng Việt** | Hỗ trợ đầy đủ tiếng Việt |
| **Context-aware** | Hiểu ngữ cảnh câu hỏi |

#### 📍 Tiện ích & Thông tin
| Tính năng | Mô tả |
|-----------|-------|
| **Điểm thu gom** | Tìm điểm thu gom rác gần bạn với bản đồ |
| **Mẹo tái chế** | 30+ mẹo tái chế với hướng dẫn chi tiết |
| **Thông báo** | Nhận thông báo check-in, đổi thưởng |
| **Dark/Light Mode** | Chuyển đổi giao diện sáng/tối |

#### 👤 Quản lý tài khoản
| Tính năng | Mô tả |
|-----------|-------|
| **Đăng nhập** | Email + Password hoặc Google Sign-In |
| **Quản lý hồ sơ** | Cập nhật avatar (upload ảnh), tên hiển thị |
| **Trợ giúp** | Hỗ trợ và hướng dẫn sử dụng |

### 💻 Admin Panel - Green Admin (React)

| Module | Tính năng chính |
|--------|----------------|
| **📊 Dashboard** | - Tổng quan hệ thống<br>- Số liệu thống kê users, rewards, check-ins<br>- Biểu đồ phân tích |
| **👥 Users Management** | - Xem danh sách users<br>- Chỉnh sửa tên hiển thị<br>- Xem lịch sử hoạt động |
| **🎁 Rewards Management** | - Thêm/sửa/xóa phần thưởng<br>- Quản lý điểm đổi thưởng<br>- Upload ảnh qua Cloudinary |
| **📍 Collection Points** | - Quản lý điểm thu gom rác<br>- Thêm/sửa/xóa địa điểm<br>- Phân loại theo category |
| **💚 Tips Management** | - Quản lý mẹo tái chế<br>- Thêm/sửa tips với steps<br>- Upload ảnh minh họa |
| **✅ Check-ins** | - Xem lịch sử check-in<br>- Thống kê theo người dùng |
| **🔐 Authentication** | - Đăng nhập bảo mật cho admin |

---

## 🏗️ Kiến trúc & Cấu trúc dự án

```
graduation-project/
│
├── 📱 green_recycle_app/           # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart               # Entry point
│   │   ├── routes.dart             # App routing (15 routes)
│   │   ├── app_theme.dart          # Theme configuration (Light/Dark)
│   │   ├── firebase_options.dart   # Firebase config
│   │   │
│   │   ├── 📂 models/              # Data Models (4 files)
│   │   │   ├── user_model.dart
│   │   │   ├── classification_history.dart
│   │   │   ├── notification_model.dart
│   │   │   └── tip_model.dart
│   │   │
│   │   ├── 📂 services/            # Business Logic (10 services)
│   │   │   ├── auth_service.dart           # Firebase Authentication
│   │   │   ├── user_service.dart           # User management
│   │   │   ├── classifier_service.dart     # YOLOv11 TFLite inference
│   │   │   ├── history_service.dart        # Classification history
│   │   │   ├── chatbot_service.dart        # Gemini AI chatbot
│   │   │   ├── rewards_service.dart        # Rewards & Redemption
│   │   │   ├── check_in_service.dart       # Daily check-in system
│   │   │   ├── notification_service.dart   # Push notifications
│   │   │   ├── collection_point_service.dart
│   │   │   └── tips_service.dart
│   │   │
│   │   ├── 📂 screens/             # UI Screens
│   │   │   ├── auth/ (2 screens)
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   │
│   │   │   ├── onboarding/ (1 screen)
│   │   │   │   └── onboarding_screen.dart
│   │   │   │
│   │   │   ├── main/ (14 screens)
│   │   │   │   ├── main_screen.dart          # Bottom navigation
│   │   │   │   ├── home_screen.dart          # Dashboard
│   │   │   │   ├── camera_screen.dart        # YOLOv11 scanner
│   │   │   │   ├── result_screen.dart        # Scan results
│   │   │   │   ├── history_screen.dart       # Classification history
│   │   │   │   ├── stats_screen.dart         # Statistics & charts
│   │   │   │   ├── chatbot_screen.dart       # Gemini AI chat
│   │   │   │   ├── rewards_screen.dart       # Rewards catalog
│   │   │   │   ├── redemption_history_screen.dart
│   │   │   │   ├── collection_points_screen.dart
│   │   │   │   ├── profile_screen.dart
│   │   │   │   ├── edit_profile_screen.dart
│   │   │   │   ├── notifications_screen.dart
│   │   │   │   └── help_support_screen.dart
│   │   │   │
│   │   │   └── tips/ (1 screen)
│   │   │       └── tips_screen.dart
│   │   │
│   │   ├── 📂 providers/ (1 provider)
│   │   │   └── settings_provider.dart    # Theme & app settings
│   │   │
│   │   └── 📂 widgets/ (3 widgets)
│   │       ├── auth_wrapper.dart
│   │       ├── custom_button.dart
│   │       └── custom_text_field.dart
│   │
│   ├── assets/
│   │   └── images/
│   │       ├── best_float32.tflite     # YOLOv11 model (~6MB)
│   │       ├── label.txt               # 4 waste classes
│   │       └── onboarding_*.png        # Onboarding images
│   │
│   ├── android/                        # Android config
│   ├── ios/                            # iOS config
│   ├── web/                            # Web config
│   └── pubspec.yaml                    # Dependencies
│
├── 💻 green_admin/                     # React Admin Panel
│   ├── src/
│   │   ├── main.jsx                    # Entry point
│   │   ├── App.jsx                     # Main app component
│   │   ├── firebase.js                 # Firebase config
│   │   ├── cloudinary.js               # Image upload config
│   │   │
│   │   ├── components/
│   │   │   └── Layout.jsx              # Admin layout with sidebar
│   │   │
│   │   └── pages/ (7 pages)
│   │       ├── Login.jsx               # Admin login
│   │       ├── Dashboard.jsx           # Analytics dashboard
│   │       ├── Users.jsx               # User management
│   │       ├── Rewards.jsx             # Rewards CRUD
│   │       ├── CollectionPoints.jsx    # Points management
│   │       ├── Tips.jsx                # Tips management
│   │       └── CheckIns.jsx            # Check-in logs
│   │
│   ├── public/
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
│
├── ☁️ functions/                       # Firebase Cloud Functions
│   ├── index.js
│   └── package.json
│
├── 🎨 UI-UX/                           # Design files
│   ├── onboarding_*/
│   ├── trang_chủ_*/
│   ├── đăng_ký/
│   └── đăng_nhập/
│
└── 📚 examples/
    └── tutorial.ipynb                  # Jupyter notebook tutorials
```

---

## 🛠️ Công nghệ sử dụng

### 📱 Mobile App Stack

| Loại | Package | Version | Mục đích |
|------|---------|---------|----------|
| **Core** | Flutter | 3.10.3+ | Cross-platform framework |
| | Dart | ^3.10.3 | Programming language |
| **State** | Provider | ^6.1.5+1 | State management |
| | Shared Preferences | ^2.5.4 | Local storage |
| **UI** | Google Fonts | ^6.1.0 | Typography |
| | Cupertino Icons | ^1.0.8 | iOS-style icons |
| | Smooth Page Indicator | ^1.1.0 | Onboarding indicators |
| **Firebase** | Firebase Core | ^3.8.1 | Firebase SDK |
| | Firebase Auth | ^5.3.4 | Authentication |
| | Cloud Firestore | ^5.6.0 | NoSQL Database |
| | Firebase Storage | ^12.4.0 | File storage |
| | Cloud Functions | ^5.3.1 | Serverless functions |
| **Auth** | Google Sign In | ^6.2.2 | Google OAuth |
| **Media** | Camera | ^0.11.0+2 | Live camera |
| | Image Picker | ^1.0.7 | Pick/capture photos |
| | Image Cropper | ^8.0.2 | Avatar cropping |
| **AI** | flutter_vision | ^2.0.0 | YOLOv11 TFLite |
| | HTTP | ^1.2.0 | Gemini API calls |
| **Utils** | URL Launcher | ^6.2.5 | Open maps & links |
| | intl | ^0.19.0 | Date formatting |
| | flutter_dotenv | ^5.1.0 | Environment variables |

**Total: 19 production dependencies**

### 💻 Admin Panel Stack

| Package | Version | Mục đích |
|---------|---------|----------|
| **Core** | React | ^19.2.0 | UI framework |
| | React DOM | ^19.2.0 | DOM rendering |
| | React Router DOM | ^7.11.0 | Client-side routing |
| **UI** | Lucide React | ^0.562.0 | Icon library |
| | Recharts | ^3.6.0 | Charts & analytics |
| | TailwindCSS | ^4.1.18 | CSS framework |
| **Backend** | Firebase | ^12.7.0 | Backend services |
| **Build** | Vite | ^7.2.4 | Build tool & dev server |

### ☁️ Backend & AI

| Dịch vụ | Công nghệ | Mục đích |
|---------|-----------|----------|
| **Database** | Cloud Firestore | NoSQL realtime database |
| **Auth** | Firebase Authentication | Email + Google Sign-In |
| **Storage** | Firebase Storage | Avatar & image uploads |
| **Functions** | Cloud Functions | Serverless backend logic |
| **AI - Vision** | YOLOv11n | Object detection (waste classification) |
| **AI - Chat** | Gemini 1.5 Flash | Conversational AI chatbot |
| **Image CDN** | Cloudinary | Admin image uploads |

---

## 🤖 AI Models Chi tiết

### YOLOv11 - Waste Classification Model

| Thông số | Giá trị |
|----------|---------|
| **Model** | YOLOv11n (Nano) |
| **Format** | TensorFlow Lite (.tflite) |
| **File size** | ~6MB |
| **Classes** | 4 loại rác |
| **Input** | Camera frames / Images |
| **Output** | Class + Confidence score |
| **Inference** | On-device real-time |
| **Framework** | flutter_vision |

**4 Loại rác được nhận diện:**
1. **Organic waste** (Rác hữu cơ)
2. **Inorganic waste** (Rác vô cơ)
3. **Recyclable waste** (Rác tái chế được)
4. **Hazardous waste** (Rác nguy hại)

### Gemini AI - Chatbot

| Thông số | Giá trị |
|----------|---------|
| **Model** | gemini-1.5-flash |
| **Provider** | Google AI (Gemini API) |
| **Language** | Tiếng Việt |
| **Context** | Vietnam waste management |
| **Purpose** | Tư vấn phân loại rác & tái chế |
| **Features** | Multi-turn conversation |

---

## 📊 Database Structure (Cloud Firestore)

### Collections & Schema

#### 👤 `users`
```javascript
{
  userId: string,              // Document ID
  email: string,
  displayName: string,
  avatarUrl: string?,
  greenPoints: number,         // Điểm tích lũy
  rewardCount: number,         // Số lần đổi quà
  createdAt: Timestamp
}
```

#### 📜 `classification_history`
```javascript
{
  historyId: string,           // Document ID
  userId: string,              // User reference
  label: string,               // Loại rác (Tiếng Việt)
  labelEn: string,             // Waste type (English)
  confidence: number,          // Độ tin cậy (0-1)
  pointsEarned: number,        // Điểm nhận được
  imageUrl: string?,           // Ảnh đã quét
  timestamp: Timestamp
}
```

#### 🎁 `rewards`
```javascript
{
  rewardId: string,            // Document ID
  name: string,
  description: string,
  points: number,              // Điểm cần để đổi
  emoji: string,
  colorHex: string
}
```

#### 🎟️ `redemptions`
```javascript
{
  redemptionId: string,        // Document ID
  userId: string,
  rewardId: string,
  rewardName: string,
  rewardEmoji: string,
  pointsUsed: number,
  redeemedAt: Timestamp
}
```

#### ✅ `check_ins`
```javascript
{
  userId: string,              // Document ID
  lastCheckIn: Timestamp,
  streak: number,              // Chuỗi ngày liên tục
  totalCheckIns: number,       // Tổng số lần check-in
  nextCheckInDate: Timestamp
}
```

#### 🔔 `notifications`
```javascript
{
  notificationId: string,      // Document ID
  userId: string,
  title: string,
  message: string,
  type: string,                // 'check_in' | 'redemption' | 'general'
  isRead: boolean,
  createdAt: Timestamp
}
```

#### 📍 `collection_points`
```javascript
{
  pointId: string,             // Document ID
  name: string,
  address: string,
  category: string,            // 'Plastic' | 'Paper' | 'Electronic' | etc.
  latitude: number,
  longitude: number,
  phone: string?,
  imageUrl: string?
}
```

#### 💡 `tips`
```javascript
{
  tipId: string,               // Document ID
  title: string,
  description: string,
  steps: Array<string>,        // Chi tiết các bước
  imageUrl: string?,
  category: string,
  createdAt: Timestamp
}
```

---

## 🚀 Hướng dẫn cài đặt & Chạy

### Yêu cầu hệ thống

- **Flutter SDK**: 3.10.3 trở lên
- **Dart SDK**: ^3.10.3
- **Node.js**: v16+ (cho Admin Panel)
- **npm** hoặc **yarn**
- **Firebase CLI**: Latest version
- **IDE**: Android Studio / Xcode / VS Code
- **OS**: Windows / macOS / Linux

### 1️⃣ Clone Repository

```bash
git clone https://github.com/your-username/green-recycle.git
cd graduation-project
```

### 2️⃣ Cài đặt Mobile App (Flutter)

#### Bước 1: Install dependencies
```bash
cd green_recycle_app
flutter pub get
```

#### Bước 2: Cấu hình Firebase

1. Tạo project mới trên [Firebase Console](https://console.firebase.google.com/)
2. Thêm ứng dụng Android và/hoặc iOS
3. Tải file config:
   - Android: `google-services.json` → đặt vào `android/app/`
   - iOS: `GoogleService-Info.plist` → đặt vào `ios/Runner/`
4. Tạo Firestore Database (chế độ test hoặc production)
5. Enable Authentication (Email/Password + Google)
6. Tạo Storage bucket

#### Bước 3: Cấu hình Gemini API

Tạo file `.env` trong thư mục `green_recycle_app/`:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

> Đăng ký API key miễn phí tại [Google AI Studio](https://aistudio.google.com/app/apikey)

#### Bước 4: Chạy ứng dụng

```bash
# Kiểm tra devices
flutter devices

# Chạy debug mode
flutter run

# Hoặc chạy trên device cụ thể
flutter run -d <device_id>

# Build production APK
flutter build apk --release
```

### 3️⃣ Cài đặt Admin Panel (React + Vite)

#### Bước 1: Install dependencies
```bash
cd green_admin
npm install
```

#### Bước 2: Cấu hình Firebase

Cập nhật file `src/firebase.js` với Firebase config của bạn:

```javascript
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
```

#### Bước 3: Cấu hình Cloudinary (Optional)

Cập nhật `src/cloudinary.js`:

```javascript
export const CLOUDINARY_UPLOAD_PRESET = 'your_preset';
export const CLOUDINARY_CLOUD_NAME = 'your_cloud_name';
```

#### Bước 4: Chạy dev server

```bash
# Development mode
npm run dev

# Production build
npm run build

# Preview production build
npm run preview
```

Truy cập: `http://localhost:5173`

### 4️⃣ Deploy Firebase Cloud Functions

```bash
cd functions
npm install

# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:functionName
```

### 5️⃣ Khởi tạo dữ liệu mẫu

Sau khi deploy, vào Firebase Console và thêm dữ liệu mẫu vào các collections:
- `rewards` - Phần thưởng
- `collection_points` - Điểm thu gom
- `tips` - Mẹo tái chế

---

## 🎨 Design System

### Theme Support
- ☀️ **Light Mode**: Giao diện sáng, dễ nhìn ban ngày
- 🌙 **Dark Mode**: Giao diện tối, giảm mỏi mắt ban đêm

### Color Palette

```dart
// Primary Colors
Primary:       #4CAF50  (Green)
Primary Dark:  #2E7D32  (Dark Green)
Primary Light: #81C784  (Light Green)

// Semantic Colors
Success:       #66BB6A  (Green)
Error:         #F44336  (Red)
Warning:       #FFB74D  (Orange)
Info:          #29B6F6  (Blue)

// Neutrals
Background:    #FFFFFF  (White)
Surface:       #F5F5F5  (Light Gray)
Text Primary:  #212121  (Almost Black)
Text Secondary:#757575  (Gray)
```

### Typography

| Style | Font | Size | Weight |
|-------|------|------|--------|
| H1 | Google Fonts | 24px | Bold |
| H2 | Google Fonts | 20px | Bold |
| H3 | Google Fonts | 18px | SemiBold |
| Body Large | Google Fonts | 16px | Regular |
| Body | Google Fonts | 14px | Regular |
| Caption | Google Fonts | 12px | Regular |
| Button | Google Fonts | 14px | Bold |

### Spacing Scale
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

---

## 📸 Screenshots

### Mobile App

| | | |
|:---:|:---:|:---:|
| ![Onboarding](screenshots/onboarding.png)<br>**Onboarding** | ![Login](screenshots/login.png)<br>**Login** | ![Home](screenshots/home.png)<br>**Home** |
| ![Camera](screenshots/camera.png)<br>**Camera Scan** | ![Result](screenshots/result.png)<br>**Result** | ![Rewards](screenshots/rewards.png)<br>**Rewards** |

### Admin Panel

| Dashboard | Users | Rewards |
|:---------:|:-----:|:-------:|
| ![Dashboard](screenshots/admin-dashboard.png) | ![Users](screenshots/admin-users.png) | ![Rewards](screenshots/admin-rewards.png) |

---

## 🎯 Hướng dẫn sử dụng

### Người dùng (Mobile App)

1. **Đăng ký tài khoản** bằng email hoặc Google
2. **Xem hướng dẫn** qua màn hình onboarding
3. **Quét rác** bằng camera để phân loại và nhận điểm
4. **Check-in hàng ngày** để tích lũy điểm xanh
5. **Đổi điểm** lấy phần thưởng thân thiện môi trường
6. **Chat với AI** để tìm hiểu về phân loại rác
7. **Tìm điểm thu gom** gần bạn trên bản đồ
8. **Xem thống kê** lịch sử và cá nhân

### Admin (Web Panel)

1. **Đăng nhập** với tài khoản admin
2. **Xem Dashboard** để theo dõi tổng quan
3. **Quản lý Users** - xem và chỉnh sửa thông tin
4. **Quản lý Rewards** - thêm/sửa/xóa phần thưởng
5. **Quản lý Collection Points** - cập nhật điểm thu gom
6. **Quản lý Tips** - thêm mẹo tái chế mới
7. **Theo dõi Check-ins** - xem lịch sử check-in

---

## 🧪 Testing

### Mobile App Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

### Admin Panel Testing
```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

---

## 🚢 Deployment

### Mobile App

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Build iOS
flutter build ios --release

# Build IPA
flutter build ipa --release
```

### Admin Panel (Vercel / Netlify)

```bash
# Build for production
npm run build

# Deploy to Vercel
vercel deploy --prod

# Or deploy to Netlify
netlify deploy --prod
```

### Firebase Hosting (Admin Panel)

```bash
# Build
npm run build

# Deploy
firebase deploy --only hosting
```

---

## 📁 File quan trọng

| File | Mô tả |
|------|-------|
| `green_recycle_app/lib/main.dart` | Entry point app |
| `green_recycle_app/lib/routes.dart` | Định tuyến app |
| `green_recycle_app/pubspec.yaml` | Dependencies & assets |
| `green_admin/src/App.jsx` | Entry point admin |
| `green_admin/vite.config.js` | Vite configuration |
| `functions/index.js` | Cloud Functions |
| `firebase.json` | Firebase config |

---

## 🤝 Đóng góp

Mọi đóng góp đề xuất đều được hoan nghênh! 

### Quy trình đóng góp:

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

### Coding Standards:
- **Flutter**: Sử dụng `flutter analyze` và `dart format`
- **React**: Sử dụng ESLint configuration có sẵn
- **Commit messages**: Sử dụng conventional commits

---

## 📄 License

Dự án này được phát triển cho mục đích học tập và đồ án tốt nghiệp.

---

## 👥 Tác giả

**[Nguyễn Khánh Linh]**
- Email: linhnk.21it@vku.udn.vn
---

## 🙏 Credits & Acknowledgments

### Công nghệ & Framework
- [Flutter](https://flutter.dev/) - Google's UI Toolkit
- [React](https://react.dev/) - Facebook's UI Library
- [Firebase](https://firebase.google.com/) - Google's Backend Platform
- [Vite](https://vitejs.dev/) - Next Generation Frontend Tooling

### AI & ML
- [Google Gemini](https://ai.google.dev/) - Gemini AI API
- [Ultralytics](https://github.com/ultralytics/ultralytics) - YOLOv11
- [TensorFlow Lite](https://www.tensorflow.org/lite) - ML Framework

### UI/UX
- [Google Fonts](https://fonts.google.com/)
- [Lucide Icons](https://lucide.dev/)
- [TailwindCSS](https://tailwindcss.com/)

---



---

## 📊 Project Status

### Current Version: 1.0.0

### Roadmap
- [x] Mobile App với YOLOv11
- [x] Gemini AI Chatbot
- [x] Hệ thống check-in & rewards
- [x] Admin Panel
- [ ] Notifications push (FCM)
- [ ] Social sharing
- [ ] Leaderboard
- [ ] Multi-language support

---

<div align="center">

### 🌱 Cùng nhau bảo vệ môi trường xanh - sạch - đẹp 🌍

**Made with ❤️ and ☕ for a greener future**

---

[![Stars](https://img.shields.io/github/stars/your-repo/green-recycle?style=social)](https://github.com/your-repo/green-recycle)
[![Forks](https://img.shields.io/github/forks/your-repo/green-recycle?style=social)](https://github.com/your-repo/green-recycle/fork)

</div>
