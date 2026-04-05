import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted && authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // زر الرجوع
                CustomIconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                
                const SizedBox(height: 24),
                
                // الشعار
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // عنوان
                const Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: 'Changa',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // وصف
                Center(
                  child: Text(
                    'أهلاً بك مجدداً! قم بتسجيل الدخول للمتابعة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // حقل البريد الإلكتروني
                EmailField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                ),
                
                const SizedBox(height: 20),
                
                // حقل كلمة المرور
                PasswordField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                ),
                
                const SizedBox(height: 16),
                
                // تذكرني ونسيت كلمة المرور
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.goldColor,
                        ),
                        const Text(
                          'تذكرني',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          color: AppColors.goldColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // رسالة الخطأ
                if (authProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (authProvider.error != null) const SizedBox(height: 16),
                
                // زر تسجيل الدخول
                GoldButton(
                  text: 'تسجيل الدخول',
                  onPressed: authProvider.isLoading ? null : _login,
                  isLoading: authProvider.isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // أو
                Row(
                  children: [
                    Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // تسجيل الدخول كضيف
                CustomButton(
                  text: 'تسجيل الدخول كضيف',
                  onPressed: () async {
                    await authProvider.loginAsGuest();
                    if (mounted && authProvider.isLoggedIn) {
                      Navigator.pushReplacementNamed(context, '/main');
                    }
                  },
                  isOutlined: true,
                ),
                
                const SizedBox(height: 32),
                
                // إنشاء حساب
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
