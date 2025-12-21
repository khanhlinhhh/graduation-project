import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckInService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Points per streak day (simple escalating rewards)
  int getPointsForStreak(int streakDay) {
    if (streakDay <= 1) return 10;
    if (streakDay == 2) return 15;
    if (streakDay == 3) return 20;
    if (streakDay == 4) return 25;
    if (streakDay == 5) return 30;
    if (streakDay == 6) return 40;
    return 50; // Day 7+
  }

  // Check if user can check-in today
  Future<bool> canCheckInToday() async {
    final uid = currentUserId;
    if (uid == null) return false;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return true;

    final data = doc.data();
    final lastCheckIn = (data?['lastCheckInDate'] as Timestamp?)?.toDate();
    
    if (lastCheckIn == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckInDay = DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);

    return !today.isAtSameMomentAs(lastCheckInDay);
  }

  // Get current streak info
  Future<Map<String, dynamic>> getCheckInInfo() async {
    final uid = currentUserId;
    if (uid == null) {
      return {'streak': 0, 'canCheckIn': false, 'nextPoints': 10, 'totalCheckIns': 0};
    }

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      return {'streak': 0, 'canCheckIn': true, 'nextPoints': 10, 'totalCheckIns': 0};
    }

    final data = doc.data()!;
    final lastCheckIn = (data['lastCheckInDate'] as Timestamp?)?.toDate();
    int currentStreak = data['checkInStreak'] ?? 0;
    int totalCheckIns = data['totalCheckIns'] ?? 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    bool canCheckIn = true;
    
    if (lastCheckIn != null) {
      final lastCheckInDay = DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);
      final yesterday = today.subtract(const Duration(days: 1));
      
      // Already checked in today
      if (today.isAtSameMomentAs(lastCheckInDay)) {
        canCheckIn = false;
      }
      // Missed a day - streak resets
      else if (!yesterday.isAtSameMomentAs(lastCheckInDay) && !today.isAtSameMomentAs(lastCheckInDay)) {
        currentStreak = 0;
      }
    }

    final nextStreak = canCheckIn ? currentStreak + 1 : currentStreak;
    final nextPoints = getPointsForStreak(nextStreak);

    return {
      'streak': currentStreak,
      'canCheckIn': canCheckIn,
      'nextPoints': nextPoints,
      'totalCheckIns': totalCheckIns,
      'lastCheckIn': lastCheckIn,
    };
  }

  // Perform check-in
  Future<Map<String, dynamic>> performCheckIn() async {
    final uid = currentUserId;
    if (uid == null) {
      return {'success': false, 'message': 'Chưa đăng nhập'};
    }

    // Check if already checked in today
    final canCheck = await canCheckInToday();
    if (!canCheck) {
      return {'success': false, 'message': 'Bạn đã check-in hôm nay rồi!'};
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? {};
      
      final lastCheckIn = (data['lastCheckInDate'] as Timestamp?)?.toDate();
      int currentStreak = data['checkInStreak'] ?? 0;
      int totalCheckIns = data['totalCheckIns'] ?? 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Calculate new streak
      if (lastCheckIn != null) {
        final lastCheckInDay = DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        if (yesterday.isAtSameMomentAs(lastCheckInDay)) {
          // Consecutive day - increment streak
          currentStreak += 1;
        } else {
          // Missed days - reset streak
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      final pointsEarned = getPointsForStreak(currentStreak);

      // Update user document
      await _firestore.collection('users').doc(uid).update({
        'lastCheckInDate': Timestamp.fromDate(now),
        'checkInStreak': currentStreak,
        'totalCheckIns': totalCheckIns + 1,
        'greenPoints': FieldValue.increment(pointsEarned),
      });

      // Record check-in history
      await _firestore.collection('checkins').add({
        'userId': uid,
        'date': Timestamp.fromDate(today),
        'pointsEarned': pointsEarned,
        'streakDay': currentStreak,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'pointsEarned': pointsEarned,
        'newStreak': currentStreak,
        'message': 'Check-in thành công! +$pointsEarned điểm 🎉',
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }

  // Get check-in history for last 7 days
  Future<List<DateTime>> getLast7DaysCheckIns() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final snapshot = await _firestore
        .collection('checkins')
        .where('userId', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final timestamp = doc.data()['date'] as Timestamp;
      return timestamp.toDate();
    }).toList();
  }

  // Stream for real-time check-in info
  Stream<Map<String, dynamic>> getCheckInInfoStream() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.value({'streak': 0, 'canCheckIn': false, 'nextPoints': 10, 'totalCheckIns': 0});
    }

    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) {
        return {'streak': 0, 'canCheckIn': true, 'nextPoints': 10, 'totalCheckIns': 0};
      }

      final data = doc.data()!;
      final lastCheckIn = (data['lastCheckInDate'] as Timestamp?)?.toDate();
      int currentStreak = data['checkInStreak'] ?? 0;
      int totalCheckIns = data['totalCheckIns'] ?? 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      bool canCheckIn = true;
      
      if (lastCheckIn != null) {
        final lastCheckInDay = DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        if (today.isAtSameMomentAs(lastCheckInDay)) {
          canCheckIn = false;
        } else if (!yesterday.isAtSameMomentAs(lastCheckInDay)) {
          currentStreak = 0;
        }
      }

      final nextStreak = canCheckIn ? currentStreak + 1 : currentStreak;
      final nextPoints = getPointsForStreak(nextStreak);

      return {
        'streak': currentStreak,
        'canCheckIn': canCheckIn,
        'nextPoints': nextPoints,
        'totalCheckIns': totalCheckIns,
        'lastCheckIn': lastCheckIn,
      };
    });
  }
}
