import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/entities/recipe.dart';
import '../providers/favorite_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends ConsumerState<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _favCtrl;

  @override
  void initState() {
    super.initState();
    _favCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _favCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav  = ref.watch(favoriteProvider.notifier).isFavorite(widget.recipe.id);
    final r      = widget.recipe;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [


          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    _favCtrl.forward(from: 0);
                    ref.read(favoriteProvider.notifier).toggleFavorite(r);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav ? 'Removed from favorites' : 'Saved to favorites ',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.4).animate(
                      CurvedAnimation(parent: _favCtrl, curve: Curves.elasticOut),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFav
                            ? AppColors.primary
                            : Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe-${r.id}',
                child: CachedNetworkImage(
                  imageUrl: r.image,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.lightCard,
                    child: const Icon(Icons.restaurant, size: 60, color: AppColors.textHint),
                  ),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Name
                  Text(
                    r.name,
                    style: Theme.of(context).textTheme.displaySmall ??
                        Theme.of(context).textTheme.headlineLarge,
                  ).animate().fadeIn().slideX(begin: -0.03),

                  const SizedBox(height: 10),


                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (r.area.isNotEmpty)
                        _Tag(label: ' ${r.area}', color: AppColors.primary),
                      if (r.category.isNotEmpty)
                        _Tag(label: ' ${r.category}', color: AppColors.accentGreen),
                      if (r.tags.isNotEmpty)
                        ...r.tags
                            .split(',')
                            .where((t) => t.trim().isNotEmpty)
                            .take(3)
                            .map((t) => _Tag(label: t.trim(), color: AppColors.accent)),
                    ],
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 28),

                  // Ingredients
                  if (r.ingredients.isNotEmpty) ...[
                    Text('Ingredients',
                      style: Theme.of(context).textTheme.headlineSmall ??
                          Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    ...r.ingredients.asMap().entries.map(
                      (e) => _IngredientRow(
                        ingredient: e.value,
                        index: e.key,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],


                  Text('Instructions',
                    style: Theme.of(context).textTheme.headlineSmall ??
                        Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    r.instructions,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.7,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final Ingredient ingredient;
  final int index;
  final bool isDark;

  const _IngredientRow({
    required this.ingredient,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            ingredient.measure,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 40 * index)).slideX(begin: 0.04);
  }
}
