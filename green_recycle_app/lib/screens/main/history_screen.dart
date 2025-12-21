import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/history_service.dart';
import '../../models/classification_history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  String _selectedFilter = 'Tất cả';
  
  final List<String> _filters = [
    'Tất cả',
    'Rác tái chế',
    'Rác hữu cơ',
    'Rác vô cơ',
    'Rác nguy hại',
  ];

  Color _getCategoryColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('tái chế') || lowerLabel.contains('recyclable')) {
      return const Color(0xFF4CAF50);
    } else if (lowerLabel.contains('hữu cơ') || lowerLabel.contains('organic')) {
      return Colors.brown.shade600;
    } else if (lowerLabel.contains('vô cơ') || lowerLabel.contains('inorganic')) {
      return Colors.grey.shade600;
    } else if (lowerLabel.contains('nguy hại') || lowerLabel.contains('hazardous')) {
      return Colors.red.shade600;
    }
    return Colors.grey;
  }

  String _getCategoryEmoji(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('tái chế') || lowerLabel.contains('recyclable')) {
      return '♻️';
    } else if (lowerLabel.contains('hữu cơ') || lowerLabel.contains('organic')) {
      return '🍂';
    } else if (lowerLabel.contains('vô cơ') || lowerLabel.contains('inorganic')) {
      return '🗑️';
    } else if (lowerLabel.contains('nguy hại') || lowerLabel.contains('hazardous')) {
      return '☢️';
    }
    return '❓';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays == 1) {
      return 'Hôm qua';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  bool _matchesFilter(ClassificationHistory item) {
    if (_selectedFilter == 'Tất cả') return true;
    return item.label == _selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
        ),
        title: Text(
          'Lịch sử quét',
          style: AppTheme.headingMedium,
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<ClassificationHistory>>(
        stream: _historyService.getUserHistoryStream(limit: 100),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final allItems = snapshot.data ?? [];
          final filteredItems = allItems.where(_matchesFilter).toList();
          
          // Calculate stats
          final totalScans = allItems.length;
          final categories = allItems.map((e) => e.label).toSet().length;

          return Column(
            children: [
              // Summary card
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(totalScans.toString(), 'Tổng quét'),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildSummaryItem(categories.toString(), 'Loại rác'),
                  ],
                ),
              ),

              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: _buildFilterChip(filter, isSelected),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // History list
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFilter == 'Tất cả'
                                  ? 'Chưa có lịch sử quét'
                                  : 'Không có kết quả cho "$_selectedFilter"',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/camera'),
                              icon: const Icon(Icons.qr_code_scanner),
                              label: const Text('Quét ngay'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return _buildHistoryCard(item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headingMedium.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: AppTheme.bodySmall.copyWith(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ClassificationHistory item) {
    final color = _getCategoryColor(item.label);
    final emoji = _getCategoryEmoji(item.label);
    final timeStr = _formatTime(item.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(item.confidence * 100).toInt()}%',
                        style: AppTheme.bodySmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeStr,
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Icon xác nhận
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: color,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
