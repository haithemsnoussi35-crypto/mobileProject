import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

/// Persisted store for matches.
class MatchStore extends ChangeNotifier {
  MatchStore(this._prefs);

  final SharedPreferences _prefs;
  static const _matchesKey = 'matches';

  final List<Student> _matches = [];

  List<Student> get matches => List.unmodifiable(_matches);

  Future<void> load() async {
    final raw = _prefs.getString(_matchesKey);
    if (raw == null) return;
    final decoded = jsonDecode(raw) as List<dynamic>;
    _matches
      ..clear()
      ..addAll(decoded.map((e) => Student.fromJson(e as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> addMatch(Student student) async {
    if (_matches.indexWhere((s) => s.id == student.id) != -1) return;
    _matches.add(student);
    await _save();
    notifyListeners();
  }

  Future<void> removeMatch(String id) async {
    _matches.removeWhere((s) => s.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final encoded = jsonEncode(_matches.map((e) => e.toJson()).toList());
    await _prefs.setString(_matchesKey, encoded);
  }
}





