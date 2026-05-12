import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/prediction_service.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  final Color primaryBrown = const Color(0xFF8B4A2F);
  final Color softCream = const Color(0xFFFFF8F3);

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> _goToPrediction() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih atau ambil foto batik terlebih dahulu'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final predictionService = PredictionService();
    final result = await predictionService.predictBatik(_selectedImage!);

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ResultScreen(imageFile: _selectedImage!, result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 40,
              right: -20,
              child: Icon(
                Icons.local_florist,
                size: 130,
                color: primaryBrown.withOpacity(0.45),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deteksi Batik',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D211D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unggah atau ambil foto batik untuk\nmengetahui motif dan penjelasannya',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.45,
                      color: Color(0xFF7A6A63),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.42),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: primaryBrown.withOpacity(0.55),
                          width: 1.4,
                        ),
                      ),
                      child: _selectedImage == null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: primaryBrown.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                      color: primaryBrown.withOpacity(0.35),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  const Text(
                                    'Belum ada gambar dipilih',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D211D),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Pilih gambar dari galeri atau ambil\nfoto dengan kamera',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.45,
                                      color: Color(0xFF6E625C),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.photo_library,
                          label: 'Galeri',
                          color: primaryBrown,
                          onTap: _pickImageFromGallery,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.camera_alt,
                          label: 'Kamera',
                          color: primaryBrown,
                          onTap: _takePhoto,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryBrown.withOpacity(0.20)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryBrown.withOpacity(0.90),
                          radius: 22,
                          child: const Icon(Icons.info, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Tips: Pastikan foto batik terlihat jelas agar hasil deteksi lebih akurat.',
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.35,
                              color: Color(0xFF4D3C35),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton.icon(
                      onPressed: _goToPrediction,
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.search),
                      label: const Text(
                        'Deteksi Motif',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.75)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: Colors.white.withOpacity(0.35),
        ),
      ),
    );
  }
}
