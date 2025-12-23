# 🎤 SCRIPT DEMO THUYẾT TRÌNH ĐỒ ÁN TỐT NGHIỆP
## GREEN RECYCLE - HỆ THỐNG PHÂN LOẠI RÁC THÔNG MINH

---

> **Thời gian:** 40 phút (Thuyết trình: 35 phút | Hỏi đáp: 5 phút)  
> **Người trình bày:** Nguyễn Khánh Linh  
> **Giảng viên hướng dẫn:** [Tên GV]

---

## 📑 PHẦN 1: GIỚI THIỆU (5 phút)

### 🎬 Chào mời và Giới thiệu bản thân

**[Đứng thẳng, mỉm cười, nhìn vào Ban giám khảo]**

> "Kính chào quý thầy cô và các bạn!
> 
> Em là **Nguyễn Khánh Linh**, sinh viên lớp **21IT**, Khoa Công nghệ Thông tin.
> 
> Hôm nay, em xin được trình bày đồ án tốt nghiệp với đề tài: **'Hệ thống Phân loại Rác Thông minh sử dụng AI và Deep Learning - Green Recycle'**."

**[Pause 2 giây]**

### 📊 Vấn đề nghiên cứu

**[Chuyển sang slide "Vấn đề"]**

> "Trước khi đi vào chi tiết dự án, em xin được trình bày về vấn đề mà em muốn giải quyết.
> 
> Theo thống kê, **Việt Nam thải ra khoảng 27.8 triệu tấn rác mỗi năm**. Tuy nhiên, **chỉ có khoảng 10% được tái chế đúng cách**.
> 
> Nguyên nhân chính là:
> - Người dân chưa có **thói quen phân loại rác** tại nguồn
> - Thiếu **kiến thức** về cách phân loại chính xác
> - Không có **công cụ hỗ trợ** hiệu quả
> - Thiếu **động lực** để duy trì hành vi tốt này
> 
> Đây là một vấn đề **cấp thiết** cần có giải pháp công nghệ phù hợp."

**[Pause 2 giây, chuyển slide]**

### 🎯 Giải pháp đề xuất

> "Chính vì vậy, em đã phát triển **Green Recycle** - một hệ sinh thái hoàn chỉnh bao gồm **3 thành phần chính**:"

**[Point vào slide]**

> "**Thứ nhất**, ứng dụng Mobile trên Flutter - dành cho người dùng cuối.
> 
> **Thứ hai**, Admin Panel trên React - dành cho quản trị viên.
> 
> **Thứ ba**, Backend Services trên Firebase - xử lý toàn bộ logic và lưu trữ dữ liệu.
> 
> Điểm đặc biệt của dự án là sử dụng **2 công nghệ AI tiên tiến**:
> - **YOLOv11** để phân loại rác tự động qua camera
> - **Gemini AI** để tư vấn cho người dùng bằng tiếng Việt"

**[Pause, chuyển slide]**

---

## 📐 PHẦN 2: KIẾN TRÚC VÀ CÔNG NGHỆ (7 phút)

### 🏗️ Kiến trúc hệ thống

**[Chuyển sang slide kiến trúc]**

> "Về kiến trúc tổng quan, hệ thống được thiết kế theo mô hình **3 tầng**:
> 
> **Tầng 1 - Presentation Layer:** Mobile App được xây dựng bằng Flutter, chạy trên cả Android và iOS.
> 
> **Tầng 2 - Backend Layer:** Firebase cung cấp đầy đủ các dịch vụ: Authentication cho đăng nhập, Cloud Firestore cho database, Storage cho lưu ảnh, và Cloud Functions cho logic phía server.
> 
> **Tầng 3 - Admin Layer:** Web-based Admin Panel xây dựng bằng React và Vite để quản trị toàn bộ hệ thống.
> 
> Các tầng này giao tiếp với nhau qua **REST API** và **Real-time sync** của Firebase."

**[Chuyển slide]**

### 🤖 Công nghệ AI - YOLOv11

**[Giọng nhiệt tình hơn]**

