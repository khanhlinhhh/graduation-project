import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's notifications stream
  Stream<List<NotificationModel>> getNotificationsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
          .toList();
      
      // Sort in-memory by createdAt (newest first)
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return notifications;
    });
  }

  // Get unread count stream
  Stream<int> getUnreadCountStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Create a new notification
  Future<void> createNotification({
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'data': data,
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Delete all read notifications
  Future<void> deleteAllRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
