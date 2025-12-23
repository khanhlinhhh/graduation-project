import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../providers/settings_provider.dart';
import '../../services/notification_service.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUserData();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
    
    // Always refresh data when returning from edit profile
    // (avatar might have been updated without pressing save button)
    _loadUserData();
  }

  void _showLanguageDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(settings.tr('selectLanguage')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇻🇳', style: TextStyle(fontSize: 24)),
              title: const Text('Tiếng Việt'),
              trailing: settings.language == 'vi' 
                  ? const Icon(Icons.check, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                settings.setLanguage('vi');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: settings.language == 'en' 
                  ? const Icon(Icons.check, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                settings.setLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBackgroundColor : const Color(0xFFF5F5F5);
    final cardColor = isDark ? AppTheme.darkSurfaceColor : Colors.white;
    final textColor = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              settings.tr('profile'),
              style: AppTheme.headingMedium.copyWith(color: textColor),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined, color: secondaryTextColor),
                onPressed: () {},
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Avatar
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : const Color(0xFFE8DCC8),
                              borderRadius: BorderRadius.circular(24),
                              image: _user?.avatarUrl != null && _user!.avatarUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(_user!.avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _user?.avatarUrl == null || _user!.avatarUrl!.isEmpty
                                ? const Center(
                                    child: Text('👤', style: TextStyle(fontSize: 50)),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: GestureDetector(
                              onTap: _navigateToEditProfile,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: cardColor, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      Text(
                        _user?.displayName ?? 'Người dùng',
                        style: AppTheme.headingMedium.copyWith(color: textColor),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        _user?.email ?? '',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stats Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.eco,
                                iconColor: AppTheme.primaryColor,
                                value: '${_user?.greenPoints ?? 0}',
                                label: settings.tr('greenPoints'),
                                cardColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.qr_code_scanner,
                                iconColor: AppTheme.accentColor,
                                value: '${_user?.scanCount ?? 0}',
                                label: settings.tr('scanCount'),
                                cardColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Settings Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.tr('settings').toUpperCase(),
                              style: AppTheme.bodySmall.copyWith(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: settings.tr('personalInfo'),
                              cardColor: cardColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              onTap: _navigateToEditProfile,
                            ),
                            // Notifications with badge
                            StreamBuilder<int>(
                              stream: NotificationService().getUnreadCountStream(),
                              builder: (context, snapshot) {
                                final unreadCount = snapshot.data ?? 0;
                                return _buildMenuItem(
                                  icon: Icons.notifications_outlined,
                                  title: settings.tr('notifications'),
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  trailing: unreadCount > 0
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                unreadCount > 99 ? '99+' : '$unreadCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: secondaryTextColor,
                                            ),
                                          ],
                                        )
                                      : null,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const NotificationsScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.language,
                              title: settings.tr('language'),
                              cardColor: cardColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    settings.isVietnamese ? 'Tiếng Việt' : 'English',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: secondaryTextColor,
                                  ),
                                ],
                              ),
                              onTap: () => _showLanguageDialog(context),
                            ),
                            _buildMenuItem(
                              icon: Icons.dark_mode_outlined,
                              title: settings.tr('darkMode'),
                              cardColor: cardColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              trailing: Switch(
                                value: settings.isDarkMode,
                                onChanged: (value) {
                                  settings.setDarkMode(value);
                                },
                                activeColor: AppTheme.primaryColor,
                              ),
                              onTap: () {
                                settings.toggleTheme();
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.help_outline,
                              title: settings.tr('helpSupport'),
                              cardColor: cardColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () => Navigator.pushNamed(context, '/help-support'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Logout Button
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          settings.tr('logout'),
                          style: AppTheme.bodyLarge.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTheme.headingSmall.copyWith(color: textColor),
              ),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(color: secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: secondaryTextColor),
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(color: textColor),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: secondaryTextColor,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
