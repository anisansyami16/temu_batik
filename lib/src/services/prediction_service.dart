import 'dart:io';
import 'dart:math';

import '../models/prediction_result.dart';

class PredictionService {
  Future<PredictionResult> predictBatik(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2));

    final dummyPredictions = [
      PredictionResult(
        motif: 'Mega Mendung',
        confidence: 0.92,
        origin: 'Cirebon',
        description:
            'Motif Mega Mendung memiliki pola awan berlapis yang khas.',
      ),
      PredictionResult(
        motif: 'Parang',
        confidence: 0.88,
        origin: 'Yogyakarta',
        description: 'Motif Parang melambangkan kekuatan dan kesinambungan.',
      ),
      PredictionResult(
        motif: 'Kawung',
        confidence: 0.85,
        origin: 'Jawa Tengah',
        description: 'Motif Kawung memiliki pola lingkaran simetris khas.',
      ),
    ];

    final random = Random();

    return dummyPredictions[random.nextInt(dummyPredictions.length)];
  }
}
