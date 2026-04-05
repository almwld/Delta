import '../models/user/user_model.dart';
import '../storage/local_storage_service.dart';

class AuthService {
  Future<AuthResult> login(String email, String password) async {
    // محاكاة تسجيل الدخول
    await Future.delayed(const Duration(seconds: 1));
    
    final user = UserModel(
      id: '1',
      fullName: 'مستخدم تجريبي',
      email: email,
      phone: '777777777',
      isVerified: true,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await LocalStorageService.saveUserData(user.toJson());
    LocalStorageService.setLoggedIn(true);
    
    return AuthResult(success: true, user: user);
  }
  
  // ✅ دالة verifyOtp
  Future<AuthResult> verifyOtp(String phone, String code, String purpose) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // تحقق من أن الرمز صحيح (للتجربة: أي رمز يعمل)
    if (code.length == 6) {
      final user = UserModel(
        id: '1',
        fullName: 'مستخدم تجريبي',
        email: 'user@example.com',
        phone: phone,
        isVerified: true,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await LocalStorageService.saveUserData(user.toJson());
      LocalStorageService.setLoggedIn(true);
      
      return AuthResult(success: true, user: user);
    }
    
    return AuthResult(success: false, error: 'رمز التحقق غير صحيح');
  }
  
  // ✅ دالة sendOtp
  Future<AuthResult> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // محاكاة إرسال رمز التحقق
    print('تم إرسال رمز التحقق إلى: $phone');
    
    return AuthResult(success: true);
  }
  
  Future<AuthResult> loginAsGuest() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'زائر',
      email: '',
      phone: '',
      isGuest: true,
      isVerified: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await LocalStorageService.saveUserData(user.toJson());
    LocalStorageService.setLoggedIn(true);
    
    return AuthResult(success: true, user: user);
  }
  
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      isVerified: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await LocalStorageService.saveUserData(user.toJson());
    LocalStorageService.setLoggedIn(true);
    
    return AuthResult(success: true, user: user);
  }
  
  Future<void> logout() async {
    await LocalStorageService.clearUserData();
    LocalStorageService.setLoggedIn(false);
  }
  
  Future<AuthResult> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> updateUserData(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> verifyIdentity({
    required String nationalId,
    required String nationality,
    required DateTime birthDate,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<void> initialize() async {
    // تهيئة الخدمة
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String? error;
  
  AuthResult({
    required this.success,
    this.user,
    this.error,
  });
}
