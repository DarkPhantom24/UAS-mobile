import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart' as app;
import '../theme/app_theme.dart';
import 'widgets/movie_card.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final app.SearchController _sc = Get.find<app.SearchController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            Expanded(child: _buildAllMovies()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () => _showSortSheet(ctx),
            icon: const Icon(Icons.tune_rounded, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: TextField(
          onChanged: _sc.onSearchChanged,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Search movies, categories...',
            hintStyle: TextStyle(color: AppTheme.textMuted),
            prefixIcon: Icon(Icons.search_rounded, color: AppTheme.accentBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildAllMovies() {
    return Obx(() {
      final list = _sc.filteredMovies;
      if (list.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  color: AppTheme.textMuted,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  _sc.searchQuery.value.isNotEmpty
                      ? 'No movies found'
                      : 'Start searching for movies',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.52,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) => MovieCard(
          movie: list[i],
          width: double.infinity,
          height: 160,
          onTap: () => Get.toNamed('/detail', arguments: list[i]),
        ),
      );
    });
  }

  void _showSortSheet(BuildContext ctx) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort Movies',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _sortTile('Default', 'default', Icons.restore_rounded),
            _sortTile('A → Z', 'az', Icons.sort_by_alpha_rounded),
            _sortTile('Z → A', 'za', Icons.sort_by_alpha_rounded),
            _sortTile('Newest First', 'newest', Icons.schedule_rounded),
            _sortTile('Highest Rating', 'rating', Icons.star_rounded),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String label, String mode, IconData icon) {
    return Obx(() {
      final sel = _sc.currentSortMode.value == mode;
      return ListTile(
        onTap: () {
          _sc.sortMovies(mode);
          Get.back();
        },
        leading: Icon(
          icon,
          color: sel ? AppTheme.accentBlue : AppTheme.textMuted,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: sel ? AppTheme.accentBlue : AppTheme.textPrimary,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        trailing: sel
            ? const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.accentBlue,
                size: 22,
              )
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: sel ? AppTheme.accentBlue.withValues(alpha: 0.1) : null,
      );
    });
  }
}
