class PredictionResult {
  final String motif;
  final double confidence;
  final String origin;
  final String description;

  PredictionResult({
    required this.motif,
    required this.confidence,
    required this.origin,
    required this.description,
  });
}
