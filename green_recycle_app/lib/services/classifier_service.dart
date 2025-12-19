import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';

/// Service for waste classification using YOLOv11 TFLite model
class ClassifierService {
  static final ClassifierService _instance = ClassifierService._internal();
  factory ClassifierService() => _instance;
  ClassifierService._internal();

  final FlutterVision _vision = FlutterVision();
  bool _isModelLoaded = false;

  /// Check if model is loaded
  bool get isModelLoaded => _isModelLoaded;

  /// Load YOLOv11 model
  Future<void> loadModel() async {
    if (_isModelLoaded) return;
    
    try {
      await _vision.loadYoloModel(
        labels: 'assets/images/label.txt',
        modelPath: 'assets/images/best_float32.tflite',
        modelVersion: 'yolov11',
        quantization: false,
        numThreads: 4,  // Increased for better performance
        useGpu: true,   // Enable GPU for faster inference
      );
      _isModelLoaded = true;
      debugPrint('YOLOv11 model loaded successfully');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  /// Process camera frame for real-time detection
  Future<List<DetectionResult>> detectOnFrame(CameraImage cameraImage) async {
    if (!_isModelLoaded) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    try {
      final result = await _vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.5,       // Higher IOU to reduce duplicate boxes
        confThreshold: 0.25,     // Lower confidence to detect more objects
        classThreshold: 0.3,     // Lower class threshold for better detection
      );
      
      return result.map((item) => DetectionResult.fromYoloResult(item)).toList();
    } catch (e) {
      debugPrint('Error detecting on frame: $e');
      return [];
    }
  }

  /// Process static image for classification
  Future<List<DetectionResult>> detectOnImage(
    Uint8List imageBytes,
    int width,
    int height,
  ) async {
    if (!_isModelLoaded) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    try {
      final result = await _vision.yoloOnImage(
        bytesList: imageBytes,
        imageHeight: height,
        imageWidth: width,
        iouThreshold: 0.5,       // Higher IOU to reduce duplicate boxes
        confThreshold: 0.25,     // Lower confidence to detect more objects
        classThreshold: 0.3,     // Lower class threshold for better detection
      );
      
      return result.map((item) => DetectionResult.fromYoloResult(item)).toList();
    } catch (e) {
      debugPrint('Error detecting on image: $e');
      return [];
    }
  }

  /// Close model and release resources
  Future<void> closeModel() async {
    if (_isModelLoaded) {
      await _vision.closeYoloModel();
      _isModelLoaded = false;
      debugPrint('YOLOv11 model closed');
    }
  }
}

/// Detection result from YOLOv11 model
class DetectionResult {
  final String labelEn;       // English label from model
  final String label;         // Vietnamese label
  final double confidence;    // 0.0 - 1.0
  final Rect boundingBox;     // Bounding box coordinates
  final Color categoryColor;  // Color for display
  final String emoji;         // Category emoji
  final List<String> tips;    // Disposal tips in Vietnamese
  final int points;           // Points earned

  DetectionResult({
    required this.labelEn,
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.categoryColor,
    required this.emoji,
    required this.tips,
    required this.points,
  });

  /// Create from YOLO result map
  factory DetectionResult.fromYoloResult(Map<String, dynamic> result) {
    final tag = result['tag'] as String;
    final box = result['box'] as List<dynamic>;
    
    // box format: [x1:left, y1:top, x2:right, y2:bottom, confidence]
    final x1 = (box[0] as num).toDouble();
    final y1 = (box[1] as num).toDouble();
    final x2 = (box[2] as num).toDouble();
    final y2 = (box[3] as num).toDouble();
    final conf = (box[4] as num).toDouble();

    final categoryInfo = _getCategoryInfo(tag);

    return DetectionResult(
      labelEn: tag,
      label: categoryInfo['label'] as String,
      confidence: conf,
      boundingBox: Rect.fromLTRB(x1, y1, x2, y2),
      categoryColor: categoryInfo['color'] as Color,
      emoji: categoryInfo['emoji'] as String,
      tips: categoryInfo['tips'] as List<String>,
      points: categoryInfo['points'] as int,
    );
  }

  /// Get category information based on English label
  static Map<String, dynamic> _getCategoryInfo(String labelEn) {
    final lowerLabel = labelEn.toLowerCase().trim();
    
    if (lowerLabel.contains('inorganic')) {
      return {
        'label': 'Rác vô cơ',
        'color': Colors.grey.shade600,
        'emoji': '🗑️',
        'points': 5,
        'tips': [
          'Rửa sạch và làm khô trước khi bỏ',
          'Phân loại riêng kim loại, nhựa cứng, thủy tinh',
          'Bỏ vào thùng rác vô cơ (màu xám)',
          'Không đổ chung với rác hữu cơ',
        ],
      };
    } else if (lowerLabel.contains('organic')) {
      return {
        'label': 'Rác hữu cơ',
        'color': Colors.brown.shade600,
        'emoji': '🍂',
        'points': 5,
        'tips': [
          'Để riêng thức ăn thừa, vỏ trái cây',
          'Có thể ủ làm phân compost',
          'Bỏ vào thùng rác hữu cơ (màu xanh lá)',
          'Không để lẫn với túi nilon',
        ],
      };
    } else if (lowerLabel.contains('recyclable')) {
      return {
        'label': 'Rác tái chế',
        'color': const Color(0xFF4CAF50),
        'emoji': '♻️',
        'points': 10,
        'tips': [
          'Rửa sạch và làm khô',
          'Bóp dẹp chai nhựa, lon để tiết kiệm không gian',
          'Gỡ bỏ nhãn dán nếu có thể',
          'Bỏ vào thùng rác tái chế (màu xanh dương)',
        ],
      };
    } else if (lowerLabel.contains('hazardous')) {
      return {
        'label': 'Rác nguy hại',
        'color': Colors.red.shade600,
        'emoji': '☢️',
        'points': 15,
        'tips': [
          'KHÔNG bỏ chung với rác sinh hoạt',
          'Đựng trong hộp kín, dán nhãn cảnh báo',
          'Mang đến điểm thu gom rác nguy hại',
          'Bao gồm: pin, bóng đèn, hóa chất, thuốc hết hạn',
        ],
      };
    }

    // Default fallback
    return {
      'label': labelEn,
      'color': Colors.grey,
      'emoji': '❓',
      'points': 5,
      'tips': [
        'Phân loại cẩn thận trước khi bỏ',
        'Tham khảo hướng dẫn phân loại rác địa phương',
      ],
    };
  }
}
