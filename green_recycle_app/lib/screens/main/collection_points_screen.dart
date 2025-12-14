import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_theme.dart';

class CollectionPointsScreen extends StatefulWidget {
  const CollectionPointsScreen({super.key});

  @override
  State<CollectionPointsScreen> createState() => _CollectionPointsScreenState();
}

class _CollectionPointsScreenState extends State<CollectionPointsScreen> {
  String _selectedCategory = 'Tất cả';
  
  final List<String> _categories = [
    'Tất cả',
    'Nhựa',
    'Giấy',
    'Kim loại',
    'Thủy tinh',
    'Pin/Điện tử',
  ];

  final List<CollectionPoint> _collectionPoints = [
    CollectionPoint(
      id: '1',
      name: 'Điểm thu gom Quận 1',
      address: '123 Nguyễn Huệ, Quận 1, TP.HCM',
      distance: 0.5,
      categories: ['Nhựa', 'Giấy', 'Kim loại'],
      openTime: '07:00 - 18:00',
      phone: '0901234567',
      rating: 4.5,
      latitude: 10.7731,
      longitude: 106.7030,
    ),
    CollectionPoint(
      id: '2',
      name: 'Trung tâm tái chế Xanh',
      address: '456 Lê Lợi, Quận 3, TP.HCM',
      distance: 1.2,
      categories: ['Nhựa', 'Thủy tinh', 'Pin/Điện tử'],
      openTime: '08:00 - 20:00',
      phone: '0907654321',
      rating: 4.8,
      latitude: 10.7756,
      longitude: 106.6922,
    ),
    CollectionPoint(
      id: '3',
      name: 'Điểm thu gom Eco Life',
      address: '789 Võ Văn Tần, Quận 3, TP.HCM',
      distance: 2.0,
      categories: ['Giấy', 'Kim loại', 'Thủy tinh'],
      openTime: '06:00 - 22:00',
      phone: '0912345678',
      rating: 4.2,
      latitude: 10.7721,
      longitude: 106.6856,
    ),
    CollectionPoint(
      id: '4',
      name: 'Siêu thị tái chế Go Green',
      address: '321 Cách Mạng Tháng 8, Quận 10, TP.HCM',
      distance: 3.5,
      categories: ['Nhựa', 'Giấy', 'Kim loại', 'Thủy tinh'],
      openTime: '07:00 - 21:00',
      phone: '0923456789',
      rating: 4.6,
      latitude: 10.7725,
      longitude: 106.6665,
    ),
    CollectionPoint(
      id: '5',
      name: 'Điểm thu gom Pin điện tử',
      address: '555 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
      distance: 4.2,
      categories: ['Pin/Điện tử'],
      openTime: '08:00 - 17:00',
      phone: '0934567890',
      rating: 4.4,
      latitude: 10.8012,
      longitude: 106.7109,
    ),
  ];

  List<CollectionPoint> get filteredPoints {
    if (_selectedCategory == 'Tất cả') {
      return _collectionPoints;
    }
    return _collectionPoints
        .where((point) => point.categories.contains(_selectedCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Điểm thu gom rác'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm điểm thu gom...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Category filter
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor,
                          checkmarkColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Tìm thấy ${filteredPoints.length} điểm thu gom',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Bản đồ'),
                ),
              ],
            ),
          ),
          
          // Collection points list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredPoints.length,
              itemBuilder: (context, index) {
                final point = filteredPoints[index];
                return _CollectionPointCard(point: point);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionPointCard extends StatelessWidget {
  final CollectionPoint point;

  const _CollectionPointCard({required this.point});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point.name,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                point.rating.toString(),
                                style: AppTheme.bodySmall,
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.directions_walk,
                                color: AppTheme.textSecondary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${point.distance} km',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => point.openDirections(),
                      icon: const Icon(
                        Icons.directions,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Address
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point.address,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Open time
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      point.openTime,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Categories
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: point.categories.map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: AppTheme.bodySmall.copyWith(
                          color: _getCategoryColor(category),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Nhựa':
        return Colors.blue;
      case 'Giấy':
        return Colors.orange;
      case 'Kim loại':
        return Colors.grey;
      case 'Thủy tinh':
        return Colors.teal;
      case 'Pin/Điện tử':
        return Colors.red;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.recycling,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                point.name,
                                style: AppTheme.headingMedium,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${point.rating} (120 đánh giá)',
                                    style: AppTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Info rows
                    _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ', point.address),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.access_time, 'Giờ mở cửa', point.openTime),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.phone_outlined, 'Điện thoại', point.phone),
                    const SizedBox(height: 24),
                    
                    // Categories
                    Text(
                      'Loại rác thu gom',
                      style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: point.categories.map((category) {
                        return Chip(
                          label: Text(category),
                          backgroundColor: _getCategoryColor(category).withOpacity(0.1),
                          labelStyle: TextStyle(color: _getCategoryColor(category)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => point.callPhone(),
                            icon: const Icon(Icons.phone),
                            label: const Text('Gọi điện'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => point.openDirections(),
                            icon: const Icon(Icons.directions),
                            label: const Text('Chỉ đường'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class CollectionPoint {
  final String id;
  final String name;
  final String address;
  final double distance;
  final List<String> categories;
  final String openTime;
  final String phone;
  final double rating;
  final double latitude;
  final double longitude;

  CollectionPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.categories,
    required this.openTime,
    required this.phone,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  // Open Google Maps with directions
  Future<void> openDirections() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // Call phone number
  Future<void> callPhone() async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
