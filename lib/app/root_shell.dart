import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_background.dart';
import '../core/stores/auth_store.dart';
import '../core/stores/match_store.dart';
import '../core/stores/user_profile_store.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/swipe/swipe_screen.dart';
import '../features/matches/matches_screen.dart';
import '../features/profile/profile_screen.dart';

/// Root shell with authentication check and bottom navigation.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  bool _showSignUp = false;

  late final AuthStore _authStore;
  late final MatchStore _matchStore;
  late final UserProfileStore _profileStore;

  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initStores();
  }

  Future<void> _initStores() async {
    final prefs = await SharedPreferences.getInstance();
    _authStore = AuthStore(prefs);
    _matchStore = MatchStore(prefs);
    _profileStore = UserProfileStore(prefs);
    
    await _authStore.load();
    await _profileStore.load();
    await _matchStore.load();
    
    _authStore.addListener(_onAuthChanged);
    
    setState(() {
      _ready = true;
    });
  }

  void _onAuthChanged() {
    if (mounted) {
      setState(() {});
    }
  }


  @override
  void dispose() {
    _authStore.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show login/signup if not authenticated
    if (!_authStore.isLoggedIn) {
      if (_showSignUp) {
        return SignUpScreen(
          authStore: _authStore,
          onLoginPressed: () {
            setState(() => _showSignUp = false);
          },
        );
      }
      return LoginScreen(
        authStore: _authStore,
        onSignUpPressed: () {
          setState(() => _showSignUp = true);
        },
      );
    }

    // Show main app if authenticated
    final pages = [
      HomeScreen(profileStore: _profileStore, matchStore: _matchStore),
      SwipeScreen(matchStore: _matchStore),
      MatchesScreen(matchStore: _matchStore),
      ProfileScreen(profileStore: _profileStore, authStore: _authStore),
    ];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(child: pages[_index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.swipe), label: 'Swipe'),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

