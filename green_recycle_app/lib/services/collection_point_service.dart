import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../screens/main/collection_points_screen.dart';

class CollectionPointService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'collection_points';

  // Get collection reference
  CollectionReference get _pointsRef => _firestore.collection(_collectionName);

  // Get real-time stream of collection points
  Stream<List<CollectionPoint>> getCollectionPointsStream() {
    return _pointsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        return CollectionPoint(
          id: doc.id,
          name: data['name'] ?? '',
          address: data['address'] ?? '',
          distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
          categories: List<String>.from(data['categories'] ?? []),
          openTime: data['openTime'] ?? '',
          phone: data['phone'] ?? '',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    });
  }
}
