/// MovieModel - Parses JSON from MockAPI endpoint.
/// Fields use Indonesian naming from the API (judul, ringkasan, etc.)
class MovieModel {
  final String? id;
  final String judul;
  final String ringkasan;
  final String gambarPoster;
  final String gambarSampul;
  final int tanggalRilis;
  final double skorRating;
  final String kategori;
  final String urlTrailer;

  MovieModel({
    this.id,
    required this.judul,
    required this.ringkasan,
    required this.gambarPoster,
    required this.gambarSampul,
    required this.tanggalRilis,
    required this.skorRating,
    required this.kategori,
    required this.urlTrailer,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id']?.toString(),
      judul: json['judul'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      gambarPoster: json['gambar_poster'] ?? '',
      gambarSampul: json['gambar_sampul'] ?? '',
      tanggalRilis: _parseInt(json['tanggal_rilis']),
      skorRating: _parseDouble(json['skor_rating']),
      kategori: json['kategori'] ?? '',
      urlTrailer: json['url_trailer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'ringkasan': ringkasan,
      'gambar_poster': gambarPoster,
      'gambar_sampul': gambarSampul,
      'tanggal_rilis': tanggalRilis,
      'skor_rating': skorRating,
      'kategori': kategori,
      'url_trailer': urlTrailer,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  MovieModel copyWith({
    String? id,
    String? judul,
    String? ringkasan,
    String? gambarPoster,
    String? gambarSampul,
    int? tanggalRilis,
    double? skorRating,
    String? kategori,
    String? urlTrailer,
  }) {
    return MovieModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      ringkasan: ringkasan ?? this.ringkasan,
      gambarPoster: gambarPoster ?? this.gambarPoster,
      gambarSampul: gambarSampul ?? this.gambarSampul,
      tanggalRilis: tanggalRilis ?? this.tanggalRilis,
      skorRating: skorRating ?? this.skorRating,
      kategori: kategori ?? this.kategori,
      urlTrailer: urlTrailer ?? this.urlTrailer,
    );
  }
}
