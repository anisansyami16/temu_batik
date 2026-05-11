import 'package:flutter/material.dart';

import '../models/prediction_history.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyService = HistoryService();

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: StreamBuilder<List<PredictionHistory>>(
        stream: historyService.getPredictionHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final histories = snapshot.data ?? [];

          if (histories.isEmpty) {
            return const Center(child: Text('Belum ada riwayat deteksi'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: histories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = histories[index];
              final confidencePercent = (item.confidence * 100).toStringAsFixed(
                0,
              );

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.image_search),
                  title: Text(item.motif),
                  subtitle: Text(
                    '${item.origin} • Confidence $confidencePercent%',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(item.motif),
                          content: Text(item.description),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
