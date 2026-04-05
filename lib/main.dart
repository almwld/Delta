import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/view_mode_provider.dart';
import 'providers/wallet_provider.dart';
import 'services/storage/local_storage_service.dart';
import 'services/auth/auth_service.dart';
import 'services/wallet/wallet_service.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/verify_otp_screen.dart';
import 'screens/home/main_navigation.dart';
import 'screens/home/mode_switch_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/support/support_tickets_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة التخزين المحلي
  await LocalStorageService.init();
  
  // تهيئة خدمات المصادقة والمحفظة
  await AuthService().initialize();
  await WalletService().initialize();
  
  // إعدادات شريط الحالة
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // قفل الاتجاه
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ViewModeProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: Consumer<ViewModeProvider>(
        builder: (context, viewModeProvider, child) {
          return MaterialApp(
            title: 'Flex Yemen',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: viewModeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: const Locale('ar', 'YE'),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            initialRoute: '/',
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash & Onboarding
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      // Auth
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/verify_otp':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            phone: args?['phone'] ?? '',
            purpose: args?['purpose'] ?? 'verification',
          ),
        );
      
      // Main
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case '/mode_switch':
        return MaterialPageRoute(builder: (_) => const ModeSwitchScreen());
      
      // Wallet
      case '/wallet':
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      
      // Profile
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      // Notifications
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      // Support
      case '/support_tickets':
        return MaterialPageRoute(builder: (_) => const SupportTicketsScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الصفحة غير موجودة',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    settings.name ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
