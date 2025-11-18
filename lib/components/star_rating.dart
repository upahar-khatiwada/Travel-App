import 'package:flutter/material.dart';

// https://medium.com/@arunb9525/building-a-customizable-star-rating-widget-in-flutter-a-complete-guide-8a2db117ea6f
class AppColors {
  static const Color secondaryContainerGray = Color(0xFFB0BEC5);
  static const Color ratingPrimaryColor = Color(
    0xFFFFD700,
  ); // Gold color for rating stars
}

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color? color;
  const StarRating({
    super.key,
    this.starCount = 5, // Default to 5 stars
    this.rating = 0.0, // Default rating is 0
    this.color, // Optional: custom color for stars
  });
  // Method to build each individual star based on the rating and index
  Widget buildStar(final BuildContext context, final int index) {
    Icon icon;
    // If the index is greater than or equal to the rating, we show an empty star
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border, // Empty star
        size: 16,
        color: AppColors.secondaryContainerGray, // Light gray for empty stars
      );
    }
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half, // Half star
        size: 16,
        color:
            color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    // Otherwise, we show a full star
    else {
      icon = Icon(
        Icons.star, // Full star
        size: 16,
        color:
            color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    return icon;
  }

  @override
  Widget build(final BuildContext context) {
    // Creating a row of stars based on the starCount
    return Row(
      children: List<Widget>.generate(
        starCount, // Generate a row with 'starCount' stars
        (final int index) => buildStar(context, index),
      ),
    );
  }
}