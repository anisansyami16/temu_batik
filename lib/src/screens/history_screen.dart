import 'dart:io';

import 'package:flutter/material.dart';

import '../models/prediction_history.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color primaryBrown = Color(0xFF8B4A2F);
  static const Color softCream = Color(0xFFFFF8F3);

  @override
  Widget build(BuildContext context) {
    final historyService = HistoryService();

    return Scaffold(
      backgroundColor: softCream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 34,
              right: -22,
              child: Icon(
                Icons.history,
                size: 128,
                color: primaryBrown.withOpacity(0.18),
              ),
            ),
            StreamBuilder<List<PredictionHistory>>(
              stream: historyService.getPredictionHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final histories = snapshot.data ?? [];

                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    MediaQuery.of(context).padding.bottom + 120,
                  ),
                  children: [
                    const Text(
                      'Riwayat',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D211D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Lihat hasil deteksi batik yang\npernah dilakukan sebelumnya',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.45,
                        color: Color(0xFF7A6A63),
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (histories.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: primaryBrown.withOpacity(0.18),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: 72,
                              color: Color(0xFFC6A99A),
                            ),
                            SizedBox(height: 18),
                            Text(
                              'Belum ada riwayat deteksi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D211D),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Riwayat hasil deteksi akan muncul di halaman ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Color(0xFF7A6A63),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (histories.isNotEmpty)
                      ...histories.map((PredictionHistory item) {
                        final confidence = (item.confidence * 100)
                            .toStringAsFixed(0);

                        final bool hasImage =
                            item.imagePath != null &&
                            File(item.imagePath!).existsSync();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(26),
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
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.58),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: primaryBrown.withOpacity(0.16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: primaryBrown.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: hasImage
                                        ? Image.file(
                                            File(item.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.image_search,
                                            color: primaryBrown,
                                            size: 34,
                                          ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.motif,
                                          style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF2D211D),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.origin,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF7A6A63),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryBrown.withOpacity(
                                              0.10,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Text(
                                            'Confidence $confidence%',
                                            style: const TextStyle(
                                              color: primaryBrown,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: primaryBrown.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
