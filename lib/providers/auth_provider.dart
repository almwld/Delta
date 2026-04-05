import 'package:flutter/material.dart';
import '../models/user/user_model.dart';
import '../services/auth/auth_service.dart';
import '../services/storage/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isGuest = false;
  bool _isLoading = false;
  String? _error;
  UserModel? _userData;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get userData => _userData;
  String? get userName => _userData?.fullName;
  String? get userEmail => _userData?.email;
  String? get userAvatar => _userData?.avatarUrl;
  String? get userType => _userData?.userType;
  String? get userId => _userData?.id;
  bool get isPro => _userData?.isPro ?? false;
  int get proLevel => _userData?.proLevel ?? 1;

  AuthProvider() {
    _loadAuthState();
  }

  void _loadAuthState() {
    _isLoggedIn = LocalStorageService.isLoggedIn();
    final userDataMap = LocalStorageService.getUserData();
    if (userDataMap != null) {
      _userData = UserModel.fromJson(userDataMap);
      _isGuest = _userData!.isGuest;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.login(email, password);

    if (result.success) {
      _userData = result.user;
      _isLoggedIn = true;
      _isGuest = false;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء تسجيل الدخول');
    }

    _setLoading(false);
  }

  // ✅ دالة verifyOtp المضافة
  Future<bool> verifyOtp(String phone, String code, String purpose) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.verifyOtp(phone, code, purpose);

    _setLoading(false);
    
    if (result.success) {
      if (purpose == 'verification') {
        _userData = result.user;
        _isLoggedIn = true;
        notifyListeners();
      }
      return true;
    } else {
      _setError(result.error ?? 'رمز التحقق غير صحيح');
      return false;
    }
  }

  // ✅ دالة sendOtp المضافة
  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.sendOtp(phone);

    _setLoading(false);
    
    if (!result.success) {
      _setError(result.error ?? 'حدث خطأ أثناء إرسال الرمز');
      return false;
    }
    return true;
  }

  Future<void> loginAsGuest() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.loginAsGuest();

    if (result.success) {
      _userData = result.user;
      _isLoggedIn = true;
      _isGuest = true;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ');
    }

    _setLoading(false);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      avatarUrl: avatarUrl,
    );

    if (result.success) {
      _userData = result.user;
      _isLoggedIn = true;
      _isGuest = false;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء إنشاء الحساب');
    }

    _setLoading(false);
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _userData = null;
    _isLoggedIn = false;
    _isGuest = false;
    notifyListeners();
    _setLoading(false);
  }

  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.forgotPassword(email);

    if (!result.success) {
      _setError(result.error ?? 'حدث خطأ');
    }

    _setLoading(false);
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.updateUserData(data);

    if (result.success) {
      _userData = result.user;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ');
    }

    _setLoading(false);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!result.success) {
      _setError(result.error ?? 'حدث خطأ');
    }

    _setLoading(false);
  }

  Future<void> verifyIdentity({
    required String nationalId,
    required String nationality,
    required DateTime birthDate,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.verifyIdentity(
      nationalId: nationalId,
      nationality: nationality,
      birthDate: birthDate,
    );

    if (result.success) {
      _userData = result.user;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ');
    }

    _setLoading(false);
  }

  Future<void> upgradeToPro(int level) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(seconds: 1));

    if (_userData != null) {
      _userData = _userData!.copyWith(
        isPro: true,
        proLevel: level,
        proExpiryDate: DateTime.now().add(const Duration(days: 365)),
      );
      await LocalStorageService.saveUserData(_userData!.toJson());
      notifyListeners();
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  bool get canAccessFullFeatures => _isLoggedIn && !_isGuest;
  bool get canAccessProFeatures => _isLoggedIn && (_userData?.isPro ?? false);
  bool get canAccessExpertFeatures => _isLoggedIn && (_userData?.proLevel ?? 0) >= 3;
}
