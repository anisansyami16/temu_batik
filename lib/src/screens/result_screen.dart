import 'dart:io';

import 'package:flutter/material.dart';

import '../models/prediction_result.dart';
import '../services/history_service.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile;
  final PredictionResult result;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final HistoryService _historyService = HistoryService();

  bool _isSaving = false;
  bool _isSaved = false;

  Future<void> _saveToHistory() async {
    if (_isSaved) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _historyService.savePrediction(widget.result);

      if (!mounted) return;

      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hasil deteksi berhasil disimpan')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan hasil: $error')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (widget.result.confidence * 100).toStringAsFixed(
      0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Deteksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(widget.imageFile),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.result.motif,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Confidence $confidencePercent%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Asal: ${widget.result.origin}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.result.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving || _isSaved ? null : _saveToHistory,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isSaved ? Icons.check : Icons.save),
                label: Text(_isSaved ? 'Sudah Disimpan' : 'Simpan Riwayat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
