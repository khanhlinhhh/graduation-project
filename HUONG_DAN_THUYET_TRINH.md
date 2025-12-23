# 🎯 HƯỚNG DẪN THUYẾT TRÌNH DỰ ÁN TỐT NGHIỆP
# GREEN RECYCLE - HỆ THỐNG PHÂN LOẠI RÁC THÔNG MINH

---

## 📑 MỤC LỤC

1. [Tổng quan buổi thuyết trình](#1-tổng-quan-buổi-thuyết-trình)
2. [Phần 1: Giới thiệu (5 phút)](#2-phần-1-giới-thiệu-5-phút)
3. [Phần 2: Bối cảnh và Mục tiêu (5 phút)](#3-phần-2-bối-cảnh-và-mục-tiêu-5-phút)
4. [Phần 3: Công nghệ và Kiến trúc (7 phút)](#4-phần-3-công-nghệ-và-kiến-trúc-7-phút)
5. [Phần 4: Demo Ứng dụng Mobile (10 phút)](#5-phần-4-demo-ứng-dụng-mobile-10-phút)
6. [Phần 5: Demo Admin Panel (5 phút)](#6-phần-5-demo-admin-panel-5-phút)
7. [Phần 6: Kết quả đạt được (5 phút)](#7-phần-6-kết-quả-đạt-được-5-phút)
8. [Phần 7: Hạn chế và Hướng phát triển (3 phút)](#8-phần-7-hạn-chế-và-hướng-phát-triển-3-phút)
9. [Phần 8: Kết luận (2 phút)](#9-phần-8-kết-luận-2-phút)
10. [Phần 9: Hỏi đáp](#10-phần-9-hỏi-đáp)
11. [Checklist chuẩn bị](#11-checklist-chuẩn-bị)

---

## 1. TỔNG QUAN BUỔI THUYẾT TRÌNH

### ⏰ Thời lượng: 40-45 phút
- Thuyết trình: 35-40 phút
- Hỏi đáp: 10-15 phút

### 🎯 Mục tiêu
- Trình bày rõ ràng vấn đề và giải pháp
- Demo đầy đủ các tính năng chính
- Thể hiện kiến thức về công nghệ AI/ML và phát triển ứng dụng
- Thuyết phục được tính ứng dụng thực tiễn của dự án

### 📊 Công cụ cần chuẩn bị
- [ ] Slide thuyết trình (PowerPoint/Google Slides)
- [ ] Điện thoại Android/iOS đã cài app
- [ ] Laptop với Admin Panel đã chạy
- [ ] Kết nối Internet ổn định (cho Firebase, Gemini API)
- [ ] Dự phòng: Video demo (nếu có sự cố)

---

## 2. PHẦN 1: GIỚI THIỆU (5 phút)

### 🎬 Mở đầu

**Chào mời:**
> "Kính chào quý thầy cô và các bạn. Em là [Nguyễn Khánh Linh], hôm nay em xin được trình bày đồ án tốt nghiệp với đề tài: **'Hệ thống Phân loại Rác Thông minh sử dụng AI và Deep Learning'**."

### 📋 Giới thiệu dự án

**Nội dung trình bày:**

1. **Tên dự án**: Green Recycle
2. **Loại hình**: Hệ sinh thái hoàn chỉnh
3. **Thành phần**:
   - 📱 Ứng dụng Mobile (Flutter)
   - 💻 Admin Panel (React)
   - ☁️ Backend Services (Firebase)

### 🎯 Vấn đề đặt ra

**Slide nội dung:**

> **📊 Thực trạng:**
> - Việt Nam thải ra ~38 triệu tấn rác/năm
> - Chỉ ~10% được tái chế đúng cách
> - Người dân chưa có thói quen phân loại rác tại nguồn
> - Thiếu công cụ hỗ trợ phân loại rác hiệu quả

**Câu kết nối:**
> "Chính vì vậy, em đã phát triển **Green Recycle** - một giải pháp công nghệ giúp người dùng phân loại rác dễ dàng, chính xác và có động lực duy trì thói quen tốt này."

---

## 3. PHẦN 2: BỐI CẢNH VÀ MỤC TIÊU (5 phút)

### 🎯 Mục tiêu dự án

**Slide 1: Mục tiêu chính**

1. **Nâng cao nhận thức**: Giáo dục cộng đồng về phân loại rác
2. **Ứng dụng AI**: Áp dụng YOLOv11 vào bài toán thực tế
3. **Khuyến khích hành vi**: Hệ thống gamification với điểm thưởng
4. **Cung cấp thông tin**: Điểm thu gom rác, mẹo tái chế

### 📱 Đối tượng sử dụng

**Người dùng cuối (Mobile App):**
- Người dân có ý thức bảo vệ môi trường
- Học sinh, sinh viên
- Các hộ gia đình thực hiện phân loại rác

**Admin:**
- Tổ chức môi trường
- Nhà quản lý hệ thống
- Điều hành viên nội dung

### 🔍 Khảo sát các giải pháp hiện có

**So sánh:**

| Giải pháp | Ưu điểm | Nhược điểm |
|-----------|---------|------------|
| Apps phân loại thủ công | Đơn giản | Không có AI, thiếu động lực |
| Web tra cứu loại rác | Thông tin phong phú | Không tương tác, khó dùng |
| **Green Recycle** | AI tự động, gamification, chatbot | - |

---

## 4. PHẦN 3: CÔNG NGHỆ VÀ KIẾN TRÚC (7 phút)

### 🏗️ Kiến trúc tổng quan

**Slide: Sơ đồ kiến trúc 3 tầng**

```
┌─────────────────┐
│  Mobile App     │ ← Flutter (iOS/Android)
│  (Flutter)      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Backend        │ ← Firebase (Auth, Firestore, Storage)
│  (Firebase)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Admin Panel    │ ← React + Vite
│  (React)        │
└─────────────────┘
```

**Giải thích:**
- Mobile App: Giao diện người dùng cuối
- Firebase: Xử lý authentication, lưu trữ dữ liệu, file
- Admin Panel: Quản trị nội dung và người dùng

### 🤖 AI Models

**Slide 1: YOLOv11 - Waste Classification**

| Thông số | Chi tiết |
|----------|----------|
| **Model** | YOLOv11n (Nano) |
| **Format** | TensorFlow Lite |
| **Kích thước** | ~6MB |
| **Số lớp** | 4 loại rác |
| **Inference** | Real-time trên thiết bị |

**4 Loại rác:**
1. 🍃 Organic (Hữu cơ): thực phẩm, lá cây
2. 🧱 Inorganic (Vô cơ): đồ gốm, đất đá
3. ♻️ Recyclable (Tái chế): nhựa, giấy, kim loại
4. ⚠️ Hazardous (Nguy hại): pin, hóa chất

**Slide 2: Gemini AI - Chatbot**

| Thông số | Chi tiết |
|----------|----------|
| **Model** | gemini-1.5-flash |
| **Ngôn ngữ** | Tiếng Việt |
| **Chức năng** | Tư vấn phân loại, trả lời câu hỏi |
| **Context** | Quản lý rác tại Việt Nam |

### 💻 Tech Stack

**Mobile App:**
- Flutter 3.10.3+ (Cross-platform)
- Provider (State management)
- Firebase Suite (Backend)
- flutter_vision (YOLOv11 TFLite)
- Google Fonts (UI)

**Admin Panel:**
- React 19.2.0
- Vite (Build tool)
- TailwindCSS (Styling)
- Recharts (Analytics)
- Cloudinary (Image CDN)

**Backend:**
- Firebase Authentication
- Cloud Firestore (Database)
- Firebase Storage
- Cloud Functions

### 📊 Database Structure

**Slide: Firestore Collections**

**Các collections chính:**

1. **users**: Thông tin người dùng, điểm xanh
2. **classification_history**: Lịch sử quét rác
3. **rewards**: Danh sách phần thưởng
4. **redemptions**: Lịch sử đổi quà
5. **check_ins**: Check-in hàng ngày
6. **notifications**: Thông báo
7. **collection_points**: Điểm thu gom rác
8. **tips**: Mẹo tái chế

---

## 5. PHẦN 4: DEMO ỨNG DỤNG MOBILE (10 phút)

> **LƯU Ý**: Đây là phần quan trọng nhất! Cần demo thực tế, mượt mà

---

### 🎬 KỊCH BẢN DEMO CHI TIẾT

> **Mục tiêu**: Demo 7 scenarios trong 10 phút, mỗi scenario có script rõ ràng

---

### 📲 **SCENARIO 1: Onboarding & Đăng nhập** (1 phút)

#### 🎯 Mục tiêu
- Giới thiệu flow onboarding
- Demo xác thực người dùng

#### 📝 Script thuyết trình

**[Cầm điện thoại lên, màn hình chiếu rõ]**

> "Bây giờ em xin demo trực tiếp ứng dụng. Khi mở app lần đầu..."

#### ⚡ Hành động (từng bước)

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Mở app | "Người dùng sẽ thấy màn hình chào mừng" | 5s |
| 2 | Swipe qua screen 1 | "Giới thiệu tính năng phân loại rác bằng AI" | 5s |
| 3 | Swipe qua screen 2 | "Hệ thống điểm thưởng và check-in" | 5s |
| 4 | Swipe qua screen 3 | "Chatbot tư vấn và bản đồ thu gom" | 5s |
| 5 | Nhấn "Bắt đầu" | "Chọn bắt đầu để vào app" | 2s |
| 6 | Nhấn "Đăng nhập Google" | "Hệ thống hỗ trợ đăng nhập Google nhanh chóng" | 5s |
| 7 | Chọn tài khoản Google | "Firebase Authentication xử lý bảo mật" | 10s |
| 8 | Vào Home screen | "Và đây là trang chủ của ứng dụng" | 5s |

**💬 Câu kết:** 
> "Vậy là người dùng đã đăng nhập thành công. Bây giờ chúng ta sẽ xem các tính năng chính."

---

### 🏠 **SCENARIO 2: Home Screen & Tips** (30 giây)

#### 🎯 Mục tiêu
- Giới thiệu giao diện chính
- Demo tính năng tips

#### 📝 Script thuyết trình

> "Trang chủ hiển thị các thông tin quan trọng..."

#### ⚡ Hành động

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Point vào điểm xanh | "Đây là điểm tích lũy của người dùng: 125 điểm" | 3s |
| 2 | Point vào streak | "Chuỗi check-in: 5 ngày liên tục" | 3s |
| 3 | Scroll xuống Tips | "Phần mẹo tái chế với 30+ tips" | 3s |
| 4 | Nhấn vào 1 tip | "Ví dụ: Tái chế chai nhựa" | 2s |
| 5 | Xem steps | "Có 5 bước hướng dẫn chi tiết" | 5s |
| 6 | Đóng lại | "Người dùng có thể áp dụng ngay" | 2s |

---

### 📸 **SCENARIO 3: Camera Scanner - TÍNH NĂNG CHÍNH** (3 phút)

#### 🎯 Mục tiêu
- Demo AI phân loại rác real-time
- Giải thích công nghệ YOLOv11

#### 📝 Script thuyết trình

> "Bây giờ là tính năng cốt lõi - phân loại rác bằng AI"

#### ⚡ Hành động

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Nhấn icon Camera | "Người dùng mở camera..." | 2s |
| 2 | Chờ load model | "YOLOv11 model đang khởi động" | 5s |
| 3 | Cầm vật phẩm (chai nhựa) | "Em sẽ demo với một chai nhựa" | 3s |
| 4 | Hướng camera vào vật | "Camera đang quét real-time" | 5s |
| 5 | Nhấn "Chụp" | "Bấm chụp để phân loại" | 2s |
| 6 | Chờ kết quả | "Model đang inference..." | 3s |
| 7 | Hiện kết quả | "**Kết quả:** Recyclable waste - 95.2% confidence" | 5s |
| 8 | Point vào loại rác | "Hệ thống nhận diện đây là rác tái chế được" | 3s |
| 9 | Point vào confidence | "Độ tin cậy 95.2% - rất cao" | 3s |
| 10 | Scroll xuống | "Hướng dẫn xử lý: rửa sạch, bỏ vào thùng xanh" | 5s |
| 11 | Point điểm | "Người dùng nhận được +5 điểm" | 3s |
| 12 | Nhấn "Lưu lịch sử" | "Lưu vào Firestore kèm ảnh" | 3s |

**💬 Giải thích chi tiết:**

> "Công nghệ em sử dụng là YOLOv11n - phiên bản nano được tối ưu cho mobile. Model có kích thước chỉ 6MB nhưng đạt độ chính xác trên 90%.
>
> Em đã convert sang TensorFlow Lite để chạy trực tiếp trên thiết bị, không cần internet, thời gian inference chỉ khoảng 60-80ms.
>
> Model được train với 4 loại rác chính tại Việt Nam: Organic (hữu cơ), Inorganic (vô cơ), Recyclable (tái chế), và Hazardous (nguy hại)."

---

### 📜 **SCENARIO 4: History & Statistics** (1 phút)

#### 🎯 Mục tiêu
- Xem lịch sử phân loại
- Hiển thị thống kê bằng biểu đồ

#### 📝 Script thuyết trình

> "Người dùng có thể xem lại toàn bộ lịch sử..."

#### ⚡ Hành động

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Về Home, nhấn History | "Mở lịch sử phân loại" | 2s |
| 2 | Scroll danh sách | "25 lần quét, có ảnh, thời gian, độ chính xác" | 5s |
| 3 | Nhấn vào 1 item | "Xem chi tiết lần quét chai nhựa lúc nãy" | 5s |
| 4 | Xem thông tin | "Ảnh, loại rác, confidence 95.2%, thời gian" | 5s |
| 5 | Back, chuyển Statistics | "Phần thống kê trực quan" | 3s |
| 6 | Xem biểu đồ tròn | "Recyclable 50%, Organic 30%, Inorganic 15%, Hazardous 5%" | 10s |

**💬 Câu kết:**
> "Như vậy người dùng dễ dàng theo dõi thói quen phân loại rác của mình."

---

### 🎁 **SCENARIO 5: Check-in & Rewards** (2.5 phút)

#### 🎯 Mục tiêu
- Demo check-in hàng ngày
- Đổi thưởng thành công
- Xem lịch sử redemption

#### 📝 Script thuyết trình

> "Để tạo động lực, em thiết kế hệ thống gamification..."

#### ⚡ Hành động - Phần Check-in

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Về Home | "Người dùng vào trang chủ" | 2s |
| 2 | Nhấn "Check-in hôm nay" | "Nhấn nút check-in" | 2s |
| 3 | Hiệu ứng confetti | "Nhận +10 điểm với hiệu ứng vui mắt" | 3s |
| 4 | Điểm tăng 125→135 | "Điểm xanh tăng lên 135" | 2s |
| 5 | Streak tăng 5→6 | "Chuỗi ngày tăng lên 6 ngày liên tục" | 3s |

#### ⚡ Hành động - Phần Rewards

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 6 | Nhấn tab Rewards | "Chuyển sang phần đổi quà" | 2s |
| 7 | Scroll danh sách | "6 phần thưởng: Bút, Hạt giống, Vở, Sổ tay, Túi rác, Cây cảnh" | 10s |
| 8 | Point "Túi rác - 50đ" | "Đây cần 50 điểm - người dùng đủ điểm" | 3s |
| 9 | Nhấn "Đổi ngay" | "Chọn đổi quà" | 2s |
| 10 | Dialog xác nhận | "Xác nhận dùng 50 điểm?" | 2s |
| 11 | Nhấn "Xác nhận" | "Đồng ý" | 2s |
| 12 | Success message | "Đổi thành công!" | 2s |
| 13 | Điểm giảm 135→85 | "Điểm còn 85" | 2s |

#### ⚡ Hành động - Lịch sử đổi quà

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 14 | Nhấn icon History | "Xem lịch sử đổi quà" | 2s |
| 15 | Xem danh sách | "Túi rác phân hủy - 50 điểm - 23/12/2025" | 5s |

**💬 Giải thích:**
> "Hệ thống này khuyến khích người dùng check-in đều đặn và tích điểm. Các phần thưởng đều là sản phẩm eco-friendly, phù hợp với mục tiêu bảo vệ môi trường của app."

---

### 🤖 **SCENARIO 6: AI Chatbot** (1.5 phút)

#### 🎯 Mục tiêu
- Demo chatbot Gemini
- Hỏi đáp bằng tiếng Việt

#### 📝 Script thuyết trình

> "Khi người dùng có thắc mắc, họ có thể hỏi chatbot AI..."

#### ⚡ Hành động

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Nhấn tab Chatbot | "Mở trợ lý AI" | 2s |
| 2 | Giao diện chat | "Giao diện chat quen thuộc" | 2s |
| 3 | Gõ "Vỏ hộp sữa thuộc loại rác gì?" | "Hỏi câu hỏi thực tế" | 5s |
| 4 | Nhấn Send | "Gửi" | 1s |
| 5 | Chatbot suy nghĩ | "Gemini đang xử lý..." | 3s |
| 6 | Nhận reply tiếng Việt | "Bot trả lời chi tiết bằng tiếng Việt" | 10s |
| 7 | Đọc 1-2 câu reply | "Vỏ hộp sữa Tetra Pak là rác tái chế được... nên rửa sạch trước khi bỏ..." | 15s |
| 8 | Gõ thêm câu hỏi | "Làm sao tái chế pin cũ?" | 5s |
| 9 | Nhận reply | "Hướng dẫn mang đến điểm thu gom chuyên dụng" | 10s |

**💬 Giải thích:**
> "Chatbot sử dụng Gemini 1.5 Flash của Google. Em đã cấu hình system prompt để bot tập trung vào context quản lý rác tại Việt Nam. Bot có thể trả lời mọi câu hỏi về phân loại, tái chế, xử lý rác bằng tiếng Việt tự nhiên."

---

### 📍 **SCENARIO 7: Collection Points & Profile** (1.5 phút)

#### 🎯 Mục tiêu
- Tìm điểm thu gom
- Quản lý profile
- Dark mode

#### 📝 Script thuyết trình

> "Ngoài ra app còn cung cấp thêm các tiện ích..."

#### ⚡ Hành động - Collection Points

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 1 | Nhấn "Điểm thu gom" | "Bản đồ điểm thu gom rác" | 2s |
| 2 | Xem danh sách | "Danh sách các điểm gần đây" | 3s |
| 3 | Filter "Plastic" | "Lọc theo loại nhựa" | 3s |
| 4 | Nhấn vào 1 điểm | "Xem chi tiết điểm thu gom" | 2s |
| 5 | Xem info | "Tên, địa chỉ, category, số điện thoại" | 5s |
| 6 | Nhấn "Chỉ đường" | "Mở Google Maps chỉ đường" | 3s |
| 7 | Maps mở | "Tích hợp seamless với Google Maps" | 3s |

#### ⚡ Hành động - Profile

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 8 | Back, vào Profile | "Trang cá nhân" | 2s |
| 9 | Xem info | "Avatar, tên, email, điểm" | 3s |
| 10 | Nhấn "Chỉnh sửa" | "Chỉnh sửa hồ sơ" | 2s |
| 11 | Nhấn avatar | "Upload ảnh mới" | 2s |
| 12 | Chọn từ gallery | "Chọn ảnh từ thư viện" | 5s |
| 13 | Crop ảnh | "Cắt ảnh avatar" | 5s |
| 14 | Lưu | "Upload lên Firebase Storage" | 5s |
| 15 | Đổi display name | "Đổi tên hiển thị" | 5s |
| 16 | Back, toggle Dark Mode | "Bật Dark Mode" | 3s |
| 17 | Giao diện đổi màu | "Giao diện chuyển sang tối, bảo vệ mắt" | 3s |

#### ⚡ Hành động - Notifications

| Bước | Hành động | Nói gì | Thời gian |
|------|-----------|--------|-----------|
| 18 | Nhấn "Thông báo" (badge 2) | "Có 2 thông báo chưa đọc" | 2s |
| 19 | Xem danh sách | "Check-in thành công, Đổi quà thành công" | 5s |
| 20 | Đánh dấu đã đọc | "Badge biến mất" | 2s |

**💬 Câu kết:**
> "Vậy là em đã demo xong các tính năng chính của ứng dụng mobile. Bây giờ chúng ta chuyển qua phần Admin Panel."

---

### 📊 BẢNG TỔNG HỢP THỜI GIAN

| Scenario | Thời gian | Độ ưu tiên | Có thể skip nếu thiếu thời gian? |
|----------|-----------|------------|----------------------------------|
| 1. Onboarding & Đăng nhập | 1:00 | Trung bình | Có (có thể nói qua) |
| 2. Home & Tips | 0:30 | Thấp | Có |
| 3. **Camera Scanner (QUAN TRỌNG)** | **3:00** | **CAO** | **KHÔNG** |
| 4. History & Stats | 1:00 | Trung bình | Có (chỉ show nhanh) |
| 5. Check-in & Rewards | 2:30 | Cao | Không nên |
| 6. AI Chatbot | 1:30 | Cao | Không nên |
| 7. Collection Points & Profile | 1:30 | Thấp | Có |
| **TỔNG** | **10:00** | | |

---

### 💡 TIPS DEMO THÀNH CÔNG

#### ✅ Chuẩn bị trước

1. **Vật phẩm demo:** Chuẩn bị sẵn 3-4 vật: chai nhựa, giấy, pin cũ
2. **Tài khoản:** Tạo tài khoản demo với data đẹp
3. **Điểm:** Đảm bảo đủ điểm để đổi quà
4. **Internet:** Test 4G + WiFi backup
5. **Pin:** Charge đầy, bật chế độ tiết kiệm pin
6. **Brightness:** Tăng độ sáng tối đa cho dễ nhìn

#### ⚠️ Xử lý sự cố

| Sự cố | Giải pháp |
|-------|-----------|
| **Camera không load** | "Để em restart app..." (có backup video) |
| **Internet lag** | "Do mạng chậm, em sẽ dùng video đã record" |
| **Model sai kết quả** | "Trong một số trường hợp đặc biệt model có thể nhầm, user có thể chụp lại hoặc hỏi chatbot" |
| **App crash** | "Em để điện thoại backup ở đây..." |

#### 🎯 Điểm nhấn khi demo

1. **Nhấn mạnh:**
   - "Real-time" (Camera scanner)
   - "Tiếng Việt" (Chatbot)
   - "On-device" (Không cần internet cho AI)
   - "Gamification" (Điểm thưởng tạo động lực)

2. **Tương tác với BGK:**
   - "Quý thầy cô có thể thấy..."
   - "Như các thầy cô thấy..."
   - Nhìn vào BGK khi giải thích

3. **Giọng điệu:**
   - Tự tin, rõ ràng
   - Không quá nhanh
   - Nhiệt tình khi nói về tính năng hay

---

---

## 6. PHẦN 5: DEMO ADMIN PANEL (5 phút)

### 💻 Đăng nhập Admin

**Hành động:**
1. Mở `http://localhost:5173`
2. Đăng nhập với tài khoản admin

### 📊 Dashboard

**Hành động:**
1. Xem tổng quan:
   - Total Users
   - Total Rewards Redeemed
   - Total Check-ins
2. Xem biểu đồ xu hướng

**Giải thích:**
> "Dashboard cung cấp cái nhìn tổng quan về hệ thống với các chỉ số quan trọng và biểu đồ phân tích."

### 👥 Users Management

**Hành động:**
1. Mở Users tab
2. Xem danh sách users
3. Chọn 1 user
4. Chỉnh sửa display name
5. Lưu thay đổi

**Giải thích:**
> "Admin có thể xem và quản lý danh sách người dùng, chỉnh sửa thông tin cơ bản."

### 🎁 Rewards Management

**Hành động:**
1. Mở Rewards tab
2. Nhấn "Add Reward"
3. Điền thông tin:
   - Name: "Túi Vải Eco"
   - Points: 5000
   - Description: "Túi vải tái chế"
   - Upload image
4. Save

**Giải thích:**
> "Admin có thể thêm, sửa, xóa phần thưởng. Hình ảnh được upload lên Cloudinary để tối ưu tốc độ tải."

### 💡 Tips Management

**Hành động:**
1. Mở Tips tab
2. Thêm tip mới với steps
3. Upload ảnh minh họa

### 📍 Collection Points

**Hành động:**
- Xem và quản lý điểm thu gom

### ✅ Check-ins Log

**Hành động:**
- Xem lịch sử check-in của users

---

## 7. PHẦN 6: KẾT QUẢ ĐẠT ĐƯỢC (5 phút)

### ✅ Các tính năng đã hoàn thành

**Slide checklist:**

- ✅ **Mobile App (Flutter)**
  - ✅ AI Scanner với YOLOv11
  - ✅ 4 loại rác classification
  - ✅ Lịch sử quét với ảnh và stats
  - ✅ Daily check-in system
  - ✅ Rewards redemption
  - ✅ Gemini AI chatbot (Tiếng Việt)
  - ✅ Bản đồ điểm thu gom
  - ✅ 30+ mẹo tái chế
  - ✅ Thông báo in-app
  - ✅ Profile management (avatar upload)
  - ✅ Dark mode
  - ✅ Google Sign-In

- ✅ **Admin Panel (React)**
  - ✅ Dashboard analytics
  - ✅ Users management
  - ✅ Rewards CRUD
  - ✅ Collection Points management
  - ✅ Tips management
  - ✅ Check-ins monitoring

- ✅ **Backend (Firebase)**
  - ✅ Authentication (Email + Google)
  - ✅ Firestore database (8 collections)
  - ✅ Storage (avatar, images)
  - ✅ Real-time sync

### 📊 Metrics & Performance

**Slide số liệu:**

| Metric | Giá trị |
|--------|---------|
| **Số màn hình** | 18 screens |
| **Số services** | 10 services |
| **Model size** | ~6MB (TFLite) |
| **Inference time** | <100ms real-time |
| **Accuracy** | >90% (test set) |
| **Dependencies** | 19 packages (Flutter) |
| **Code organization** | MVC pattern |

### 🎯 Đánh giá

**Ưu điểm:**
- ✅ Giải quyết được bài toán thực tế
- ✅ Ứng dụng AI hiệu quả
- ✅ UX/UI thân thiện, dễ sử dụng
- ✅ Hệ thống gamification tạo động lực
- ✅ Cross-platform (iOS + Android)
- ✅ Offline-capable (model on-device)
- ✅ Kiến trúc mở rộng tốt

---

## 8. PHẦN 7: HẠN CHẾ VÀ HƯỚNG PHÁT TRIỂN (3 phút)

### ⚠️ Hạn chế hiện tại

**Slide hạn chế:**

1. **Model AI:**
   - Dataset còn hạn chế (cần mở rộng)
   - Chưa detect được nhiều loại vật phẩm cụ thể
   - Đôi khi bị nhầm với background phức tạp

2. **Tính năng:**
   - Chưa có push notification (FCM)
   - Chưa có social sharing
   - Chưa có leaderboard

3. **Khác:**
   - Chưa có version iOS testing kỹ
   - Chưa support đa ngôn ngữ (chỉ Tiếng Việt)

### 🚀 Hướng phát triển

**Slide roadmap:**

**Ngắn hạn (1-3 tháng):**
- 📱 Push notifications với FCM
- 🌍 Multi-language support (English, Tiếng Việt)
- 🏆 Leaderboard và social features
- 📊 Mở rộng dataset, train lại model
- 🎨 Thêm animations, UI polish

**Trung hạn (3-6 tháng):**
- 🤖 Nâng cấp lên YOLOv11s (model lớn hơn)
- 🎥 Video classification support
- 🗺️ AR chỉ điểm thu gom gần nhất
- 💼 Enterprise version cho tổ chức
- 📈 Advanced analytics dashboard

**Dài hạn (6-12 tháng):**
- 🌐 Web version của app
- 🏭 Tích hợp với nhà máy tái chế
- 💰 Marketplace đổi điểm lấy tiền/voucher
- 🤝 Hợp tác với chính quyền địa phương
- 📱 IoT integration (smart bins)

---

## 9. PHẦN 8: KẾT LUẬN (2 phút)

### 🎯 Tổng kết

**Slide kết luận:**

> **Green Recycle** là một hệ sinh thái hoàn chỉnh giúp:
> 
> ✅ **Nâng cao nhận thức** cộng đồng về phân loại rác
> 
> ✅ **Ứng dụng AI/ML** vào bài toán môi trường thực tế
> 
> ✅ **Tạo động lực** thông qua gamification
> 
> ✅ **Cung cấp công cụ** dễ dùng và hiệu quả

### 🙏 Lời cảm ơn

> "Em xin chân thành cảm ơn:
> - Thầy/Cô hướng dẫn [Tên GV] đã tận tình hỗ trợ
> - Ban giám khảo đã dành thời gian đánh giá
> - Gia đình và bạn bè đã ủng hộ
> 
> Em rất mong nhận được góp ý từ quý thầy cô để hoàn thiện hơn dự án này!"

### 📞 Thông tin liên hệ

**Slide cuối:**

- 👤 **Sinh viên**: Nguyễn Khánh Linh
- 📧 **Email**: linhnk.21it@vku.udn.vn
- 🎓 **Trường**: Đại học Công nghệ Thông tin và Truyền thông Việt - Hàn, Đại học Đà Nẵng
- 📅 **Năm**: 2025

---

## 10. PHẦN 9: HỎI ĐÁP

### 📝 Các câu hỏi thường gặp và cách trả lời

#### **Q1: Tại sao chọn YOLOv11 thay vì các model khác?**

**Trả lời:**
> "Em chọn YOLOv11n vì:
> 1. **Real-time performance**: Inference <100ms trên mobile
> 2. **Kích thước nhỏ**: ~6MB phù hợp on-device
> 3. **Accuracy cao**: Đạt >90% trên test set
> 4. **TFLite support**: Dễ integrate với Flutter
> 5. **State-of-the-art**: YOLOv11 là phiên bản mới nhất (2024)
> 
> So với MobileNet, EfficientNet thì YOLO tốt hơn cho object detection."

#### **Q2: Dataset được thu thập từ đâu? Số lượng bao nhiêu?**

**Trả lời:**
> "Em sử dụng dataset kết hợp:
> 1. Public datasets: TACO, TrashNet
> 2. Tự thu thập: ~[số lượng] ảnh tại Việt Nam
> 3. Data augmentation: xoay, flip, brightness
> 
> Tổng cộng ~[X] images cho 4 classes. Em đã split 70% train, 20% val, 10% test."

#### **Q3: Làm sao đảm bảo accuracy khi ánh sáng thay đổi?**

**Trả lời:**
> "Em có áp dụng:
> 1. Data augmentation với brightness/contrast variations
> 2. Preprocessing ảnh input trước khi inference
> 3. User có thể chụp lại nếu confidence thấp (<70%)
> 4. Có thể bật flash khi thiếu sáng"

#### **Q4: Chi phí vận hành hệ thống?**

**Trả lời:**
> "Chi phí chủ yếu từ Firebase:
> 1. **Firestore**: Free tier 1GB, 50K reads/day
> 2. **Storage**: Free tier 5GB
> 3. **Authentication**: Free unlimited
> 4. **Gemini API**: Free tier 15 requests/minute
> 
> Với quy mô nhỏ (<10K users) hoàn toàn FREE. Scale lên mới tốn ~$50-100/tháng."

#### **Q5: Tại sao không dùng Cloud Vision API thay vì model on-device?**

**Trả lời:**
> "On-device có ưu điểm:
> 1. **Privacy**: Ảnh không upload lên cloud
> 2. **Offline**: Không cần internet để classify
> 3. **Latency**: Nhanh hơn (<100ms vs ~500ms)
> 4. **Cost**: Không tốn phí API calls
> 
> Nhược điểm là accuracy có thể thấp hơn cloud model, nhưng đủ cho use case này."

#### **Q6: Có kế hoạch kiếm tiền từ app không?**

**Trả lời:**
> "Có, em có một số hướng monetization:
> 1. **Freemium**: Premium features (advanced stats, AR)
> 2. **Partnership**: Hợp tác với các brand eco-friendly
> 3. **Ads**: Quảng cáo sản phẩm xanh
> 4. **B2B**: Bán license cho tổ chức, doanh nghiệp
> 5. **In-app purchases**: Mua thêm điểm"

#### **Q7: Gemini API có bị rate limit không?**

**Trả lời:**
> "Có, free tier Gemini có limit 15 requests/phút, 1500 requests/ngày. Em đã implement:
> 1. **Client-side throttling**: Giới hạn số request
> 2. **Error handling**: Retry với exponential backoff
> 3. **Caching**: Cache câu hỏi phổ biến
> 4. **Upgrade plan**: Nếu scale lên có thể nâng tier"

#### **Q8: Làm sao đảm bảo security cho Admin Panel?**

**Trả lời:**
> "Em áp dụng:
> 1. **Firebase Auth**: Authenticated requests only
> 2. **Firestore Rules**: Role-based access control
> 3. **HTTPS**: All traffic encrypted
> 4. **Environment variables**: API keys không hardcode
> 5. **Admin whitelist**: Chỉ email admin mới access được"

#### **Q9: App có hỗ trợ nhiều ngôn ngữ không?**

**Trả lời:**
> "Hiện tại chỉ Tiếng Việt. Nhưng em đã design code với internationalization (i18n) support sẵn bằng package `intl`. Chỉ cần thêm translation files là có thể support English và các ngôn ngữ khác."

#### **Q10: Có test với người dùng thực chưa?**

**Trả lời:**
> "Em đã test với ~[X] người dùng thực (bạn bè, gia đình). Feedback tích cực:
> 1. UI dễ dùng, trực quan
> 2. Scanner nhanh và chính xác
> 3. Gamification tạo động lực
> 
> Cải tiến dựa trên feedback:
> - Thêm dark mode
> - Cải thiện onboarding
> - Thêm mẹo tái chế"

#### **Q11: Có compare với các app tương tự trên thị trường không?**

**Trả lời:**
> "Em đã nghiên cứu:
> 1. **Recycle Coach**: Tốt nhưng không có AI scanner
> 2. **iRecycle**: Có DB lớn nhưng manual lookup
> 3. **Green Recycle**: Kết hợp AI + Gamification + Chatbot, phù hợp VN
> 
> Điểm khác biệt: Context Việt Nam, tiếng Việt, điểm thu gom VN."

#### **Q12: Model có thể mở rộng cho loại rác khác không?**

**Trả lời:**
> "Hoàn toàn có thể! Chỉ cần:
> 1. Thu thập thêm data cho classes mới
> 2. Retrain model với classes mở rộng
> 3. Update label.txt file
> 4. Replace .tflite file trong app
> 
> Architecture đã thiết kế flexible để scale."

#### **Q13: Có plan deploy lên App Store/Play Store không?**

**Trả lời:**
> "Có, sau khi hoàn thiện:
> 1. **Google Play Store**: Đăng ký developer account ($25 one-time)
> 2. **Apple App Store**: Cần Mac để build + $99/year
> 3. Chuẩn bị:
>    - Privacy policy
>    - Terms of service
>    - App screenshots
>    - Marketing materials"

#### **Q14: Performance trên low-end devices?**

**Trả lời:**
> "YOLOv11n đã được optimize:
> 1. Test trên Android 8.0+, RAM 2GB → OK
> 2. Inference time ~80-150ms tùy device
> 3. Có thể giảm resolution input nếu cần
> 4. TFLite GPU delegate cho devices mạnh hơn"

#### **Q15: Có concern gì về privacy không?**

**Trả lời:**
> "Em rất chú trọng privacy:
> 1. **On-device inference**: Ảnh không upload lên cloud
> 2. **Optional image save**: User chọn có lưu ảnh không
> 3. **Firebase Auth**: Secure authentication
> 4. **No tracking**: Không track location hoặc personal data
> 5. **GDPR compliant**: User có thể xóa account bất kỳ lúc nào"

---

## 11. CHECKLIST CHUẨN BỊ

### 📋 1 tuần trước

- [ ] Hoàn thiện slide thuyết trình
- [ ] Chuẩn bị script cho từng phần
- [ ] Kiểm tra app hoạt động ổn định
- [ ] Tạo tài khoản demo với data mẫu
- [ ] Chuẩn bị vật phẩm demo (chai nhựa, giấy, pin...)
- [ ] Record video demo dự phòng
- [ ] In quyển báo cáo (nếu cần)

### 📋 1 ngày trước

- [ ] Test lại toàn bộ flow demo
- [ ] Charge đầy pin laptop + điện thoại
- [ ] Cài đặt app version mới nhất
- [ ] Test kết nối Internet (4G + WiFi backup)
- [ ] Chuẩn bị adapter/converter/cables
- [ ] In handout (nếu cần)
- [ ] Luyện tập thuyết trình nhiều lần

### 📋 Ngày thuyết trình - Sáng

- [ ] Ăn sáng đầy đủ, nghỉ ngơi tốt
- [ ] Ăn mặc chỉnh chu, professional
- [ ] Mang theo laptop, điện thoại, charger, adapter
- [ ] Double-check slide, app, admin panel
- [ ] Đến sớm 15-20 phút
- [ ] Test projector, mic, Internet tại phòng
- [ ] Thư giãn, tự tin!

### 📋 Trong lúc thuyết trình

- [ ] Nói rõ ràng, tự tin, không quá nhanh
- [ ] Giao tiếp mắt với BGK
- [ ] Không đọc slide, giải thích thêm
- [ ] Demo mượt mà, không vội vàng
- [ ] Nếu có lỗi technical: bình tĩnh, dùng backup
- [ ] Trả lời câu hỏi ngắn gọn, đúng trọng tâm
- [ ] Cảm ơn BGK khi kết thúc

---

## 📚 PHỤ LỤC: TÀI LIỆU THAM KHẢO

### Các file quan trọng cần in/mang theo:

1. **README.md** - Tài liệu dự án đầy đủ
2. **Slide thuyết trình** - PDF backup
3. **Database schema** - Sơ đồ ERD
4. **Architecture diagram** - Sơ đồ kiến trúc
5. **Screenshots** - Ảnh chụp màn hình các tính năng

### Links hữu ích:

- [YOLOv11 Documentation](https://github.com/ultralytics/ultralytics)
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Gemini API Documentation](https://ai.google.dev/docs)

---

## 🎬 KẾT

**Chúc bạn thuyết trình thành công! 🌿✨**

> "Confidence comes from preparation. You've got this!"

**Tips cuối:**
- 😊 Mỉm cười, tự tin
- 🗣️ Nói rõ ràng, không vội
- 👀 Giao tiếp bằng mắt
- 🎯 Tập trung vào giá trị dự án mang lại
- 💚 Đam mê với đề tài sẽ thể hiện qua lời nói

**Good luck! 🍀**
