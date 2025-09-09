class SubmissionResponse {
  final String airlineName;
  final DateTime selectedYear;
  final double totalRate;
  final double totalSuccessRate;

  SubmissionResponse({
    required this.airlineName,
    required this.selectedYear,
    required this.totalRate,
    required this.totalSuccessRate,
  });

  /// Factory constructor to parse JSON
  factory SubmissionResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? submission = json['submission'] as Map<String, dynamic>?;

    return SubmissionResponse(
      airlineName: submission?['selectedAirline'] as String? ?? '',
      selectedYear:
          submission?['selectedYear'] != null
              ? DateTime.parse(submission!['selectedYear'] as String)
              : DateTime.now(),
      totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
      totalSuccessRate: (json['totalSuccessRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert back to JSON if needed
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'airlineName': airlineName,
      'selectedYear': selectedYear.toIso8601String(),
      'totalRate': totalRate,
      'totalSuccessRate': totalSuccessRate,
    };
  }

  @override
  String toString() {
    return 'SubmissionResponse(airlineName: $airlineName, selectedYear: $selectedYear, totalRate: $totalRate, totalSuccessRate: $totalSuccessRate)';
  }
}
