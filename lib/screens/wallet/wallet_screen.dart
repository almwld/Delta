import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/color_constants.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletProvider = context.watch<WalletProvider>();

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
                      'محفظتي',
                      style: TextStyle(
                        fontFamily: 'Changa',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        CustomIconButton(
                          icon: Icons.history,
                          onPressed: () {},
                        ),
                        CustomIconButton(
                          icon: Icons.settings_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // بطاقة الرصيد الرئيسية
            SliverToBoxAdapter(
              child: _buildBalanceCard(context, walletProvider)
                .animate()
                .fadeIn()
                .slideY(begin: 0.1),
            ),

            // الإجراءات السريعة
            SliverToBoxAdapter(
              child: _buildQuickActions(context)
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1),
            ),

            // الخدمات
            SliverToBoxAdapter(
              child: _buildServices(context)
                .animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.1),
            ),

            // المعاملات الأخيرة
            SliverToBoxAdapter(
              child: _buildRecentTransactions(context, walletProvider)
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletProvider walletProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الرصيد الإجمالي',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: Colors.black54),
                    SizedBox(width: 4),
                    Text(
                      'مفعلة',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            walletProvider.getFormattedTotalBalance(),
            style: const TextStyle(
              fontFamily: 'Changa',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildCurrencyChip('YER', walletProvider.yerBalance),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCurrencyChip('SAR', walletProvider.sarBalance),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCurrencyChip('USD', walletProvider.usdBalance),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyChip(String currency, double amount) {
    final symbol = currency == 'YER' ? 'ر.ي' : currency == 'SAR' ? 'ر.س' : '\$';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            symbol,
            style: const TextStyle(
              fontFamily: 'Changa',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount.toStringAsFixed(0),
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.arrow_downward, 'label': 'إيداع', 'color': AppColors.success},
      {'icon': Icons.arrow_upward, 'label': 'سحب', 'color': AppColors.error},
      {'icon': Icons.swap_horiz, 'label': 'تحويل', 'color': AppColors.info},
      {'icon': Icons.qr_code_scanner, 'label': 'مسح', 'color': AppColors.warning},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((action) {
              return _buildActionButton(
                icon: action['icon'] as IconData,
                label: action['label'] as String,
                color: action['color'] as Color,
                onTap: () {},
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices(BuildContext context) {
    final services = [
      {'icon': Icons.receipt_long, 'label': 'فواتير', 'color': Colors.purple},
      {'icon': Icons.phone_android, 'label': 'شحن', 'color': Colors.green},
      {'icon': Icons.card_giftcard, 'label': 'هدايا', 'color': Colors.pink},
      {'icon': Icons.tv, 'label': 'ترفيه', 'color': Colors.orange},
      {'icon': Icons.sports_esports, 'label': 'ألعاب', 'color': Colors.indigo},
      {'icon': Icons.apps, 'label': 'تطبيقات', 'color': Colors.teal},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخدمات',
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(
                context: context,
                icon: service['icon'] as IconData,
                label: service['label'] as String,
                color: service['color'] as Color,
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, WalletProvider walletProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المعاملات الأخيرة',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد معاملات حتى الآن',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
