import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../core/services/notification_service.dart';
import '../providers/favorite_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/search_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/repository_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/empty_state.dart';
import 'favorites_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(contextLoadProvider);

      ref.read(favoriteProvider);

      NotificationService.instance.scheduleAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.red.shade700 : AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final greeting = TimeUtils.getGreeting();
    final mealLabel= TimeUtils.getMealLabel();

    final screens = [
      _HomeTab(
        greeting: greeting,
        mealLabel: mealLabel,
        searchController: _searchController,
        isDark: isDark,
        onSnack: _showSnack,
      ),
      const FavoritesScreen(embedded: true),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: IndexedStack(index: _currentTab, children: screens),
      bottomNavigationBar: _BottomNav(
        current: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        isDark: isDark,
      ),
    );
  }
}



class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _BottomNav({required this.current, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded,     label: 'Discover', active: current == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.favorite_rounded,  label: 'Saved',    active: current == 1, onTap: () => onTap(1)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textHint;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}



class _HomeTab extends ConsumerStatefulWidget {
  final String greeting;
  final String mealLabel;
  final TextEditingController searchController;
  final bool isDark;
  final void Function(String, {bool isError}) onSnack;

  const _HomeTab({
    required this.greeting,
    required this.mealLabel,
    required this.searchController,
    required this.isDark,
    required this.onSnack,
  });

  @override
  ConsumerState<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<_HomeTab> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final isDark      = widget.isDark;
    final themeNotif  = ref.read(themeModeProvider.notifier);
    final isDarkMode  = ref.watch(themeModeProvider) == ThemeMode.dark;
    final contextLoad = ref.watch(contextLoadProvider);
    final recipeState = ref.watch(recipeProvider);
    final searchFn    = ref.read(searchHandlerProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.greeting,
                        style: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      Text('Find a Recipe',
                        style: Theme.of(context).textTheme.displayMedium,
                      ).animate().fadeIn().slideX(begin: -0.05),
                    ],
                  ),
                ),
                // Theme toggle
                IconButton(
                  onPressed: themeNotif.toggle,
                  icon: AnimatedSwitcher(
                    duration: 300.ms,
                    child: Icon(
                      isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      key: ValueKey(isDarkMode),
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Context pill ────────────────────────────
          contextLoad.when(
            loading: () => const SizedBox(height: 4),
            error: (_, __) => const SizedBox(height: 4),
            data: (cuisine) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  _Pill(
                    icon: Icons.location_on,
                    label: '$cuisine cuisine',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    icon: Icons.schedule,
                    label: widget.mealLabel,
                    color: AppColors.accentGreen,
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
            ),
          ),

          const SizedBox(height: 16),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: widget.searchController,
              onChanged: (v) {
                setState(() => _isSearching = v.isNotEmpty);
                searchFn(v);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search any recipe…',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
                suffixIcon: _isSearching
                    ? GestureDetector(
                        onTap: () {
                          widget.searchController.clear();
                          setState(() => _isSearching = false);
                          // Reload context-aware list
                          ref.read(contextLoadProvider);
                        },
                        child: const Icon(Icons.close, size: 18, color: AppColors.textHint),
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 16),


          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSearching ? 'Search Results' : '${widget.mealLabel} Ideas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!_isSearching)
                  TextButton(
                    onPressed: () => ref.read(contextLoadProvider),
                    child: const Text('Refresh'),
                  ),
              ],
            ),
          ),

          // ── Recipe grid ─────────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => ref.refresh(contextLoadProvider),
              child: recipeState.when(
                loading: () => const RecipeShimmer(),
                error: (e, _) => EmptyState(
                  icon: Icons.wifi_off_rounded,
                  title: 'No Connection',
                  subtitle: 'Showing cached recipes. Pull to retry.',
                  actionLabel: 'Try Again',
                  onAction: () => ref.refresh(contextLoadProvider),
                ),
                data: (recipes) {
                  if (recipes.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No Recipes Found',
                      subtitle: _isSearching
                          ? 'Try a different search term.'
                          : 'Pull down to refresh.',
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (_, i) => RecipeCard(recipe: recipes[i], index: i),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
