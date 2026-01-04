import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for waste pickup/dropoff request
class WasteRequest {
  final String id;
  final String userId;
  final String type; // 'pickup' or 'dropoff'
  final String wasteType; // 'recyclable'
  final String wasteTypeLabel; // Vietnamese label
  final double confidence;
  final int pointsAwarded;
  final String status; // 'pending', 'confirmed', 'rejected'

  // Location (for pickup requests)
  final String? address;
  final GeoPoint? coordinates;

  // Collection point (for dropoff requests)
  final String? collectionPointId;
  final String? collectionPointName;
  final DateTime? scheduledTime; // For dropoff requests

  // Admin confirmation
  final String? confirmedBy;
  final DateTime? confirmedAt;
  final String? rejectionReason;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  WasteRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.wasteType,
    required this.wasteTypeLabel,
    required this.confidence,
    required this.pointsAwarded,
    required this.status,
    this.address,
    this.coordinates,
    this.collectionPointId,
    this.collectionPointName,
    this.scheduledTime,
    this.confirmedBy,
    this.confirmedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  /// Create from Firestore document
  factory WasteRequest.fromMap(String id, Map<String, dynamic> map) {
    return WasteRequest(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'pickup',
      wasteType: map['wasteType'] ?? '',
      wasteTypeLabel: map['wasteTypeLabel'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      pointsAwarded: map['pointsAwarded'] ?? 0,
      status: map['status'] ?? 'pending',
      address: map['address'],
      coordinates: map['coordinates'] as GeoPoint?,
      collectionPointId: map['collectionPointId'],
      collectionPointName: map['collectionPointName'],
      scheduledTime: (map['scheduledTime'] as Timestamp?)?.toDate(),
      confirmedBy: map['confirmedBy'],
      confirmedAt: (map['confirmedAt'] as Timestamp?)?.toDate(),
      rejectionReason: map['rejectionReason'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'wasteType': wasteType,
      'wasteTypeLabel': wasteTypeLabel,
      'confidence': confidence,
      'pointsAwarded': pointsAwarded,
      'status': status,
      'address': address,
      'coordinates': coordinates,
      'collectionPointId': collectionPointId,
      'collectionPointName': collectionPointName,
      'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime!) : null,
      'confirmedBy': confirmedBy,
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'rejectionReason': rejectionReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'notes': notes,
    };
  }

  /// Check if request is pending
  bool get isPending => status == 'pending';

  /// Check if request is confirmed
  bool get isConfirmed => status == 'confirmed';

  /// Check if it's a pickup request
  bool get isPickup => type == 'pickup';

  /// Check if it's a dropoff request
  bool get isDropoff => type == 'dropoff';
}
