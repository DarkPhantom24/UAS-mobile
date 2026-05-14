import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../theme/app_theme.dart';
import 'widgets/movie_card.dart';
import 'widgets/shimmer_loading.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final MovieController _mc = Get.find<MovieController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: RefreshIndicator(
        onRefresh: _mc.fetchMovies,
        color: AppTheme.accentBlue,
        backgroundColor: AppTheme.cardDark,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(child: Obx(() {
              if (_mc.isLoading.value) return const Padding(padding: EdgeInsets.only(top: 16), child: ShimmerLoading());
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 16),
                _buildHeroCarousel(),
                const SizedBox(height: 28),
                _buildSection('🔥 Trending Now', _mc.trendingMovies),
                const SizedBox(height: 24),
                _buildSection('🆕 New Releases', _mc.newReleases),
                const SizedBox(height: 100),
              ]);
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext ctx) {
    return SliverAppBar(
      floating: true, snap: true,
      backgroundColor: AppTheme.scaffoldBg,
      title: Row(children: [
        Container(width: 36, height: 36, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.accentGradient), child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22)),
        const SizedBox(width: 10),
        const Text('CineVault', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      ]),
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
}