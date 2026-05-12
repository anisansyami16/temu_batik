import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionHistory {
  final String id;
  final String motif;
  final double confidence;
  final String origin;
  final String description;
  final String? imagePath;
  final DateTime createdAt;

  PredictionHistory({
    required this.id,
    required this.motif,
    required this.confidence,
    required this.origin,
    required this.description,
    required this.imagePath,
    required this.createdAt,
  });

  factory PredictionHistory.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return PredictionHistory(
      id: doc.id,
      motif: data['motif'] ?? '',
      confidence: (data['confidence'] ?? 0).toDouble(),
      origin: data['origin'] ?? '',
      description: data['description'] ?? '',
      imagePath: data['imagePath'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
