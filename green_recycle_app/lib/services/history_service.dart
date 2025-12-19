import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/classification_history.dart';

/// Service for managing classification history in Firestore
class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection reference
  CollectionReference get _historyCollection =>
      _firestore.collection('classification_history');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Save a classification result to history
  Future<void> saveClassification({
    required String labelEn,
    required String label,
    required double confidence,
    required int pointsEarned,
    String? imageUrl,
  }) async {
    final userId = _currentUserId;
    
    if (userId == null) {
      debugPrint('HistoryService: Cannot save - user not logged in');
      throw Exception('Vui lòng đăng nhập để lưu kết quả');
    }

    try {
      debugPrint('HistoryService: Saving classification for user: $userId');
      debugPrint('HistoryService: Label: $label, Confidence: $confidence');
      
      final data = {
        'userId': userId,
        'labelEn': labelEn,
        'label': label,
        'confidence': confidence,
        'pointsEarned': pointsEarned,
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      };

      await _historyCollection.add(data);
      debugPrint('HistoryService: Classification saved successfully');
    } catch (e) {
      debugPrint('HistoryService: Error saving classification: $e');
      rethrow;
    }
  }

  /// Get user's classification history
  Future<List<ClassificationHistory>> getUserHistory({int limit = 50}) async {
    final userId = _currentUserId;
    if (userId == null) return [];

    try {
      // Get all user's history (without orderBy to avoid index requirement)
      final snapshot = await _historyCollection
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      final items = snapshot.docs
          .map((doc) => ClassificationHistory.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
      
      // Sort client-side by timestamp (newest first)
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return items;
    } catch (e) {
      debugPrint('HistoryService: Error getting history: $e');
      return [];
    }
  }

  /// Get history stream for real-time updates
  Stream<List<ClassificationHistory>> getUserHistoryStream({int limit = 50}) {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _historyCollection
        .where('userId', isEqualTo: userId)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs
              .map((doc) => ClassificationHistory.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ))
              .toList();
          
          // Sort client-side by timestamp (newest first)
          items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          
          return items;
        });
  }

  /// Get classification statistics
  Future<Map<String, int>> getClassificationStats() async {
    final history = await getUserHistory(limit: 1000);
    
    final stats = <String, int>{};
    for (final item in history) {
      stats[item.label] = (stats[item.label] ?? 0) + 1;
    }
    
    return stats;
  }

  /// Get total points from classifications
  Future<int> getTotalPoints() async {
    final history = await getUserHistory(limit: 1000);
    return history.fold<int>(0, (sum, item) => sum + item.pointsEarned);
  }
}
