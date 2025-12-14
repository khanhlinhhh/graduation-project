import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardModel {
  final String id;
  final String name;
  final String description;
  final int points;
  final String emoji;
  final String colorHex;

  RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.emoji,
    required this.colorHex,
  });

  factory RewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      emoji: data['emoji'] ?? '🎁',
      colorHex: data['colorHex'] ?? '#4CAF50',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'points': points,
      'emoji': emoji,
      'colorHex': colorHex,
    };
  }
}

class RewardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream of user's green points
  Stream<int> getUserPointsStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(0);

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data();
        return data?['greenPoints'] ?? 0;
      }
      return 0;
    });
  }

  // Get user's green points (one-time)
  Future<int> getUserPoints() async {
    final uid = currentUserId;
    if (uid == null) return 0;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['greenPoints'] ?? 0;
    }
    return 0;
  }

  // Add points to user (called when scanning waste)
  Future<void> addPoints(int points) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).update({
      'greenPoints': FieldValue.increment(points),
    });
  }

  // Stream of rewards from Firestore
  Stream<List<RewardModel>> getRewardsStream() {
    return _firestore
        .collection('rewards')
        .orderBy('points')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RewardModel.fromFirestore(doc)).toList();
    });
  }

  // Get rewards (one-time)
  Future<List<RewardModel>> getRewards() async {
    final snapshot = await _firestore
        .collection('rewards')
        .orderBy('points')
        .get();
    return snapshot.docs.map((doc) => RewardModel.fromFirestore(doc)).toList();
  }

  // Initialize default rewards if collection is empty
  Future<void> initializeDefaultRewards() async {
    final snapshot = await _firestore.collection('rewards').limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already has rewards

    final defaultRewards = [
      RewardModel(
        id: 'but_bi',
        name: 'Bút bi tái chế',
        description: 'Bút bi làm từ nhựa tái chế, thân thiện môi trường',
        points: 100,
        emoji: '🖊️',
        colorHex: '#5C6BC0',
      ),
      RewardModel(
        id: 'vo_tai_che',
        name: 'Vở tái chế',
        description: 'Vở 96 trang làm từ giấy tái chế 100%',
        points: 200,
        emoji: '📓',
        colorHex: '#AB47BC',
      ),
      RewardModel(
        id: 'hat_giong',
        name: 'Hạt giống rau',
        description: 'Bộ hạt giống rau sạch: cải, xà lách, rau muống',
        points: 300,
        emoji: '🌱',
        colorHex: '#66BB6A',
      ),
      RewardModel(
        id: 'so_tay',
        name: 'Sổ tay tái chế',
        description: 'Sổ tay bìa cứng làm từ bìa carton tái chế',
        points: 400,
        emoji: '📔',
        colorHex: '#FFB74D',
      ),
      RewardModel(
        id: 'tui_rac',
        name: 'Túi rác phân hủy',
        description: 'Túi rác tự phân hủy sinh học, gói 50 túi',
        points: 500,
        emoji: '♻️',
        colorHex: '#26C6DA',
      ),
      RewardModel(
        id: 'cay_canh',
        name: 'Cây cảnh mini',
        description: 'Cây sen đá hoặc xương rồng mini trong chậu tái chế',
        points: 800,
        emoji: '🌵',
        colorHex: '#81C784',
      ),
    ];

    // Add all rewards to Firestore
    for (final reward in defaultRewards) {
      await _firestore.collection('rewards').doc(reward.id).set(reward.toMap());
    }
  }

  // Redeem a reward
  Future<bool> redeemReward(RewardModel reward) async {
    final uid = currentUserId;
    if (uid == null) return false;

    // Get current points
    final currentPoints = await getUserPoints();
    if (currentPoints < reward.points) {
      return false; // Not enough points
    }

    // Use transaction to ensure atomicity
    try {
      await _firestore.runTransaction((transaction) async {
        // Deduct points from user
        final userRef = _firestore.collection('users').doc(uid);
        transaction.update(userRef, {
          'greenPoints': FieldValue.increment(-reward.points),
        });

        // Add redemption record
        final redemptionRef = _firestore.collection('redemptions').doc();
        transaction.set(redemptionRef, {
          'userId': uid,
          'rewardId': reward.id,
          'rewardName': reward.name,
          'rewardEmoji': reward.emoji,
          'pointsUsed': reward.points,
          'redeemedAt': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error redeeming reward: $e');
      return false;
    }
  }

  // Get user's redemption history
  Stream<List<Map<String, dynamic>>> getRedemptionHistory() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('redemptions')
        .where('userId', isEqualTo: uid)
        .orderBy('redeemedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Ensure user has greenPoints field
  Future<void> ensureUserHasPoints() async {
    final uid = currentUserId;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && !data.containsKey('greenPoints')) {
        await _firestore.collection('users').doc(uid).update({
          'greenPoints': 1000, // Give new users 1000 starting points
        });
      }
    }
  }
}
