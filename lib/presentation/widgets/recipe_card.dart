import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_theme.dart';
import '../../data/entities/recipe.dart';
import '../providers/favorite_provider.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends ConsumerStatefulWidget {
  final Recipe recipe;
  final int index;

  const RecipeCard({super.key, required this.recipe, this.index = 0});

  @override
  ConsumerState<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends ConsumerState<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _favController;

  @override
  void initState() {
    super.initState();
    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _favController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightSurface;
    final isFav  = ref.watch(favoriteProvider.notifier).isFavorite(widget.recipe.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) =>
              RecipeDetailScreen(recipe: widget.recipe),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'recipe-${widget.recipe.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: widget.recipe.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) {
                          final base = isDark
                              ? const Color(0xFF2A2520)
                              : const Color(0xFFEFE5D8);
                          return Shimmer.fromColors(
                            baseColor: base,
                            highlightColor: base.withOpacity(0.5),
                            child: Container(color: base),
                          );
                        },
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.lightCard,
                          child: const Icon(Icons.restaurant,
                              size: 40, color: AppColors.textHint),
                        ),
                      ),
                    ),
                  ),
                  // Area badge
                  if (widget.recipe.area.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.recipe.area,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  // Favorite button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        _favController.forward(from: 0);
                        ref
                            .read(favoriteProvider.notifier)
                            .toggleFavorite(widget.recipe);
                      },
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1, end: 1.35).animate(
                          CurvedAnimation(
                            parent: _favController,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFav
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (widget.recipe.category.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.local_dining,
                            size: 11, color: AppColors.primary.withOpacity(0.7)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            widget.recipe.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 60 * widget.index),
          duration: 350.ms,
        )
        .slideY(begin: 0.08, end: 0);
  }
}
