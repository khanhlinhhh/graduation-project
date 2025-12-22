# Hướng dẫn Deploy Firebase Cloud Functions

Thư mục này chứa "Cloud Functions" giúp đồng bộ việc xóa người dùng: Khi bạn xóa user trong trang Admin (Firestore), function này sẽ tự động xóa tài khoản đăng nhập (Authentication) tương ứng.

## Yêu cầu trước khi bắt đầu
1.  **Cài đặt Node.js**: Máy tính cần có Node.js (phiên bản 18 trở lên).
2.  **Firebase CLI**: Đã cài đặt `firebase-tools` (`npm install -g firebase-tools`).
3.  **Gói cước Blaze**: Dự án Firebase của bạn phải được nâng cấp lên gói **Blaze (Pay as you go)** mới có thể chạy Cloud Functions.

## Các bước Deploy

### Bước 1: Đăng nhập Firebase
Mở terminal tại thư mục gốc dự án và chạy:
```bash
firebase login
```

### Bước 2: Chọn Project
```bash
firebase use green-app-95926
```

### Bước 3: Cài đặt thư viện
```bash
cd functions
npm install
```

### Bước 4: Deploy
```bash
cd ..
firebase deploy --only functions
```

Lưu ý: Nếu gặp lỗi "missing required API", hãy kiểm tra lại xem project đã lên gói Blaze chưa trong Firebase Console > Usage and billing.
