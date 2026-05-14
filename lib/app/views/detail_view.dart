import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../theme/app_theme.dart';

class DetailView extends StatelessWidget {
  DetailView({super.key});
  final MovieController _mc = Get.find<MovieController>();
  final AuthController _ac = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final MovieModel movie = Get.arguments as MovieModel;
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(context, movie),
          SliverToBoxAdapter(child: _buildBody(context, movie)),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext ctx, MovieModel movie) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: AppTheme.scaffoldBg,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        // Watchlist toggle
        Obx(() {
          final inList = _mc.isInWatchlist(movie.id);
          return GestureDetector(
            onTap: () => _mc.toggleWatchlist(movie),
            child: Container(
              margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)),
              child: Icon(inList ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: inList ? AppTheme.accentGold : Colors.white, size: 22),
            ),
          );
        }),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          Hero(
            tag: 'movie-poster-${movie.id}',
            child: CachedNetworkImage(
              imageUrl: movie.gambarSampul.isNotEmpty ? movie.gambarSampul : movie.gambarPoster,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) => Container(color: AppTheme.cardDark, child: const Icon(Icons.movie_outlined, color: AppTheme.textMuted, size: 64)),
            ),
          ),
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.transparent, AppTheme.scaffoldBg.withValues(alpha: 0.8), AppTheme.scaffoldBg],
          ))),
          Positioned(bottom: 20, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.accentBlue.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
              child: Text(movie.kategori, style: const TextStyle(color: AppTheme.accentBlue, fontSize: 12, fontWeight: FontWeight.w600))),
            const SizedBox(height: 8),
            Text(movie.judul, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
          ])),
        ]),
      ),
    );
  }

  Widget _buildBody(BuildContext ctx, MovieModel movie) {
    String dateStr;
    try {
      if (movie.tanggalRilis > 100000) {
        dateStr = DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(movie.tanggalRilis * 1000));
      } else {
        dateStr = movie.tanggalRilis.toString();
      }
    } catch (_) {
      dateStr = movie.tanggalRilis.toString();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Stats row
        Row(children: [
          _statChip(Icons.star_rounded, movie.skorRating.toStringAsFixed(0), AppTheme.accentGold),
          const SizedBox(width: 12),
          _statChip(Icons.calendar_today_rounded, dateStr, AppTheme.accentBlue),
        ]),
        const SizedBox(height: 24),
        // Synopsis
        const Text('Synopsis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        Text(movie.ringkasan, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.6)),
        const SizedBox(height: 24),
        // Poster preview
        const Text('Poster', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(imageUrl: movie.gambarPoster, height: 260, width: double.infinity, fit: BoxFit.cover,
            errorWidget: (c, u, e) => Container(height: 260, color: AppTheme.cardDark, child: const Center(child: Icon(Icons.broken_image, color: AppTheme.textMuted, size: 48)))),
        ),
        const SizedBox(height: 28),
        // Trailer button
        if (movie.urlTrailer.isNotEmpty)
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
            onPressed: () { Get.snackbar('Trailer', 'Opening: ${movie.urlTrailer}', backgroundColor: AppTheme.cardDark, colorText: Colors.white); },
            icon: const Icon(Icons.play_circle_rounded),
            label: const Text('Watch Trailer'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentBlue, foregroundColor: AppTheme.scaffoldBg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          )),
        const SizedBox(height: 16),
        // Admin actions
        Obx(() {
          if (!_ac.isAdmin.value) return const SizedBox.shrink();
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.glassBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.glassBorder)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.admin_panel_settings_rounded, color: AppTheme.accentCrimson, size: 22), SizedBox(width: 8), Text('Admin Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/admin-form', arguments: movie),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(ctx, movie),
                    icon: const Icon(Icons.delete_rounded, size: 18),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentCrimson, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  )),
                ]),
              ]),
            )),
          );
        }),
      ]),
    );
  }

  Widget _statChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  void _confirmDelete(BuildContext ctx, MovieModel movie) {
    Get.defaultDialog(
      title: 'Delete Movie',
      titleStyle: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700),
      middleText: 'Are you sure you want to delete "${movie.judul}"?',
      middleTextStyle: const TextStyle(color: AppTheme.textSecondary),
      backgroundColor: AppTheme.surfaceDark,
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          final ok = await _mc.deleteMovie(movie.id!);
          if (ok) Get.offAllNamed('/home');
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentCrimson),
        child: const Text('Delete', style: TextStyle(color: Colors.white)),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.textMuted)),
        child: const Text('Cancel', style: TextStyle(color: AppTheme.textPrimary)),
      ),
    );
  }
}