> "Bây giờ em xin giải thích về công nghệ **AI cốt lõi** của dự án.
> 
> Em sử dụng **YOLOv11n** - phiên bản **Nano** được tối ưu hóa cho thiết bị di động. Đây là phiên bản mới nhất của dòng YOLO, ra mắt năm 2024.
> 
> **Tại sao chọn YOLOv11?**
> - Kích thước model chỉ **6MB** sau khi convert sang TensorFlow Lite
> - Thời gian inference **60-80 milliseconds** - đủ nhanh cho real-time
> - Độ chính xác **trên 90%** trên test set
> - Hỗ trợ **on-device inference** - không cần internet
> 
> Model được train để nhận diện **4 loại rác** phổ biến tại Việt Nam:
> - **Organic waste** - rác hữu cơ như thực phẩm, lá cây
> - **Inorganic waste** - rác vô cơ như đồ gốm, đất đá  
> - **Recyclable waste** - rác tái chế được như nhựa, giấy, kim loại
> - **Hazardous waste** - rác nguy hại như pin, hóa chất"

**[Point vào slide chi tiết]**

> "Em đã convert model sang **TensorFlow Lite** để tối ưu cho mobile. Quá trình này giảm kích thước xuống **83%** so với model gốc nhưng vẫn giữ được accuracy."

**[Chuyển slide]**

### 💬 Công nghệ AI - Gemini Chatbot

> "Thành phần AI thứ hai là **Gemini 1.5 Flash** - chatbot thông minh của Google.
> 
> Em đã cấu hình chatbot với **system prompt** chuyên biệt về quản lý rác tại Việt Nam, giúp bot:
> - Trả lời **hoàn toàn bằng tiếng Việt** tự nhiên
> - Tư vấn cách phân loại từng loại rác cụ thể
> - Hướng dẫn cách tái chế, xử lý rác đúng cách
> - Cung cấp thông tin về môi trường
> 
> Chatbot có khả năng **multi-turn conversation** - hiểu ngữ cảnh của cuộc hội thoại."

**[Chuyển slide]**

### 💻 Tech Stack tổng quan

**[Nói nhanh, chỉ highlight]**

> "Về công nghệ sử dụng:
> 
> **Mobile App:** Flutter 3.10.3 với 19 packages, bao gồm Provider cho state management, Firebase suite, flutter_vision cho YOLOv11, và các thư viện UI.
> 
> **Admin Panel:** React 19, Vite build tool, TailwindCSS, Recharts cho analytics, và Cloudinary cho image CDN.
> 
> **Backend:** Hoàn toàn trên Firebase - Authentication, Firestore với 8 collections, Storage, và Cloud Functions viết bằng Node.js."

**[Chuyển slide]**

### 📊 Database Schema

> "Database được thiết kế với **8 collections** chính trong Firestore:
> 
> - **users** - thông tin người dùng, điểm xanh
> - **classification_history** - lịch sử quét rác kèm ảnh
> - **rewards** - danh sách phần thưởng
> - **redemptions** - lịch sử đổi quà
> - **check_ins** - check-in hàng ngày và streak
> - **notifications** - thông báo in-app
> - **collection_points** - bản đồ điểm thu gom
> - **tips** - mẹo tái chế
> 
> Tất cả collections đều có **real-time sync** - cập nhật tức thời khi có thay đổi."

**[Pause, chuyển phần demo]**

---

## 🎬 PHẦN 3: DEMO ỨNG DỤNG MOBILE (15 phút)

**[Cầm điện thoại lên, kết nối với projector]**

> "Bây giờ là phần **quan trọng nhất** - em xin demo trực tiếp các tính năng của ứng dụng."

---

### 📱 DEMO 1: Onboarding & Đăng nhập (1 phút)

**[Mở app]**

> "Khi người dùng mở app lần đầu tiên..."

**[Swipe qua màn hình 1]**

> "Họ sẽ thấy màn hình giới thiệu về tính năng **phân loại rác bằng AI**."

**[Swipe màn hình 2]**

> "Màn hình thứ hai giới thiệu **hệ thống điểm thưởng và check-in** hàng ngày."

**[Swipe màn hình 3]**

> "Và màn hình cuối về **chatbot tư vấn** cùng **bản đồ điểm thu gom**."

