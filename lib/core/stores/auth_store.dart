import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Store for authentication state.
class AuthStore extends ChangeNotifier {
  AuthStore(this._prefs);

  final SharedPreferences _prefs;
  static const _isLoggedInKey = 'is_logged_in';
  static const _userEmailKey = 'user_email';

  // Default credentials for testing
  static const String defaultEmail = 'user@studymatch.com';
  static const String defaultPassword = 'password123';

  bool _isLoggedIn = false;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;

  Future<void> load() async {
    _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    _userEmail = _prefs.getString(_userEmailKey);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // Accept default credentials or any non-empty credentials for demo
    final isValidDefault = email == defaultEmail && password == defaultPassword;
    final isValidAny = email.isNotEmpty && password.isNotEmpty;
    
    if (isValidDefault || isValidAny) {
      _isLoggedIn = true;
      _userEmail = email;
      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userEmailKey, email);
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    // Simple validation - in a real app, you'd create account on backend
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _isLoggedIn = true;
      _userEmail = email;
      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userEmailKey, email);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userEmailKey);
    notifyListeners();
  }
}

