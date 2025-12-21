import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../../app_theme.dart';
import '../../services/classifier_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isModelLoading = true;
  bool _isProcessing = false;
  bool _isScanning = false;
  String? _errorMessage;
  
  final ClassifierService _classifierService = ClassifierService();
  List<DetectionResult> _detections = [];
  Timer? _detectionTimer;
  int _currentCameraIndex = 0;
  
  // Scan frame configuration - larger frame for better detection
  static const double scanFrameSize = 320;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    await _loadModel();
    await _initializeCamera();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        _isModelLoading = true;
        _errorMessage = null;
      });
      
      await _classifierService.loadModel();
      
      if (mounted) {
        setState(() => _isModelLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isModelLoading = false;
          _errorMessage = 'Không thể tải mô hình: $e';
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _errorMessage = 'Không tìm thấy camera');
        return;
      }

      await _setupCamera(_cameras![_currentCameraIndex]);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Lỗi khởi tạo camera: $e');
      }
    }
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _errorMessage = null;
        });
        
        // Start real-time detection
        _startRealtimeDetection();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Lỗi camera: $e');
      }
    }
  }

  void _startRealtimeDetection() {
    _detectionTimer?.cancel();
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _processFrame();
    });
  }

  Future<void> _processFrame() async {
    if (!_isCameraInitialized || 
        _isProcessing || 
        _isScanning ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_classifierService.isModelLoaded) {
      return;
    }

    _isProcessing = true;

    try {
      // Start image stream for single frame
      await _cameraController!.startImageStream((CameraImage image) async {
        await _cameraController!.stopImageStream();
        
        final detections = await _classifierService.detectOnFrame(image);
        
        // Filter detections to only show those within scan frame
        final filteredDetections = _filterDetectionsInFrame(detections);
        
        if (mounted) {
          setState(() => _detections = filteredDetections);
        }
        
        _isProcessing = false;
      });
    } catch (e) {
      _isProcessing = false;
      debugPrint('Frame processing error: $e');
    }
  }

  Future<void> _captureAndClassify() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    // Nếu đã có detection từ real-time, sử dụng kết quả đó luôn
    if (_detections.isNotEmpty) {
      Navigator.pushNamed(
        context, 
        '/result',
        arguments: _detections,
      );
      return;
    }

    // Nếu chưa có detection, chụp ảnh và phân loại
    setState(() => _isScanning = true);
    _detectionTimer?.cancel();

    try {
      // Take a picture for better quality detection
      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);
      final bytes = await imageFile.readAsBytes();
      
      // Decode image to get dimensions
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;
      
      // Run detection on captured image
      final detections = await _classifierService.detectOnImage(bytes, width, height);

      if (mounted) {
        if (detections.isNotEmpty) {
          Navigator.pushNamed(
            context, 
            '/result',
            arguments: detections,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không phát hiện rác trong ảnh. Đưa rác vào khung và thử lại!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
        _startRealtimeDetection();
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    setState(() => _isScanning = true);
    _detectionTimer?.cancel();

    try {
      final File imageFile = File(image.path);
      final bytes = await imageFile.readAsBytes();
      
      // Decode image to get dimensions
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;
      
      final detections = await _classifierService.detectOnImage(bytes, width, height);

      if (mounted) {
        if (detections.isNotEmpty) {
          Navigator.pushNamed(
            context, 
            '/result',
            arguments: detections, // Pass all detections
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không phát hiện rác trong ảnh. Thử ảnh khác!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
        _startRealtimeDetection();
      }
    }
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    
    _detectionTimer?.cancel();
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _setupCamera(_cameras![_currentCameraIndex]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _detectionTimer?.cancel();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _detectionTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or placeholder
          _buildCameraPreview(),

          // Detection boxes overlay
          if (_isCameraInitialized && _detections.isNotEmpty)
            _buildDetectionOverlay(),

          // Scanning frame overlay
          _buildScanningFrame(),

          // Top bar
          _buildTopBar(),

          // Bottom controls
          _buildBottomControls(),

          // Loading overlay
          if (_isModelLoading)
            _buildLoadingOverlay('Đang tải mô hình AI...'),

          // Error overlay
          if (_errorMessage != null)
            _buildErrorOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade800,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CameraPreview(_cameraController!),
    );
  }

  Widget _buildDetectionOverlay() {
    return CustomPaint(
      painter: DetectionPainter(
        detections: _detections,
        previewSize: _cameraController!.value.previewSize!,
        screenSize: MediaQuery.of(context).size,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildScanningFrame() {
    return Center(
      child: Container(
        width: scanFrameSize,
        height: scanFrameSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: _detections.isNotEmpty 
                ? AppTheme.primaryColor 
                : Colors.white.withOpacity(0.5),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Corner decorations
            Positioned(top: 0, left: 0, child: _buildCorner(0)),
            Positioned(top: 0, right: 0, child: _buildCorner(1)),
            Positioned(bottom: 0, left: 0, child: _buildCorner(2)),
            Positioned(bottom: 0, right: 0, child: _buildCorner(3)),
            
            // Hint text
            if (_detections.isEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Đưa rác vào khung',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// Filter detections to only include those within or overlapping the scan frame
  List<DetectionResult> _filterDetectionsInFrame(List<DetectionResult> detections) {
    if (detections.isEmpty || _cameraController == null) return detections;
    
    final screenSize = MediaQuery.of(context).size;
    final previewSize = _cameraController!.value.previewSize;
    if (previewSize == null) return detections;
    
    // Calculate scan frame bounds in screen coordinates
    final frameLeft = (screenSize.width - scanFrameSize) / 2;
    final frameTop = (screenSize.height - scanFrameSize) / 2;
    final frameRight = frameLeft + scanFrameSize;
    final frameBottom = frameTop + scanFrameSize;
    
    // Scale factors for converting detection coordinates to screen coordinates
    final scaleX = screenSize.width / previewSize.height; // Rotated
    final scaleY = screenSize.height / previewSize.width;
    
    return detections.where((detection) {
      // Convert detection bounding box to screen coordinates
      final box = detection.boundingBox;
      final screenLeft = box.left * scaleX;
      final screenTop = box.top * scaleY;
      final screenRight = box.right * scaleX;
      final screenBottom = box.bottom * scaleY;
      
      // Calculate center of detection
      final centerX = (screenLeft + screenRight) / 2;
      final centerY = (screenTop + screenBottom) / 2;
      
      // Check if center is within scan frame (with some margin)
      final margin = 50.0; // Allow some margin outside frame
      return centerX >= frameLeft - margin && 
             centerX <= frameRight + margin &&
             centerY >= frameTop - margin && 
             centerY <= frameBottom + margin;
    }).toList();
  }

  Widget _buildCorner(int position) {
    final color = _detections.isNotEmpty 
        ? AppTheme.primaryColor 
        : Colors.white;
    
    final BorderRadius borderRadius;
    switch (position) {
      case 0:
        borderRadius = const BorderRadius.only(topLeft: Radius.circular(24));
        break;
      case 1:
        borderRadius = const BorderRadius.only(topRight: Radius.circular(24));
        break;
      case 2:
        borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(24));
        break;
      case 3:
        borderRadius = const BorderRadius.only(bottomRight: Radius.circular(24));
        break;
      default:
        borderRadius = BorderRadius.zero;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: position < 2
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          bottom: position >= 2
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          left: position % 2 == 0
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          right: position % 2 == 1
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
        ),
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            if (_detections.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      _detections.first.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _detections.first.label,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đang quét...',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              onPressed: _switchCamera,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flip_camera_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              _isScanning
                  ? 'Đang phân tích...'
                  : _detections.isNotEmpty
                      ? 'Nhấn để phân loại: ${_detections.first.label}'
                      : 'Đưa rác vào khung hình để quét',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: _isScanning ? null : _pickFromGallery,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Capture button
                GestureDetector(
                  onTap: _isScanning ? null : _captureAndClassify,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isScanning
                          ? AppTheme.primaryColor.withOpacity(0.5)
                          : _detections.isNotEmpty
                              ? AppTheme.primaryColor
                              : Colors.white,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: _isScanning
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Icon(
                            _detections.isNotEmpty 
                                ? Icons.check 
                                : Icons.camera_alt,
                            size: 36,
                            color: _detections.isNotEmpty 
                                ? Colors.white 
                                : AppTheme.primaryColor,
                          ),
                  ),
                ),

                // History button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/history'),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(String message) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: AppTheme.bodyMedium.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for drawing detection bounding boxes
class DetectionPainter extends CustomPainter {
  final List<DetectionResult> detections;
  final Size previewSize;
  final Size screenSize;

  DetectionPainter({
    required this.detections,
    required this.previewSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = screenSize.width / previewSize.height;
    final scaleY = screenSize.height / previewSize.width;

    for (final detection in detections) {
      final rect = detection.boundingBox;
      
      // Transform coordinates
      final left = rect.left * scaleX;
      final top = rect.top * scaleY;
      final right = rect.right * scaleX;
      final bottom = rect.bottom * scaleY;

      final paint = Paint()
        ..color = detection.categoryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      // Draw label background
      final labelPaint = Paint()..color = detection.categoryColor;
      final labelRect = Rect.fromLTWH(left, top - 24, 100, 24);
      canvas.drawRect(labelRect, labelPaint);

      // Draw label text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${detection.label} ${(detection.confidence * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(left + 4, top - 22));
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) {
    return detections != oldDelegate.detections;
  }
}