**[Nhấn "Bắt đầu"]**

> "Người dùng chọn 'Bắt đầu' để vào ứng dụng."

**[Nhấn "Đăng nhập với Google"]**

> "Hệ thống hỗ trợ đăng nhập nhanh chóng bằng **Google Sign-In**. Firebase Authentication sẽ xử lý toàn bộ quy trình bảo mật."

**[Chọn tài khoản, chờ đăng nhập]**

> "Và đây là màn hình chính sau khi đăng nhập thành công."

---

### 🏠 DEMO 2: Home Screen (30 giây)

**[Point vào màn hình]**

> "Trang chủ hiển thị các thông tin quan trọng:
> - **125 điểm xanh** - điểm tích lũy của người dùng
> - **Chuỗi check-in 5 ngày** liên tục
> - Phần **mẹo tái chế** với hơn 30 tips hữu ích"

**[Scroll xuống, nhấn vào 1 tip]**

> "Ví dụ tip 'Tái chế chai nhựa', có **5 bước** hướng dẫn chi tiết kèm hình ảnh. Người dùng có thể áp dụng ngay."

**[Đóng lại]**

---

### 📸 DEMO 3: Camera Scanner - TÍNH NĂNG CHÍNH (3 phút)

**[Giọng điệu tự tin, chậm rãi]**

> "Bây giờ là tính năng **cốt lõi** của ứng dụng - phân loại rác bằng AI."

**[Nhấn icon Camera ở bottom nav]**

> "Người dùng mở camera..."

**[Chờ model load - 3-5 giây]**

> "YOLOv11 model đang khởi động. Model được load vào memory một lần duy nhất để tối ưu tốc độ."

**[Cầm chai nhựa lên]**

> "Em sẽ demo với một chai nhựa."

**[Hướng camera vào chai nhựa, pause 2-3 giây]**

> "Camera đang quét **real-time**. Quý thầy cô có thể thấy model đang xử lý từng frame."

**[Nhấn nút "Chụp ảnh phân loại"]**

> "Khi người dùng bấm chụp..."

**[Chờ kết quả 2-3 giây]**

> "Model inference chỉ mất khoảng **70 milliseconds**."

**[Kết quả hiện ra]**

> "**Kết quả**:
> - Loại rác: **Recyclable waste** - rác tái chế được
> - Độ tin cậy: **95.2%** - rất cao
> - Hướng dẫn xử lý: Rửa sạch chai, bỏ vào thùng rác xanh
> - Người dùng nhận được **+5 điểm**"

**[Point vào từng phần trên màn hình]**

**[Giải thích kỹ - QUAN TRỌNG]**

> "Công nghệ em sử dụng là **YOLOv11n** - phiên bản nano được tối ưu cho mobile. Model có kích thước chỉ **6MB** nhưng đạt độ chính xác trên **90%**.
> 
> Điểm đặc biệt là model chạy **trực tiếp trên thiết bị** - không cần upload ảnh lên cloud, bảo vệ privacy và hoạt động được cả khi offline.
> 
> Thời gian inference chỉ **60-80ms** - đủ nhanh cho trải nghiệm real-time.
> 
> Model được train với dataset gồm 4 loại rác chính tại Việt Nam: **Organic, Inorganic, Recyclable, và Hazardous**."

**[Nhấn "Lưu lịch sử"]**

> "Kết quả được lưu vào **Cloud Firestore** kèm ảnh để người dùng có thể xem lại."

---

### 📜 DEMO 4: History & Statistics (1 phút)

**[Về Home, nhấn vào History]**

> "Người dùng có thể xem toàn bộ lịch sử phân loại..."

**[Scroll danh sách]**

> "Đây là **25 lần quét** trước đó, mỗi item hiển thị ảnh, loại rác, độ chính xác, và thời gian."

**[Nhấn vào item chai nhựa vừa quét]**

> "Xem chi tiết lần quét vừa rồi: ảnh chai nhựa, **Recyclable waste**, confidence **95.2%**, thời gian lưu."

**[Back, chuyển sang Statistics]**

