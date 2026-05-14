import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/movie_model.dart';
import '../../theme/app_theme.dart';
import 'shimmer_loading.dart';

/// A premium movie poster card with Hero animation support.
class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 140,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with Hero animation
            Hero(
              tag: 'movie-poster-${movie.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: CachedNetworkImage(
                    imageUrl: movie.gambarPoster,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ShimmerCard(width: width, height: height),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.cardDark,
                      child: const Center(
                        child: Icon(Icons.movie_outlined,
                            color: AppTheme.textMuted, size: 36),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              movie.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            // Rating
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppTheme.accentGold, size: 14),
                const SizedBox(width: 4),
                Text(
                  movie.skorRating.toStringAsFixed(0),
                  style: const TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    movie.kategori,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
