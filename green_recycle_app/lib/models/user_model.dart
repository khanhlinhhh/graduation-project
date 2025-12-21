import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final int greenPoints;
  final int scanCount;
  final int rewardCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // Check-in fields
  final DateTime? lastCheckInDate;
  final int checkInStreak;
  final int totalCheckIns;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.greenPoints = 0,
    this.scanCount = 0,
    this.rewardCount = 0,
    this.createdAt,
    this.updatedAt,
    this.lastCheckInDate,
    this.checkInStreak = 0,
    this.totalCheckIns = 0,
  });

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      avatarUrl: map['avatarUrl'],
      greenPoints: map['greenPoints'] ?? 0,
      scanCount: map['scanCount'] ?? 0,
      rewardCount: map['rewardCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      lastCheckInDate: (map['lastCheckInDate'] as Timestamp?)?.toDate(),
      checkInStreak: map['checkInStreak'] ?? 0,
      totalCheckIns: map['totalCheckIns'] ?? 0,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'greenPoints': greenPoints,
      'scanCount': scanCount,
      'rewardCount': rewardCount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastCheckInDate': lastCheckInDate != null ? Timestamp.fromDate(lastCheckInDate!) : null,
      'checkInStreak': checkInStreak,
      'totalCheckIns': totalCheckIns,
    };
  }

  // Create from Firestore DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? avatarUrl,
    int? greenPoints,
    int? scanCount,
    int? rewardCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastCheckInDate,
    int? checkInStreak,
    int? totalCheckIns,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      greenPoints: greenPoints ?? this.greenPoints,
      scanCount: scanCount ?? this.scanCount,
      rewardCount: rewardCount ?? this.rewardCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      checkInStreak: checkInStreak ?? this.checkInStreak,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, greenPoints: $greenPoints)';
  }
}
