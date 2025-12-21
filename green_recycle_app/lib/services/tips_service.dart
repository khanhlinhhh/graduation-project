import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/tip_model.dart';

class TipsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map category to color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Giấy':
        return const Color(0xFF4CAF50);
      case 'Nguy hại':
        return const Color(0xFFF44336);
      case 'Tái chế':
        return const Color(0xFF2196F3);
      case 'Hữu cơ':
        return const Color(0xFF8BC34A);
      case 'Điện tử':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  // Fetch all tips from Firebase
  Future<List<TipModel>> getAllTips() async {
    try {
      final snapshot = await _firestore
          .collection('tips')
          .orderBy('category')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TipModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['shortDescription'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Tái chế',
          categoryColor: _getCategoryColor(data['category'] ?? 'Tái chế'),
          steps: List<String>.from(data['steps'] ?? []),
          icon: data['icon'] ?? '♻️',
        );
      }).toList();
    } catch (e) {
      print('Error fetching tips: $e');
      return [];
    }
  }

  // Get tips by category
  Future<List<TipModel>> getTipsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('tips')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TipModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['shortDescription'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Tái chế',
          categoryColor: _getCategoryColor(data['category'] ?? 'Tái chế'),
          steps: List<String>.from(data['steps'] ?? []),
          icon: data['icon'] ?? '♻️',
        );
      }).toList();
    } catch (e) {
      print('Error fetching tips by category: $e');
      return [];
    }
  }

  // Stream tips for real-time updates
  Stream<List<TipModel>> getTipsStream() {
    return _firestore
        .collection('tips')
        .orderBy('category')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TipModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['shortDescription'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Tái chế',
          categoryColor: _getCategoryColor(data['category'] ?? 'Tái chế'),
          steps: List<String>.from(data['steps'] ?? []),
          icon: data['icon'] ?? '♻️',
        );
      }).toList();
    });
  }

  // Get featured tips (first 5) for home screen
  Future<List<TipModel>> getFeaturedTips() async {
    try {
      final snapshot = await _firestore
          .collection('tips')
          .limit(5)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TipModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['shortDescription'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Tái chế',
          categoryColor: _getCategoryColor(data['category'] ?? 'Tái chế'),
          steps: List<String>.from(data['steps'] ?? []),
          icon: data['icon'] ?? '♻️',
        );
      }).toList();
    } catch (e) {
      print('Error fetching featured tips: $e');
      return [];
    }
  }
}
