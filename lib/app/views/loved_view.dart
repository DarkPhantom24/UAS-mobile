import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/movie_controller.dart';
import '../theme/app_theme.dart';

class LovedView extends StatelessWidget {
  LovedView({super.key});
  final MovieController _mc = Get.find<MovieController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildWatchlist()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(Icons.favorite_rounded, color: AppTheme.accentCrimson, size: 32),
          SizedBox(width: 12),
          Text('Loved Movies', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildWatchlist() {
    return Obx(() {
      if (_mc.watchlist.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.heart_broken_rounded, color: AppTheme.textMuted, size: 64),
              SizedBox(height: 16),
              Text('Your watchlist is empty', style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        physics: const BouncingScrollPhysics(),
        itemCount: _mc.watchlist.length,
        itemBuilder: (_, i) {
          final m = _mc.watchlist[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.glassBorder),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              onTap: () => Get.toNamed('/detail', arguments: m),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: m.gambarPoster,
                  width: 55,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (c, u, e) => Container(width: 55, height: 80, color: AppTheme.scaffoldBg),
                ),
              ),
              title: Text(m.judul, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 16),
                    const SizedBox(width: 4),
                    Text(m.skorRating.toStringAsFixed(1), style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Text(m.kategori, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite_rounded, color: AppTheme.accentCrimson),
                onPressed: () => _mc.toggleWatchlist(m),
              ),
            ),
          );
        },
      );
    });
  }
}
