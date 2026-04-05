import '../storage/local_storage_service.dart';

class AuthService {
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> verifyOtp(String phone, String code, String purpose) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.length == 6) {
      return AuthResult(success: true);
    }
    return AuthResult(success: false, error: 'رمز التحقق غير صحيح');
  }
  
  Future<AuthResult> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> loginAsGuest() async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
  
  Future<void> logout() async {
    await LocalStorageService.clearUserData();
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
  
  Future<void> initialize() async {}
}

class AuthResult {
  final bool success;
  final String? error;
  
  AuthResult({
    required this.success,
    this.error,
  });
}
