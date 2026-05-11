import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/prediction_history.dart';
import '../models/prediction_result.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePrediction(PredictionResult result) async {
    await _firestore.collection('predictions').add({
      'motif': result.motif,
      'confidence': result.confidence,
      'origin': result.origin,
      'description': result.description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<PredictionHistory>> getPredictionHistory() {
    return _firestore
        .collection('predictions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(PredictionHistory.fromFirestore).toList();
        });
  }
}
