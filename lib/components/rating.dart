import 'package:flutter/material.dart';

Widget buildRatingStars(int currentRating, Function(int) onRatingSelected) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return IconButton(
        icon: Icon(
          index < currentRating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: Colors.amber,
          size: 40,
        ),
        onPressed: () => onRatingSelected(index + 1),
      );
    }),
  );
}