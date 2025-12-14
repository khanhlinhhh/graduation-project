import 'package:flutter/material.dart';
import '../../app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = [
      _HistoryItem(
        name: 'Chai nhựa',
        category: 'Tái chế',
        time: '2 phút trước',
        emoji: '♻️',
        color: const Color(0xFF4CAF50),
        points: 10,
      ),
      _HistoryItem(
        name: 'Vỏ chuối',
        category: 'Hữu cơ',
        time: '1 giờ trước',
        emoji: '🍃',
        color: const Color(0xFF8BC34A),
        points: 5,
      ),
      _HistoryItem(
        name: 'Pin cũ',
        category: 'Nguy hại',
        time: 'Hôm qua',
        emoji: '⚠️',
        color: const Color(0xFFF44336),
        points: 15,
      ),
      _HistoryItem(
        name: 'Hộp giấy',
        category: 'Tái chế',
        time: 'Hôm qua',
        emoji: '♻️',
        color: const Color(0xFF4CAF50),
        points: 10,
      ),
      _HistoryItem(
        name: 'Lon nước ngọt',
        category: 'Tái chế',
        time: '2 ngày trước',
        emoji: '♻️',
        color: const Color(0xFF4CAF50),
        points: 10,
      ),
      _HistoryItem(
        name: 'Túi nilon',
        category: 'Thông thường',
        time: '3 ngày trước',
        emoji: '🗑️',
        color: const Color(0xFF9E9E9E),
        points: 3,
      ),
      _HistoryItem(
        name: 'Vỏ trái cây',
        category: 'Hữu cơ',
        time: '3 ngày trước',
        emoji: '🍃',
        color: const Color(0xFF8BC34A),
        points: 5,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Lịch sử quét',
          style: AppTheme.headingMedium,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
      body: Column(
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
                _buildSummaryItem('7', 'Tổng quét'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem('58', 'Điểm nhận'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildSummaryItem('4', 'Loại rác'),
              ],
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tất cả', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tái chế', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Hữu cơ', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Nguy hại', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Thông thường', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // History list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return _buildHistoryCard(item);
              },
            ),
          ),
        ],
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

  Widget _buildHistoryCard(_HistoryItem item) {
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
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
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
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.category,
                        style: AppTheme.bodySmall.copyWith(
                          color: item.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.time,
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${item.points}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String name;
  final String category;
  final String time;
  final String emoji;
  final Color color;
  final int points;

  _HistoryItem({
    required this.name,
    required this.category,
    required this.time,
    required this.emoji,
    required this.color,
    required this.points,
  });
}
