import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../theme/app_theme.dart';

class AdminFormView extends StatefulWidget {
  const AdminFormView({super.key});
  @override
  State<AdminFormView> createState() => _AdminFormViewState();
}

class _AdminFormViewState extends State<AdminFormView> {
  final MovieController _mc = Get.find<MovieController>();
  final _formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  late final TextEditingController _judulCtrl;
  late final TextEditingController _ringkasanCtrl;
  late final TextEditingController _posterCtrl;
  late final TextEditingController _sampulCtrl;
  late final TextEditingController _rilisCtrl;
  late final TextEditingController _ratingCtrl;
  late final TextEditingController _kategoriCtrl;
  late final TextEditingController _trailerCtrl;

  MovieModel? _editMovie;
  bool get _isEdit => _editMovie != null;

  @override
  void initState() {
    super.initState();
    _editMovie = Get.arguments as MovieModel?;
    _judulCtrl = TextEditingController(text: _editMovie?.judul ?? '');
    _ringkasanCtrl = TextEditingController(text: _editMovie?.ringkasan ?? '');
    _posterCtrl = TextEditingController(text: _editMovie?.gambarPoster ?? '');
    _sampulCtrl = TextEditingController(text: _editMovie?.gambarSampul ?? '');
    _rilisCtrl = TextEditingController(text: _editMovie?.tanggalRilis.toString() ?? '');
    _ratingCtrl = TextEditingController(text: _editMovie?.skorRating.toStringAsFixed(0) ?? '');
    _kategoriCtrl = TextEditingController(text: _editMovie?.kategori ?? '');
    _trailerCtrl = TextEditingController(text: _editMovie?.urlTrailer ?? '');
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _ringkasanCtrl.dispose();
    _posterCtrl.dispose();
    _sampulCtrl.dispose();
    _rilisCtrl.dispose();
    _ratingCtrl.dispose();
    _kategoriCtrl.dispose();
    _trailerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBg,
        title: Text(_isEdit ? 'Edit Movie' : 'Add New Movie', style: const TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Get.back()),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.glassBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    // Header
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppTheme.accentCrimson.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Icon(_isEdit ? Icons.edit_rounded : Icons.add_rounded, color: AppTheme.accentCrimson),
                      ),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_isEdit ? 'Edit Movie Details' : 'New Movie Entry', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                        const Text('Fill in all required fields', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                      ]),
                    ]),
                    const SizedBox(height: 28),
                    _field('Title (Judul)', _judulCtrl, Icons.movie_outlined, required: true),
                    _field('Synopsis (Ringkasan)', _ringkasanCtrl, Icons.description_outlined, maxLines: 4, required: true),
                    _field('Poster Image URL', _posterCtrl, Icons.image_outlined, required: true),
                    _field('Cover Image URL', _sampulCtrl, Icons.panorama_outlined),
                    _field('Release Date (Unix)', _rilisCtrl, Icons.calendar_today_rounded, keyboard: TextInputType.number, required: true),
                    _field('Rating Score', _ratingCtrl, Icons.star_outline_rounded, keyboard: TextInputType.number, required: true),
                    _field('Category', _kategoriCtrl, Icons.category_outlined, required: true),
                    _field('Trailer URL', _trailerCtrl, Icons.play_circle_outline_rounded),
                    const SizedBox(height: 24),
                    // Submit
                    Obx(() => SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading.value ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading.value
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                            : Text(_isEdit ? 'Update Movie' : 'Add Movie', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    )),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, TextInputType? keyboard, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.textMuted),
          prefixIcon: Icon(icon, color: AppTheme.accentBlue, size: 20),
        ),
        validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _isLoading.value = true;
    final movie = MovieModel(
      judul: _judulCtrl.text.trim(),
      ringkasan: _ringkasanCtrl.text.trim(),
      gambarPoster: _posterCtrl.text.trim(),
      gambarSampul: _sampulCtrl.text.trim(),
      tanggalRilis: int.tryParse(_rilisCtrl.text.trim()) ?? 0,
      skorRating: double.tryParse(_ratingCtrl.text.trim()) ?? 0,
      kategori: _kategoriCtrl.text.trim(),
      urlTrailer: _trailerCtrl.text.trim(),
    );
    bool ok;
    if (_isEdit) {
      ok = await _mc.updateMovie(_editMovie!.id!, movie);
    } else {
      ok = await _mc.createMovie(movie);
    }
    _isLoading.value = false;
    if (ok) Get.offAllNamed('/home');
  }
}
