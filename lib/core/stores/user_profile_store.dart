import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

/// Persisted store for the local user profile.
class UserProfileStore extends ChangeNotifier {
  UserProfileStore(this._prefs);

  final SharedPreferences _prefs;
  static const _profileKey = 'user_profile';

  late UserProfile _profile;

  UserProfile get profile => _profile;

  Future<void> load() async {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) {
      _profile = UserProfile(
        name: 'You',
        bio: 'Describe how you like to study.',
        skills: const ['Time management', 'Note taking'],
        avatar: '', // No default avatar - use neutral placeholder
      );
      return;
    }
    _profile = UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> update(UserProfile profile) async {
    _profile = profile;
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    notifyListeners();
  }
  
  // Method to update only the avatar
  Future<void> updateAvatar(String avatarPath) async {
    _profile.avatar = avatarPath;
    await _prefs.setString(_profileKey, jsonEncode(_profile.toJson()));
    notifyListeners();
  }
}




