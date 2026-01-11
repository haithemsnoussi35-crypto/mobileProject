import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/models/student.dart';
import '../../core/stores/match_store.dart';
import '../../app/app_colors.dart';
import 'widgets/modern_student_card.dart';
import 'widgets/modern_action_button.dart';
import 'widgets/no_more_cards.dart';

/// Swipe screen with animated Tinder-style cards.
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key, required this.matchStore});

  final MatchStore matchStore;

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  final List<Student> _students = [];
  int _currentIndex = 0;
  bool _loading = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimationRight;
  late Animation<Offset> _slideAnimationLeft;
  late Animation<double> _rotationAnimationRight;
  late Animation<double> _rotationAnimationLeft;
  bool _isSwipingRight = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    // Animation for swipe right (like)
    _slideAnimationRight = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotationAnimationRight = Tween<double>(
      begin: 0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // Animation for swipe left (dislike)
    _slideAnimationLeft = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotationAnimationLeft = Tween<double>(
      begin: 0,
      end: -0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      const apiUrl =
          'https://6941a446686bc3ca8167a563.mockapi.io/studymatch/base/users';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        final students = decoded
            .map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList();

        if (mounted) {
          setState(() {
            _students
              ..clear()
              ..addAll(students);
            _currentIndex = 0;
            _loading = false;
          });
        }
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error - show empty state or error message
      if (mounted) {
        setState(() {
          _loading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading students: $e'),
              action: SnackBarAction(label: 'Retry', onPressed: _loadStudents),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _swipeRight() async {
    if (_currentIndex >= _students.length) return;
    final student = _students[_currentIndex];

    setState(() => _isSwipingRight = true);
    await _controller.forward();
    await widget.matchStore.addMatch(student);

    setState(() {
      _currentIndex++;
    });
    _controller.reset();
  }

  Future<void> _swipeLeft() async {
    if (_currentIndex >= _students.length) return;

    setState(() => _isSwipingRight = false);
    await _controller.forward();
    setState(() {
      _currentIndex++;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);

    final hasMore = _currentIndex < _students.length;
    final Student? current = hasMore ? _students[_currentIndex] : null;

    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'Find Your Study Partner',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Swipe right to like, left to pass',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: hasMore
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final slideAnimation = _isSwipingRight
                          ? _slideAnimationRight
                          : _slideAnimationLeft;
                      final rotationAnimation = _isSwipingRight
                          ? _rotationAnimationRight
                          : _rotationAnimationLeft;
                      return Transform.translate(
                        offset:
                            slideAnimation.value *
                            MediaQuery.of(context).size.width,
                        child: Transform.rotate(
                          angle: rotationAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: ModernStudentCard(
                      student: current!,
                      onRatingChanged: (value) {
                        setState(() {
                          current.rating = value;
                        });
                      },
                    ),
                  )
                : NoMoreCards(
                    onReset: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ModernActionButton(
                  icon: Icons.close_rounded,
                  color: AppColors.dislikeColor,
                  onTap: _swipeLeft,
                  size: 64,
                ),
                const SizedBox(width: 24),
                ModernActionButton(
                  icon: Icons.favorite_rounded,
                  color: AppColors.likeColor,
                  onTap: _swipeRight,
                  size: 72,
                  isPrimary: true,
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 16),
      ],
    );
  }
}
