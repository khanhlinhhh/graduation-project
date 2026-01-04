import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/waste_request_model.dart';

/// Service for managing waste pickup/dropoff requests
class WasteRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection reference
  CollectionReference get _requestsCollection =>
      _firestore.collection('waste_requests');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Create a pickup request
  Future<String> createPickupRequest({
    required String wasteType,
    required String wasteTypeLabel,
    required double confidence,
    required int points,
    required String address,
    required GeoPoint coordinates,
    String? notes,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('Vui lòng đăng nhập để tạo yêu cầu');
    }

    try {
      final data = {
        'userId': userId,
        'type': 'pickup',
        'wasteType': wasteType,
        'wasteTypeLabel': wasteTypeLabel,
        'confidence': confidence,
        'pointsAwarded': points,
        'status': 'pending',
        'address': address,
        'coordinates': coordinates,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _requestsCollection.add(data);
      debugPrint('Pickup request created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating pickup request: $e');
      rethrow;
    }
  }

  /// Create a dropoff request
  Future<String> createDropoffRequest({
    required String wasteType,
    required String wasteTypeLabel,
    required double confidence,
    required int points,
    required String collectionPointId,
    required String collectionPointName,
    DateTime? scheduledTime,
    String? notes,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('Vui lòng đăng nhập để tạo yêu cầu');
    }

    try {
      final data = {
        'userId': userId,
        'type': 'dropoff',
        'wasteType': wasteType,
        'wasteTypeLabel': wasteTypeLabel,
        'confidence': confidence,
        'pointsAwarded': points,
        'status': 'pending',
        'collectionPointId': collectionPointId,
        'collectionPointName': collectionPointName,
        'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime) : null,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _requestsCollection.add(data);
      debugPrint('Dropoff request created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating dropoff request: $e');
      rethrow;
    }
  }

  /// Get user's waste requests stream
  Stream<List<WasteRequest>> getUserRequestsStream() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _requestsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => WasteRequest.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Get request by ID
  Future<WasteRequest?> getRequestById(String requestId) async {
    try {
      final doc = await _requestsCollection.doc(requestId).get();
      if (doc.exists) {
        return WasteRequest.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting request: $e');
      return null;
    }
  }
}
