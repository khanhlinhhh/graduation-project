import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _languageKey = 'language';

  bool _isDarkMode = false;
  String _language = 'vi'; // 'vi' or 'en'

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get isVietnamese => _language == 'vi';

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _language = prefs.getString(_languageKey) ?? 'vi';
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _language);
    notifyListeners();
  }

  // Translations
  String tr(String key) {
    return _translations[_language]?[key] ?? _translations['vi']![key] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'vi': {
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt ứng dụng',
      'personalInfo': 'Thông tin cá nhân',
      'notifications': 'Thông báo',
      'language': 'Ngôn ngữ',
      'darkMode': 'Giao diện tối',
      'helpSupport': 'Trợ giúp & Hỗ trợ',
      'logout': 'Đăng xuất',
      'greenPoints': 'Điểm xanh',
      'scanCount': 'Lần quét',
      'save': 'Lưu thay đổi',
      'cancel': 'Hủy',
      'changePassword': 'Đổi mật khẩu',
      'currentPassword': 'Mật khẩu hiện tại',
      'newPassword': 'Mật khẩu mới',
      'confirmPassword': 'Xác nhận mật khẩu mới',
      'fullName': 'Họ và tên',
      'email': 'Email',
      'avatarUrl': 'URL ảnh đại diện',
      'basicInfo': 'Thông tin cơ bản',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'selectLanguage': 'Chọn ngôn ngữ',
      'home': 'Trang chủ',
      'scan': 'Quét',
      'history': 'Lịch sử',
      'collectionPoints': 'Điểm thu gom',
    },
    'en': {
      'profile': 'Profile',
      'settings': 'App Settings',
      'personalInfo': 'Personal Information',
      'notifications': 'Notifications',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'helpSupport': 'Help & Support',
      'logout': 'Log out',
      'greenPoints': 'Green Points',
      'scanCount': 'Scans',
      'save': 'Save Changes',
      'cancel': 'Cancel',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm New Password',
      'fullName': 'Full Name',
      'email': 'Email',
      'avatarUrl': 'Avatar URL',
      'basicInfo': 'Basic Information',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'selectLanguage': 'Select Language',
      'home': 'Home',
      'scan': 'Scan',
      'history': 'History',
      'collectionPoints': 'Collection Points',
    },
  };
}
