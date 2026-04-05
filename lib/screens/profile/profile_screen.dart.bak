import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/view_mode_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final viewModeProvider = context.watch<ViewModeProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'حسابي',
                      style: TextStyle(
                        fontFamily: 'Changa',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        // TODO: فتح الإعدادات
                      },
                    ),
                  ],
                ),
              ),
            ),

            // معلومات المستخدم
            SliverToBoxAdapter(
              child: _buildUserInfo(context, authProvider),
            ),

            // الإحصائيات
            SliverToBoxAdapter(
              child: _buildStats(context),
            ),

            // القائمة
            SliverToBoxAdapter(
              child: _buildMenu(context, authProvider, viewModeProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: authProvider.userAvatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.network(
                        authProvider.userAvatar!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person, size: 40, color: Colors.black54),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.userName ?? 'ضيف',
                      style: const TextStyle(
                        fontFamily: 'Changa',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.userEmail ?? '',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (authProvider.isPro)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.workspace_premium, size: 14, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              'PRO ${authProvider.proLevel}',
                              style: const TextStyle(
                                fontFamily: 'Changa',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (authProvider.isGuest)
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: AppColors.goldColor,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: تعديل الملف الشخصي
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تعديل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: AppColors.goldColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/mode_switch'),
                    icon: const Icon(Icons.switch_account, size: 18),
                    label: const Text('تغيير الوضع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: AppColors.goldColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final stats = [
      {'value': '12', 'label': 'طلب'},
      {'value': '5', 'label': 'مفضل'},
      {'value': '3', 'label': 'عنوان'},
      {'value': '2', 'label': 'بطاقة'},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) {
          return Column(
            children: [
              Text(
                stat['value']!,
                style: const TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat['label']!,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, AuthProvider authProvider, ViewModeProvider viewModeProvider) {
    final menuItems = [
      {'icon': Icons.shopping_bag_outlined, 'label': 'طلباتي', 'route': '/orders'},
      {'icon': Icons.favorite_outline, 'label': 'المفضلة', 'route': '/favorites'},
      {'icon': Icons.location_on_outlined, 'label': 'عناويني', 'route': '/addresses'},
      {'icon': Icons.payment_outlined, 'label': 'طرق الدفع', 'route': '/payment_methods'},
      {'icon': Icons.notifications_outlined, 'label': 'الإشعارات', 'route': '/notifications'},
      {'icon': Icons.support_agent_outlined, 'label': 'الدعم الفني', 'route': '/support_tickets'},
      {'icon': Icons.help_outline, 'label': 'المساعدة', 'route': '/help'},
      {'icon': Icons.dark_mode_outlined, 'label': 'الوضع الليلي', 'isSwitch': true},
      {'icon': Icons.logout, 'label': 'تسجيل الخروج', 'isLogout': true},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: menuItems.map((item) {
          final isLast = item == menuItems.last;
          
          if (item['isSwitch'] == true) {
            return _buildSwitchItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              value: viewModeProvider.isDarkMode,
              onChanged: (value) => viewModeProvider.toggleDarkMode(),
              isLast: isLast,
            );
          }
          
          if (item['isLogout'] == true) {
            return _buildLogoutItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              onTap: () => _showLogoutDialog(context, authProvider),
              isLast: isLast,
            );
          }
          
          return _buildMenuItem(
            icon: item['icon'] as IconData,
            label: item['label'] as String,
            onTap: () => Navigator.pushNamed(context, item['route'] as String),
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              )
            : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: !isLast
          ? Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            )
          : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: isDark ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.goldColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]!
                    : Colors.grey[200]!,
                ),
              )
            : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.error),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontFamily: 'Changa'),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