> "Phần thống kê hiển thị biểu đồ tròn phân bổ:
> - **Recyclable 50%**
> - **Organic 30%** 
> - **Inorganic 15%**
> - **Hazardous 5%**
> 
> Giúp người dùng dễ dàng theo dõi thói quen phân loại rác của mình."

---

### 🎁 DEMO 5: Check-in & Rewards (2.5 phút)

**[Về Home]**

> "Để tạo động lực cho người dùng, em thiết kế **hệ thống gamification** với check-in hàng ngày."

**[Nhấn nút "Check-in hôm nay"]**

> "Người dùng nhấn vào nút check-in..."

**[Hiệu ứng confetti xuất hiện]**

> "Nhận **+10 điểm** với hiệu ứng vui mắt!"

**[Point vào điểm]**

> "Điểm xanh tăng từ **125** lên **135**."

**[Point vào streak]**

> "Chuỗi ngày check-in liên tục tăng từ **5** lên **6 ngày**. Hệ thống khuyến khích người dùng check-in đều đặn."

**[Chuyển sang tab Rewards]**

> "Bây giờ người dùng có thể dùng điểm để đổi quà."

**[Scroll danh sách rewards]**

> "**6 phần thưởng** thân thiện môi trường:
> - Bút bi tái chế - 40 điểm
> - Hạt giống rau sạch - 30 điểm
> - Vở tái chế - 350 điểm
> - Sổ tay tái chế - 400 điểm
> - **Túi rác phân hủy - 50 điểm**
> - Cây cảnh mini - 50 điểm"

**[Chọn Túi rác phân hủy]**

> "Người dùng đủ điểm để đổi 'Túi rác phân hủy'."

**[Nhấn "Đổi ngay"]**

> "Nhấn đổi quà..."

**[Dialog xác nhận]**

> "Hệ thống hỏi xác nhận: 'Bạn có chắc muốn dùng 50 điểm?'"

**[Nhấn "Xác nhận"]**

> "Xác nhận..."

**[Success message]**

> "**Đổi thành công!** Điểm giảm từ **135** xuống **85**."

**[Nhấn icon History trong Rewards]**

> "Người dùng có thể xem lịch sử đổi quà: 'Túi rác phân hủy - 50 điểm - 23/12/2025'."

**[Giải thích]**

> "Hệ thống gamification này khuyến khích hành vi tốt. Các phần thưởng đều là **sản phẩm eco-friendly**, phù hợp với mục tiêu bảo vệ môi trường."

---

### 🤖 DEMO 6: AI Chatbot (2 phút)

**[Nhấn vào tab Chatbot]**

> "Khi người dùng có thắc mắc về phân loại rác, họ có thể hỏi **chatbot AI**."

**[Hiển thị giao diện chat]**

> "Giao diện chat quen thuộc, dễ sử dụng."

**[Gõ câu hỏi: "Vỏ hộp sữa thuộc loại rác gì?"]**

> "Em sẽ hỏi một câu thực tế: 'Vỏ hộp sữa thuộc loại rác gì?'"

**[Nhấn Send, chờ 3-5 giây]**

> "Gemini đang xử lý câu hỏi..."

**[Reply xuất hiện bằng tiếng Việt]**

**[Đọc 1-2 câu đầu]**

> "Bot trả lời chi tiết bằng tiếng Việt: 
> 
> '*Vỏ hộp sữa Tetra Pak thuộc nhóm **rác tái chế được**. Tuy nhiên, bạn cần rửa sạch phần bên trong trước khi bỏ vào thùng rác xanh. Hộp Tetra Pak được làm từ nhiều lớp vật liệu...*'"

**[Gõ tiếp câu hỏi: "Làm sao tái chế pin cũ?"]**

> "Hỏi thêm: 'Làm sao tái chế pin cũ?'"

**[Nhận reply]**

> "Bot hướng dẫn: '*Pin cũ là rác nguy hại. Bạn không nên vứt chung với rác thường. Hãy mang đến các điểm thu gom pin chuyên dụng...*'"

**[Giải thích]**

> "Chatbot sử dụng **Gemini 1.5 Flash** của Google. Em đã cấu hình **system prompt** để bot tập trung vào context quản lý rác tại Việt Nam.
> 
> Bot có thể trả lời **mọi câu hỏi** về phân loại, tái chế, xử lý rác bằng **tiếng Việt tự nhiên**. Đây là trợ lý ảo 24/7 cho người dùng."

