import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Google 로그인 (임시 구현)
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Firebase Google 로그인 구현
      await Future.delayed(const Duration(seconds: 2));
      
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '로그인 실패: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    _isAuthenticated = false;
    notifyListeners();
  }

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
