import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_theme.dart';
import '../../models/tip_model.dart';
import '../../services/tips_service.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final TipsService _tipsService = TipsService();
  StreamSubscription? _tipsSubscription;
  List<TipModel> _allTips = [];
  List<TipModel> _displayedTips = [];
  bool _isLoading = true;
  int _currentPage = 0;
  final int _tipsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _subscribeToTips();
  }

  @override
  void dispose() {
    _tipsSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToTips() {
    setState(() => _isLoading = true);
    
    _tipsSubscription = _tipsService.getTipsStream().listen(
      (tips) {
        // Nếu không có tips từ Firebase, dùng data hardcode
        if (tips.isEmpty) {
          setState(() {
            _allTips = TipsData.allTips;
            _displayedTips = _allTips.take(_tipsPerPage).toList();
            _currentPage = 1;
            _isLoading = false;
          });
        } else {
          setState(() {
            _allTips = tips;
            // Giữ nguyên số tips đang hiển thị hoặc hiển thị trang đầu
            final displayCount = _displayedTips.isEmpty 
                ? _tipsPerPage 
                : _displayedTips.length;
            _displayedTips = _allTips.take(displayCount).toList();
            _currentPage = (displayCount / _tipsPerPage).ceil();
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        print('Error in tips stream: $error');
        // Fallback về data hardcode khi có lỗi
        setState(() {
          _allTips = TipsData.allTips;
          _displayedTips = _allTips.take(_tipsPerPage).toList();
          _currentPage = 1;
          _isLoading = false;
        });
      },
    );
  }

  void _loadMoreTips() {
    if (_isLoading) return;

    final startIndex = _currentPage * _tipsPerPage;
    final newTips = _allTips.skip(startIndex).take(_tipsPerPage).toList();

    setState(() {
      _displayedTips.addAll(newTips);
      _currentPage++;
    });
  }

  bool get _hasMoreTips => _displayedTips.length < _allTips.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tips',
          style: AppTheme.headingMedium.copyWith(
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading && _displayedTips.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expert Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Helpful tips, courtesy of',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Green Recycle Team',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chuyên gia môi trường & Tái chế',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),

            // Tips List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _displayedTips.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tip = _displayedTips[index];
                return _buildTipItem(tip);
              },
            ),

            // Load More Button
            if (_hasMoreTips)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loadMoreTips,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Load More',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(TipModel tip) {
    return GestureDetector(
      onTap: () => _showTipDetails(tip),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon/Image
            tip.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      tip.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconContainer(tip);
                      },
                    ),
                  )
                : _buildIconContainer(tip),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tip.categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tip.category,
                      style: AppTheme.bodySmall.copyWith(
                        color: tip.categoryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Thêm icon mũi tên để gợi ý có thể click
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.touch_app, size: 14, color: tip.categoryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Xem chi tiết',
                        style: AppTheme.bodySmall.copyWith(
                          color: tip.categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(TipModel tip) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: tip.categoryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          tip.icon,
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  void _showTipDetails(TipModel tip) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon/image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: tip.imageUrl.isNotEmpty
                        ? Image.network(
                            tip.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDetailHeader(tip);
                            },
                          )
                        : _buildDetailHeader(tip),
                  ),
                  // Close button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tip.categoryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tip.category,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.title,
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tip.description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Steps section
                    if (tip.steps.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tip.categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: tip.categoryColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Hướng dẫn cụ thể',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: tip.categoryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...tip.steps.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: tip.categoryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${entry.key + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: AppTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    
                    // Done button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tip.categoryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đã hiểu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeader(TipModel tip) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: tip.categoryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Center(
        child: Text(
          tip.icon,
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