---

### 📍 DEMO 7: Collection Points & Profile (2 phút)

**[Nhấn vào "Điểm thu gom"]**

> "Ngoài ra, app còn cung cấp **bản đồ điểm thu gom rác tái chế**."

**[Hiển thị danh sách]**

> "Danh sách các điểm gần đây với đầy đủ thông tin."

**[Filter theo "Plastic"]**

> "Người dùng có thể lọc theo loại rác, ví dụ chỉ xem điểm thu gom **nhựa**."

**[Nhấn vào 1 điểm]**

> "Xem chi tiết: tên điểm, địa chỉ đầy đủ, category, số điện thoại."

**[Nhấn "Chỉ đường"]**

> "Nhấn 'Chỉ đường'..."

**[Google Maps mở ra]**

> "Tích hợp seamless với **Google Maps** để chỉ đường đến điểm thu gom."

**[Back về app, vào Profile]**

> "Về trang cá nhân."

**[Hiển thị info]**

> "Hiển thị avatar, tên, email, và điểm xanh hiện tại."

**[Nhấn "Chỉnh sửa hồ sơ"]**

> "Người dùng có thể chỉnh sửa hồ sơ..."

**[Nhấn vào avatar]**

> "Upload ảnh đại diện mới từ thư viện hoặc chụp ảnh."

**[Chọn ảnh từ gallery, crop]**

> "Cắt ảnh theo tỷ lệ vuông..."

**[Lưu - upload lên Firebase Storage]**

> "Upload lên **Firebase Storage**, URL ảnh được lưu vào Firestore."

**[Đổi display name, lưu]**

> "Cũng có thể đổi tên hiển thị."

**[Back, toggle Dark Mode]**

> "App hỗ trợ **Dark Mode** - chuyển đổi giao diện sang tối để bảo vệ mắt ban đêm."

**[Giao diện chuyển sang dark]**

> "Giao diện chuyển đổi mượt mà."

**[Nhấn vào "Thông báo" - có badge số 2]**

> "Có **2 thông báo** chưa đọc."

**[Xem danh sách thông báo]**

> "Thông báo về check-in thành công và đổi quà. Người dùng có thể đánh dấu đã đọc."

**[Đánh dấu đã đọc]**

> "Badge biến mất khi đã đọc hết."

**[Tổng kết mobile demo]**

> "Vậy là em đã demo xong **7 tính năng chính** của ứng dụng mobile:
> 1. Phân loại rác bằng AI
> 2. Lịch sử và thống kê
> 3. Check-in và đổi thưởng
> 4. Chatbot tư vấn
> 5. Điểm thu gom
> 6. Quản lý hồ sơ
> 7. Thông báo
> 
> Bây giờ chúng ta chuyển sang **Admin Panel**."

---

## 💻 PHẦN 4: DEMO ADMIN PANEL (5 phút)

**[Chuyển sang laptop, mở browser]**

> "Admin Panel được xây dựng bằng **React và Vite**, chạy trên web browser."

