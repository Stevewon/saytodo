import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  AppUser? _currentUser;
  bool _isLoading = false;
  
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  
  // 구글 로그인 (시뮬레이션)
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // 시뮬레이션: 2초 대기
      await Future.delayed(const Duration(seconds: 2));
      
      // 임시 사용자 생성
      _currentUser = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@example.com',
        displayName: '테스트 사용자',
        photoUrl: null,
        channelIds: [],
        fcmToken: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // 로그아웃
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}
