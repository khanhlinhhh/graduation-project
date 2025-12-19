import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for classification history entry
class ClassificationHistory {
  final String? id;
  final String userId;
  final String labelEn;
  final String label;
  final double confidence;
  final int pointsEarned;
  final DateTime timestamp;
  final String? imageUrl;

  ClassificationHistory({
    this.id,
    required this.userId,
    required this.labelEn,
    required this.label,
    required this.confidence,
    required this.pointsEarned,
    required this.timestamp,
    this.imageUrl,
  });

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'labelEn': labelEn,
      'label': label,
      'confidence': confidence,
      'pointsEarned': pointsEarned,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
    };
  }

  /// Create from Firestore document
  factory ClassificationHistory.fromMap(Map<String, dynamic> map, String docId) {
    return ClassificationHistory(
      id: docId,
      userId: map['userId'] ?? '',
      labelEn: map['labelEn'] ?? '',
      label: map['label'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      pointsEarned: map['pointsEarned'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: map['imageUrl'],
    );
  }
}
