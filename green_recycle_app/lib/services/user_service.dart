import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw 'Không thể tải thông tin người dùng: ${e.toString()}';
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    // Try to get from Firestore
    UserModel? userData = await getUserData(user.uid);
    
    // If not in Firestore, create document from Firebase Auth data
    if (userData == null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? 'Người dùng',
        'avatarUrl': user.photoURL,
        'greenPoints': 0,
        'scanCount': 0,
        'rewardCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Fetch the newly created document
      userData = await getUserData(user.uid);
    }
    
    return userData;
  }

  // Stream user data for realtime updates
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    });
  }

  // Stream current user data
  Stream<UserModel?> getCurrentUserStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);
    return getUserStream(uid);
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        data['displayName'] = displayName;
        // Also update Firebase Auth display name
        await _auth.currentUser?.updateDisplayName(displayName);
      }

      if (avatarUrl != null) {
        data['avatarUrl'] = avatarUrl;
        // Also update Firebase Auth photo URL
        await _auth.currentUser?.updatePhotoURL(avatarUrl);
      }

      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw 'Không thể cập nhật thông tin: ${e.toString()}';
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw 'Không tìm thấy người dùng';
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw 'Mật khẩu hiện tại không đúng';
        case 'weak-password':
          throw 'Mật khẩu mới quá yếu';
        case 'requires-recent-login':
          throw 'Vui lòng đăng nhập lại để thay đổi mật khẩu';
        default:
          throw 'Lỗi: ${e.message}';
      }
    } catch (e) {
      throw 'Không thể đổi mật khẩu: ${e.toString()}';
    }
  }

  // Update green points
  Future<void> updateGreenPoints(String uid, int points) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'greenPoints': FieldValue.increment(points),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Không thể cập nhật điểm: ${e.toString()}';
    }
  }

  // Increment scan count
  Future<void> incrementScanCount(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'scanCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Không thể cập nhật số lần quét: ${e.toString()}';
    }
  }
}
