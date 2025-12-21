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
        
        // Handle distance calculation here if needed
        // For now, we use the stored distance (or calculate from lat/long relative to user)
        // This is a simplified version using data from Firestore directly
        
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

  // Seed default data if collection is empty (run once)
  Future<void> seedDefaultData() async {
    try {
      final snapshot = await _pointsRef.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        debugPrint('Collection points already seeded');
        return;
      }

      debugPrint('Seeding default collection points...');
      
      final defaultPoints = [
        {
          'name': 'Điểm thu gom Quận 1',
          'address': '123 Nguyễn Huệ, Quận 1, TP.HCM',
          'distance': 0.5,
          'categories': ['Nhựa', 'Giấy', 'Kim loại'],
          'openTime': '07:00 - 18:00',
          'phone': '0901234567',
          'rating': 4.5,
          'latitude': 10.7731,
          'longitude': 106.7030,
        },
        {
          'name': 'Trung tâm tái chế Xanh',
          'address': '456 Lê Lợi, Quận 3, TP.HCM',
          'distance': 1.2,
          'categories': ['Nhựa', 'Thủy tinh', 'Pin/Điện tử'],
          'openTime': '08:00 - 20:00',
          'phone': '0907654321',
          'rating': 4.8,
          'latitude': 10.7756,
          'longitude': 106.6922,
        },
        {
          'name': 'Điểm thu gom Eco Life',
          'address': '789 Võ Văn Tần, Quận 3, TP.HCM',
          'distance': 2.0,
          'categories': ['Giấy', 'Kim loại', 'Thủy tinh'],
          'openTime': '06:00 - 22:00',
          'phone': '0912345678',
          'rating': 4.2,
          'latitude': 10.7721,
          'longitude': 106.6856,
        },
        {
          'name': 'Siêu thị tái chế Go Green',
          'address': '321 Cách Mạng Tháng 8, Quận 10, TP.HCM',
          'distance': 3.5,
          'categories': ['Nhựa', 'Giấy', 'Kim loại', 'Thủy tinh'],
          'openTime': '07:00 - 21:00',
          'phone': '0923456789',
          'rating': 4.6,
          'latitude': 10.7725,
          'longitude': 106.6665,
        },
        {
          'name': 'Điểm thu gom Pin điện tử',
          'address': '555 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
          'distance': 4.2,
          'categories': ['Pin/Điện tử'],
          'openTime': '08:00 - 17:00',
          'phone': '0934567890',
          'rating': 4.4,
          'latitude': 10.8012,
          'longitude': 106.7109,
        },
      ];

      for (final point in defaultPoints) {
        await _pointsRef.add(point);
      }
      
      debugPrint('Seeding completed successfully');
    } catch (e) {
      debugPrint('Error seeding data: $e');
    }
  }
}
