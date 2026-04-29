import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecipeShimmer extends StatelessWidget {
  const RecipeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base    = isDark ? const Color(0xFF2A2520) : const Color(0xFFEFE5D8);
    final hilite  = isDark ? const Color(0xFF3A3028) : const Color(0xFFFAF5EE);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: hilite,
        child: Container(
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
