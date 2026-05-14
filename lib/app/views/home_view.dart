import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../theme/app_theme.dart';
import 'widgets/movie_card.dart';
import 'widgets/shimmer_loading.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final MovieController _mc = Get.find<MovieController>();
  final AuthController _ac = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: RefreshIndicator(
          onRefresh: _mc.fetchMovies,
          color: AppTheme.accentBlue,
          backgroundColor: AppTheme.cardDark,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: Obx(() {
                if (_mc.isLoading.value) return const Padding(padding: EdgeInsets.only(top: 16), child: ShimmerLoading());
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 16),
                  _buildHeroCarousel(),
                  const SizedBox(height: 28),
                  _buildSection('🔥 Trending Now', _mc.trendingMovies),
                  const SizedBox(height: 24),
                  _buildSection('🆕 New Releases', _mc.newReleases),
                  const SizedBox(height: 24),
                  _buildAllMovies(),
                  const SizedBox(height: 100),
                ]);
              })),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() => _ac.isAdmin.value
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed('/admin-form'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Movie', style: TextStyle(fontWeight: FontWeight.w700)),
            )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildAppBar(BuildContext ctx) {
    return SliverAppBar(
      floating: true, snap: true,
      backgroundColor: AppTheme.scaffoldBg.withValues(alpha: 0.85),
      flexibleSpace: ClipRRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(color: Colors.transparent))),
      title: Row(children: [
        Container(width: 36, height: 36, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.accentGradient), child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22)),
        const SizedBox(width: 10),
        const Text('CineVault', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      ]),
      actions: [
        IconButton(onPressed: () => _showWatchlist(ctx), icon: const Icon(Icons.bookmark_rounded, color: AppTheme.accentGold)),
        IconButton(onPressed: () => _showSortSheet(ctx), icon: const Icon(Icons.tune_rounded, color: AppTheme.textSecondary)),
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle_rounded, color: AppTheme.textSecondary),
          color: AppTheme.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onSelected: (v) { if (v == 'logout') _ac.logout(); },
          itemBuilder: (_) => [
            PopupMenuItem(enabled: false, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => Text(_ac.userEmail.value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13))),
              Obx(() => Text(_ac.isAdmin.value ? 'Admin' : 'User', style: TextStyle(color: _ac.isAdmin.value ? AppTheme.accentCrimson : AppTheme.accentBlue, fontSize: 12, fontWeight: FontWeight.w600))),
            ])),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout_rounded, color: AppTheme.accentCrimson, size: 20), SizedBox(width: 8), Text('Sign Out', style: TextStyle(color: AppTheme.textPrimary))])),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(
        decoration: BoxDecoration(color: AppTheme.glassBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.glassBorder)),
        child: TextField(onChanged: _mc.onSearchChanged, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(hintText: 'Search movies, categories...', hintStyle: TextStyle(color: AppTheme.textMuted), prefixIcon: Icon(Icons.search_rounded, color: AppTheme.accentBlue), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
      ))),
    );
  }

  Widget _buildHeroCarousel() {
    final f = _mc.featuredMovies;
    if (f.isEmpty) return const SizedBox.shrink();
    return SizedBox(height: 260, child: PageView.builder(
      itemCount: f.length, controller: PageController(viewportFraction: 0.88),
      onPageChanged: (i) => _mc.currentCarouselIndex.value = i,
      itemBuilder: (_, i) => _heroCard(f[i]),
    ));
  }

  Widget _heroCard(MovieModel m) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: m),
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Stack(fit: StackFit.expand, children: [
        CachedNetworkImage(imageUrl: m.gambarSampul.isNotEmpty ? m.gambarSampul : m.gambarPoster, fit: BoxFit.cover, placeholder: (c, u) => Container(color: AppTheme.cardDark), errorWidget: (c, u, e) => Container(color: AppTheme.cardDark, child: const Icon(Icons.movie_outlined, color: AppTheme.textMuted, size: 48))),
        Container(decoration: const BoxDecoration(gradient: AppTheme.heroOverlay)),
        Positioned(bottom: 20, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.accentBlue.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)), child: Text(m.kategori, style: const TextStyle(color: AppTheme.accentBlue, fontSize: 11, fontWeight: FontWeight.w600))),
          const SizedBox(height: 8),
          Text(m.judul, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 18), const SizedBox(width: 4), Text(m.skorRating.toStringAsFixed(0), style: const TextStyle(color: AppTheme.accentGold, fontSize: 14, fontWeight: FontWeight.w700))]),
        ])),
      ]))),
    );
  }

  Widget _buildSection(String title, List<MovieModel> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
      const SizedBox(height: 12),
      SizedBox(height: 260, child: ListView.builder(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), physics: const BouncingScrollPhysics(), itemCount: movies.length,
        itemBuilder: (_, i) => MovieCard(movie: movies[i], onTap: () => Get.toNamed('/detail', arguments: movies[i])),
      )),
    ]);
  }

  Widget _buildAllMovies() {
    return Obx(() {
      final list = _mc.filteredMovies;
      if (list.isEmpty && _mc.searchQuery.value.isNotEmpty) {
        return const Padding(padding: EdgeInsets.all(40), child: Center(child: Column(children: [Icon(Icons.search_off_rounded, color: AppTheme.textMuted, size: 48), SizedBox(height: 12), Text('No movies found', style: TextStyle(color: AppTheme.textMuted, fontSize: 16))])));
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_mc.searchQuery.value.isNotEmpty ? 'Search Results' : '🎬 All Movies', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text('${list.length} movies', style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        ])),
        const SizedBox(height: 12),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.52, mainAxisSpacing: 12, crossAxisSpacing: 12),
          itemCount: list.length, itemBuilder: (_, i) => MovieCard(movie: list[i], width: double.infinity, height: 160, onTap: () => Get.toNamed('/detail', arguments: list[i]))),
      ]);
    });
  }

  void _showSortSheet(BuildContext ctx) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.textMuted, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 20),
        const Text('Sort Movies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 16),
        _sortTile('Default', 'default', Icons.restore_rounded),
        _sortTile('A → Z', 'az', Icons.sort_by_alpha_rounded),
        _sortTile('Z → A', 'za', Icons.sort_by_alpha_rounded),
        _sortTile('Newest First', 'newest', Icons.schedule_rounded),
        _sortTile('Highest Rating', 'rating', Icons.star_rounded),
      ]),
    ));
  }

  Widget _sortTile(String label, String mode, IconData icon) {
    return Obx(() {
      final sel = _mc.currentSortMode.value == mode;
      return ListTile(onTap: () => _mc.sortMovies(mode), leading: Icon(icon, color: sel ? AppTheme.accentBlue : AppTheme.textMuted),
        title: Text(label, style: TextStyle(color: sel ? AppTheme.accentBlue : AppTheme.textPrimary, fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
        trailing: sel ? const Icon(Icons.check_circle_rounded, color: AppTheme.accentBlue, size: 22) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: sel ? AppTheme.accentBlue.withValues(alpha: 0.1) : null);
    });
  }

  void _showWatchlist(BuildContext ctx) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.6),
      decoration: const BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.textMuted, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 20),
        const Row(children: [Icon(Icons.bookmark_rounded, color: AppTheme.accentGold), SizedBox(width: 8), Text('My Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))]),
        const SizedBox(height: 16),
        Expanded(child: Obx(() {
          if (_mc.watchlist.isEmpty) return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bookmark_border_rounded, color: AppTheme.textMuted, size: 48), SizedBox(height: 12), Text('Your watchlist is empty', style: TextStyle(color: AppTheme.textMuted))]));
          return ListView.builder(itemCount: _mc.watchlist.length, itemBuilder: (_, i) {
            final m = _mc.watchlist[i];
            return ListTile(
              onTap: () { Get.back(); Get.toNamed('/detail', arguments: m); },
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: CachedNetworkImage(imageUrl: m.gambarPoster, width: 45, height: 65, fit: BoxFit.cover, errorWidget: (c, u, e) => Container(width: 45, height: 65, color: AppTheme.cardDark))),
              title: Text(m.judul, style: const TextStyle(color: AppTheme.textPrimary)),
              subtitle: Text(m.kategori, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, color: AppTheme.accentCrimson), onPressed: () => _mc.toggleWatchlist(m)),
            );
          });
        })),
      ]),
    ));
  }
}