**[Mở http://localhost:5173]**

### 🔐 Đăng nhập Admin

**[Màn hình login hiện ra]**

> "Đăng nhập với tài khoản admin..."

**[Nhập email/password, đăng nhập]**

> "Firebase Authentication xác thực admin."

---

### 📊 Dashboard

**[Dashboard hiện ra]**

> "**Dashboard** cung cấp cái nhìn tổng quan:
> - **50 Users** đăng ký
> - **125 Check-ins** tổng cộng
> - **28 Redemptions** - lượt đổi quà
> 
> Biểu đồ phân tích xu hướng người dùng theo thời gian."

**[Point vào biểu đồ]**

---

### 👥 Users Management

**[Click vào Users]**

> "Quản lý người dùng."

**[Hiển thị bảng danh sách]**

> "Bảng hiển thị tất cả users với email, tên, điểm, số lần đổi quà."

**[Tìm kiếm một user]**

> "Admin có thể tìm kiếm..."

**[Click Edit]**

> "Chỉnh sửa display name... và lưu thay đổi. Cập nhật ngay lập tức lên Firestore."

---

### 🎁 Rewards Management

**[Click vào Rewards]**

> "Quản lý phần thưởng."

**[Nhấn "Add New Reward"]**

> "Thêm phần thưởng mới..."

**[Điền form]**

> "Điền thông tin:
> - Tên: **Cốc giữ nhiệt tái chế**
> - Mô tả: **Cốc inox thân thiện môi trường**
> - Điểm: **80**
> - Emoji: ☕"

**[Upload ảnh]**

> "Upload ảnh qua **Cloudinary** để tối ưu tốc độ tải."

**[Save]**

> "Lưu... phần thưởng mới xuất hiện ngay trong app."

---

### 💡 Tips & Collection Points (Nói nhanh)

> "Tương tự, admin có thể quản lý **Tips** - thêm mẹo tái chế mới với các bước chi tiết.
> 
> Và **Collection Points** - thêm, sửa, xóa điểm thu gom rác trên bản đồ."

---

### ✅ Check-ins Monitoring

**[Click vào Check-ins]**

> "Xem lịch sử check-in của tất cả users:
> - Email
> - Lần check-in cuối
> - Streak hiện tại
> - Tổng số lần check-in
> 
> Giúp admin theo dõi engagement của người dùng."

**[Tổng kết Admin Panel]**

> "Admin Panel cung cấp đầy đủ **CRUD operations** để quản lý toàn bộ hệ thống một cách trực quan và hiệu quả."

---

## 🎯 PHẦN 5: KẾT QUẢ ĐẠT ĐƯỢC (5 phút)

**[Chuyển về slide]**

### ✅ Tính năng đã hoàn thành

> "Sau **[X] tháng** phát triển, em đã hoàn thành:

**[Đọc checklist trên slide]**

> "**Mobile App:**
> - ✅ AI Scanner với YOLOv11 - real-time inference
> - ✅ 4 loại rác classification
> - ✅ Lịch sử quét với ảnh và statistics
> - ✅ Daily check-in system với streak
> - ✅ Rewards redemption
> - ✅ Gemini AI chatbot tiếng Việt
> - ✅ Bản đồ điểm thu gom
> - ✅ 30+ mẹo tái chế
> - ✅ Thông báo in-app
> - ✅ Profile management với avatar upload
> - ✅ Dark mode
> - ✅ Google Sign-In
> 
> **Admin Panel:**
> - ✅ Dashboard analytics
> - ✅ Users management
> - ✅ Rewards CRUD
> - ✅ Collection Points management
> - ✅ Tips management
> - ✅ Check-ins monitoring
> 
> **Backend:**
> - ✅ Firebase Authentication
> - ✅ Firestore database với 8 collections
> - ✅ Storage cho images
> - ✅ Cloud Functions
> - ✅ Real-time sync"

### 📊 Metrics & Performance

**[Chuyển slide metrics]**

> "Về hiệu năng:
> - **18 screens** trong mobile app
> - **10 services** xử lý business logic
> - Model size **6MB** TFLite
> - Inference time **dưới 100ms**
> - Accuracy **trên 90%** trên test set
> - **19 packages** được tổ chức tốt
> - Code theo pattern **MVC**"

### 🎯 Đánh giá ưu điểm

> "**Điểm mạnh của dự án:**
> 
> ✅ **Giải quyết vấn đề thực tế** - giúp người dân phân loại rác đúng cách
> 
> ✅ **Ứng dụng AI hiệu quả** - YOLOv11 chạy real-time trên mobile, Gemini tư vấn bằng tiếng Việt
> 
> ✅ **UX/UX thân thiện** - giao diện đẹp, dễ sử dụng, có Dark Mode
> 
> ✅ **Gamification tạo động lực** - check-in và rewards khuyến khích hành vi tốt
> 
> ✅ **Cross-platform** - một code chạy cả iOS và Android
> 
> ✅ **Offline-capable** - model AI chạy on-device, không cần internet
> 
> ✅ **Kiến trúc có thể mở rộng** - dễ thêm tính năng mới"

---

## ⚠️ PHẦN 6: HẠN CHẾ VÀ HƯỚNG PHÁT TRIỂN (3 phút)

### 🔴 Hạn chế hiện tại

**[Giọng khách quan, thành thật]**

> "Tuy nhiên, dự án vẫn còn một số **hạn chế** cần khắc phục:
> 
> **Về AI Model:**
> - Dataset còn hạn chế, cần mở rộng
> - Chưa detect được nhiều loại vật phẩm cụ thể
> - Đôi khi bị nhầm với background phức tạp
> 
> **Về tính năng:**
> - Chưa có push notification FCM
> - Chưa có social sharing
> - Chưa có leaderboard
> 
> **Khác:**
> - Chưa test kỹ trên iOS
> - Chưa hỗ trợ đa ngôn ngữ (chỉ tiếng Việt)"

### 🚀 Hướng phát triển

**[Giọng lạc quan, nhiệt tình]**

> "Tuy nhiên, em đã có **roadmap rõ ràng** để phát triển tiếp:
> 
> **Ngắn hạn (1-3 tháng):**
> - 📱 Push notifications với FCM
> - 🌍 Multi-language support thêm tiếng Anh
> - 🏆 Leaderboard và social features
> - 📊 Mở rộng dataset, train lại model
> 
> **Trung hạn (3-6 tháng):**
> - 🤖 Nâng cấp lên YOLOv11s - model lớn hơn, chính xác hơn
> - 🎥 Video classification support
> - 🗺️ AR chỉ điểm thu gom gần nhất
> - 💼 Enterprise version cho tổ chức
> 
> **Dài hạn (6-12 tháng):**
> - 🌐 Web version của app
> - 🏭 Tích hợp với nhà máy tái chế
> - 💰 Marketplace đổi điểm lấy tiền/voucher
> - 🤝 Hợp tác với chính quyền địa phương
> - 📱 IoT integration với smart bins"

---

## 🎓 PHẦN 7: KẾT LUẬN (2 phút)

**[Giọng kết luận, chậm rãi, rõ ràng]**

> "Tóm lại, **Green Recycle** là một hệ sinh thái hoàn chỉnh giúp:
> 
> ✅ **Nâng cao nhận thức cộng đồng** về phân loại rác thông qua giáo dục và công cụ hỗ trợ
> 
> ✅ **Ứng dụng AI/ML vào bài toán môi trường thực tế** - YOLOv11 và Gemini AI
> 
> ✅ **Tạo động lực bền vững** thông qua gamification và rewards
> 
> ✅ **Cung cấp công cụ dễ dùng và hiệu quả** cho người dân Việt Nam
> 
> Dự án không chỉ là một ứng dụng công nghệ, mà còn là **đóng góp xã hội** - giúp bảo vệ môi trường xanh - sạch - đẹp cho thế hệ tương lai."

**[Pause 2 giây]**

### 🙏 Lời cảm ơn

**[Giọng chân thành]**

> "Em xin chân thành cảm ơn:
> 
> - **Thầy/Cô [Tên GV]** đã tận tình hướng dẫn em trong suốt quá trình làm đồ án
> 
> - **Ban giám khảo** đã dành thời gian quý báu để đánh giá đồ án của em
> 
> - **Gia đình và bạn bè** đã luôn ủng hộ và động viên em
> 
> Em rất mong nhận được **góp ý** từ quý thầy cô để hoàn thiện hơn dự án này. Bây giờ em xin dừng phần trình bày và sẵn sàng trả lời câu hỏi từ ban giám khảo!"

**[Cúi chào]**

---

## ❓ PHẦN 8: HỎI ĐÁP (5 phút)

### Các câu trả lời chuẩn bị sẵn

#### Q1: Tại sao chọn YOLOv11 thay vì các model khác?

> "Em cảm ơn thầy/cô đã đặt câu hỏi. Em chọn YOLOv11n vì:
> 
> **Thứ nhất**, real-time performance - inference dưới 100ms trên mobile, đủ nhanh cho UX tốt.
> 
> **Thứ hai**, kích thước nhỏ chỉ 6MB sau khi optimize, phù hợp on-device.
> 
> **Thứ ba**, accuracy cao - đạt trên 90% trên test set, tốt hơn MobileNet và EfficientNet cho object detection.
> 
> **Thứ tư**, TFLite support tốt - dễ integrate với Flutter.
> 
> **Cuối cùng**, YOLOv11 là state-of-the-art, phiên bản mới nhất 2024."

#### Q2: Dataset từ đâu? Số lượng bao nhiêu?

> "Em sử dụng dataset kết hợp:
> 
> **Public datasets:** TACO, TrashNet từ Kaggle và GitHub.
> 
> **Tự thu thập:** em và nhóm bạn đã chụp thêm ảnh các loại rác phổ biến tại Việt Nam.
> 
> **Data augmentation:** áp dụng kỹ thuật xoay, flip, brightness để tăng diversity.
> 
> Tổng cộng khoảng **[X,000]** images cho 4 classes, split 70% train, 20% validation, 10% test."

#### Q3: Làm sao đảm bảo accuracy khi ánh sáng thay đổi?

> "Em có áp dụng:
> 
> **Data augmentation** với brightness/contrast variations trong quá trình train.
> 
> **Preprocessing** ảnh input trước khi inference để chuẩn hóa.
> 
> User có thể **chụp lại** nếu confidence thấp dưới 70%.
> 
> Có thể **bật flash** khi môi trường thiếu sáng."

#### Q4: Chi phí vận hành hệ thống?

> "Chi phí chủ yếu từ Firebase:
> 
> **Firestore:** Free tier 1GB, 50K reads/day - đủ cho MVP.
> 
> **Storage:** Free tier 5GB.
> 
> **Authentication:** Free unlimited.
> 
> **Gemini API:** Free tier 15 requests/minute, 1500/day.
> 
> Với quy mô nhỏ dưới 10K users, **hoàn toàn miễn phí**. Scale lên mới tốn ~$50-100/tháng."

#### Q5: Tại sao không dùng Cloud Vision API?

> "On-device có ưu điểm:
> 
> **Privacy:** Ảnh không upload lên cloud.
> 
> **Offline:** Không cần internet để classify.
> 
> **Latency:** Nhanh hơn - 60-80ms vs ~500ms.
> 
> **Cost:** Không tốn phí API calls.
> 
> Nhược điểm là accuracy có thể thấp hơn cloud model, nhưng đủ cho use case này."

---

## 📋 CHECKLIST NGÀY THUYẾT TRÌNH

### ✅ Trước 1 ngày

- [ ] Test lại toàn bộ app và admin panel
- [ ] Charge đầy pin laptop + điện thoại
- [ ] Chuẩn bị 3-4 vật phẩm demo (chai nhựa, giấy, pin)
- [ ] Tạo tài khoản demo với data đẹp
- [ ] Test kết nối Internet
- [ ] In slides backup (PDF)
- [ ] Luyện tập script 3-5 lần

### ✅ Buổi sáng thuyết trình

- [ ] Ăn sáng đủ, nghỉ ngơi tốt
- [ ] Ăn mặc chỉnh chu, professional
- [ ] Mang laptop, điện thoại, charger, adapter
- [ ] Đến sớm 15-20 phút
- [ ] Test projector, mic, Internet
- [ ] Thư giãn, TỰ TIN!

### ✅ Trong lúc thuyết trình

- [ ] Nói rõ ràng, tự tin, không quá nhanh
- [ ] Giao tiếp mắt với BGK
- [ ] Không đọc slide, giải thích thêm
- [ ] Demo mượt mà
- [ ] Nếu có lỗi: bình tĩnh, dùng backup
- [ ] Trả lời ngắn gọn, đúng trọng tâm

---

## 🌟 KEY MESSAGES

> **3 điểm cốt lõi cần nhấn mạnh:**

1. 🤖 **AI-Powered** - YOLOv11 real-time + Gemini chatbot tiếng Việt
2. 🎮 **Gamification** - Check-in và rewards tạo động lực bền vững  
3. 🌍 **Social Impact** - Giáo dục môi trường, bảo vệ tương lai

---

**CHÚC BẠN THUYẾT TRÌNH THÀNH CÔNG! 🍀✨**

> "Confidence comes from preparation. You've got this!"
