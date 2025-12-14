import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _captureAndScan() async {
    setState(() => _isScanning = true);

    // Simulate scanning
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isScanning = false);
      Navigator.pushNamed(context, '/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
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
              child: Icon(
                Icons.camera_alt,
                size: 80,
                color: Colors.white24,
              ),
            ),
          ),

          // Scanning overlay
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.6),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      // Corner decorations
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _buildCorner(0),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _buildCorner(1),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: _buildCorner(2),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _buildCorner(3),
                      ),

                      // Scanning line
                      if (_isScanning)
                        Positioned(
                          top: _animation.value * 260,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppTheme.primaryColor,
                                  AppTheme.primaryColor,
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Top bar
          SafeArea(
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
                          Icons.flash_auto,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tự động',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
          ),

          // Bottom controls
          Positioned(
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
                      Container(
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

                      // Capture button
                      GestureDetector(
                        onTap: _isScanning ? null : _captureAndScan,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isScanning
                                ? AppTheme.primaryColor.withOpacity(0.5)
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
                                  Icons.camera_alt,
                                  size: 36,
                                  color: AppTheme.primaryColor,
                                ),
                        ),
                      ),

                      // History button
                      Container(
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
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(int position) {
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
        borderRadius =
            const BorderRadius.only(bottomRight: Radius.circular(24));
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
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          bottom: position >= 2
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          left: position % 2 == 0
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          right: position % 2 == 1
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}
