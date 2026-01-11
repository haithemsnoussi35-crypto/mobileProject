import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final fullStars = value.floor();
    final halfStar = (value - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon;
        if (index < fullStars) {
          icon = Icons.star;
        } else if (index == fullStars && halfStar) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        final ratingValue = index + 1.0;
        return GestureDetector(
          onTap: () => onChanged(ratingValue),
          child: Icon(icon, size: 18, color: Colors.amber),
        );
      }),
    );
  }
}





