import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    await authProvider.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
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
                const SizedBox(height: 20),
                
                // زر الرجوع
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                
                const SizedBox(height: 16),
                
                // عنوان
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // وصف
                Text(
                  'أنشئ حسابك الآن واستمتع بتجربة تسوق فريدة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // الاسم الكامل
                CustomTextField(
                  label: 'الاسم الكامل',
                  hint: 'أحمد محمد',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // البريد الإلكتروني
                EmailField(
                  controller: _emailController,
                ),
                
                const SizedBox(height: 20),
                
                // رقم الجوال
                PhoneField(
                  controller: _phoneController,
                ),
                
                const SizedBox(height: 20),
                
                // كلمة المرور
                PasswordField(
                  controller: _passwordController,
                ),
                
                const SizedBox(height: 20),
                
                // تأكيد كلمة المرور
                PasswordField(
                  label: 'تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // الموافقة على الشروط
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.goldColor,
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          const Text(
                            'أوافق على ',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: فتح شروط الاستخدام
                            },
                            child: const Text(
                              'الشروط والأحكام',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                color: AppColors.goldColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            ' و',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: فتح سياسة الخصوصية
                            },
                            child: const Text(
                              'سياسة الخصوصية',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                color: AppColors.goldColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
                
                // زر إنشاء الحساب
                GoldButton(
                  text: 'إنشاء حساب',
                  onPressed: authProvider.isLoading ? null : _register,
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
                
                // تسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'تسجيل الدخول',
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
