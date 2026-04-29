import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/favorite_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/empty_state.dart';

class FavoritesScreen extends ConsumerWidget {

  final bool embedded;

  const FavoritesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final isDark    = Theme.of(context).brightness == Brightness.dark;

    Widget body = favorites.isEmpty
        ? const EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'No Saved Recipes',
            subtitle: 'Tap the heart on any recipe to save it here.',
          )
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.refresh(favoriteProvider),
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              itemCount: favorites.length,
              itemBuilder: (_, i) =>
                  RecipeCard(recipe: favorites[i], index: i),
            ),
          );

    if (embedded) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved',
                    style: Theme.of(context).textTheme.displayMedium,
                  ).animate().fadeIn(),
                  Text('${favorites.length} recipe${favorites.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: body,
    );
  }
}
