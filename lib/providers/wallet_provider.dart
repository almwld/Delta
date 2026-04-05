import 'package:flutter/material.dart';
import '../models/wallet/wallet_model.dart';
import '../models/wallet/wallet_transaction.dart';
import '../services/wallet/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  
  WalletModel? _wallet;
  List<WalletTransaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  bool _isRefreshing = false;

  WalletModel? get wallet => _wallet;
  List<WalletTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;
  bool get hasWallet => _wallet != null;
  
  // أرصدة العملات
  double get yerBalance => _wallet?.getBalance('YER')?.amount ?? 0;
  double get sarBalance => _wallet?.getBalance('SAR')?.amount ?? 0;
  double get usdBalance => _wallet?.getBalance('USD')?.amount ?? 0;
  
  // إجمالي الرصيد بالريال اليمني
  double get totalBalanceYER => _wallet?.totalBalanceYER ?? 0;
  
  // الرصيد المتاح
  double get availableYER => _wallet?.getBalance('YER')?.availableAmount ?? 0;
  double get availableSAR => _wallet?.getBalance('SAR')?.availableAmount ?? 0;
  double get availableUSD => _wallet?.getBalance('USD')?.availableAmount ?? 0;

  // تهيئة المحفظة
  Future<void> initializeWallet(String userId) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.createWallet(userId);
    
    if (result.success) {
      _wallet = result.wallet;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء إنشاء المحفظة');
    }
    
    _setLoading(false);
  }

  // تحميل بيانات المحفظة
  Future<void> loadWallet(String walletId) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.getWallet(walletId);
    
    if (result.success) {
      _wallet = result.wallet;
      notifyListeners();
    } else {
      _setError(result.error ?? 'حدث خطأ');
    }
    
    _setLoading(false);
  }

  // تحديث بيانات المحفظة
  Future<void> refreshWallet() async {
    if (_wallet == null) return;
    
    _isRefreshing = true;
    notifyListeners();
    
    final result = await _walletService.getWallet(_wallet!.id);
    
    if (result.success) {
      _wallet = result.wallet;
      notifyListeners();
    }
    
    _isRefreshing = false;
    notifyListeners();
  }

  // إيداع مبلغ
  Future<bool> deposit({
    required String currency,
    required double amount,
    required String method,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.deposit(
      currency: currency,
      amount: amount,
      method: method,
      description: description,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء الإيداع');
      _setLoading(false);
      return false;
    }
  }

  // سحب مبلغ
  Future<bool> withdraw({
    required String currency,
    required double amount,
    required String method,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.withdraw(
      currency: currency,
      amount: amount,
      method: method,
      description: description,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء السحب');
      _setLoading(false);
      return false;
    }
  }

  // تحويل مبلغ
  Future<bool> transfer({
    required String currency,
    required double amount,
    required String recipientId,
    required String recipientName,
    String? recipientPhone,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.transfer(
      currency: currency,
      amount: amount,
      recipientId: recipientId,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      description: description,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء التحويل');
      _setLoading(false);
      return false;
    }
  }

  // دفع فاتورة
  Future<bool> payBill({
    required String billId,
    required String currency,
    required double amount,
    required String provider,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.payBill(
      billId: billId,
      currency: currency,
      amount: amount,
      provider: provider,
      description: description,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء دفع الفاتورة');
      _setLoading(false);
      return false;
    }
  }

  // شراء بطاقة هدايا
  Future<bool> buyGiftCard({
    required String cardType,
    required String currency,
    required double amount,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.buyGiftCard(
      cardType: cardType,
      currency: currency,
      amount: amount,
      description: description,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ');
      _setLoading(false);
      return false;
    }
  }

  // شحن رصيد
  Future<bool> recharge({
    required String phoneNumber,
    required String operator,
    required String currency,
    required double amount,
  }) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.recharge(
      phoneNumber: phoneNumber,
      operator: operator,
      currency: currency,
      amount: amount,
    );
    
    if (result.success) {
      _wallet = result.wallet;
      if (result.transaction != null) {
        _transactions.insert(0, result.transaction!);
      }
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ أثناء الشحن');
      _setLoading(false);
      return false;
    }
  }

  // تحميل سجل المعاملات
  Future<void> loadTransactions({
    String? currency,
    TransactionType? type,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
  }) async {
    _setLoading(true);
    
    final transactions = await _walletService.getTransactionHistory(
      currency: currency,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
    );
    
    _transactions = transactions;
    notifyListeners();
    _setLoading(false);
  }

  // التحقق من وجود رصيد كافٍ
  bool hasSufficientBalance(String currency, double amount) {
    return _wallet?.hasSufficientBalance(currency, amount) ?? false;
  }

  // تحديث رمز PIN
  Future<bool> updatePin(String newPin) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.updatePin(newPin);
    
    if (result.success) {
      _wallet = result.wallet;
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ');
      _setLoading(false);
      return false;
    }
  }

  // تفعيل/تعطيل البصمة
  Future<bool> toggleBiometric(bool enabled) async {
    _setLoading(true);
    _clearError();
    
    final result = await _walletService.toggleBiometric(enabled);
    
    if (result.success) {
      _wallet = result.wallet;
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? 'حدث خطأ');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // الحصول على الرصيد بتنسيق منسق
  String getFormattedBalance(String currency) {
    final balance = _wallet?.getBalance(currency);
    if (balance == null) return '0 $currency';
    return balance.formattedAmount;
  }

  // الحصول على إجمالي الرصيد بتنسيق منسق
  String getFormattedTotalBalance() {
    return '${totalBalanceYER.toStringAsFixed(0)} ر.ي';
  }
}
