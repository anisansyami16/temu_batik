import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deteksi Batik')),
      body: const Center(child: Text('Upload atau ambil foto batik di sini')),
    );
  }
}
