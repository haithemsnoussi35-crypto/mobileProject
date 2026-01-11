import 'package:flutter/material.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key, required this.matchCount});

  final int matchCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Matches',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '$matchCount partners saved',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const Icon(Icons.favorite, color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }
}





