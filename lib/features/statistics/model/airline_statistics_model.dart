class AirlineStatisticsModel {
  final int totalResponse;
  final double totalSuccessRate;
  final List<String> content;
  final DateTime date;
  final String name;

  AirlineStatisticsModel({
    required this.totalResponse,
    required this.totalSuccessRate,
    required this.content,
    required this.date,
    required this.name,
  });

  // Factory constructor to create an instance from JSON
  factory AirlineStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AirlineStatisticsModel(
      totalResponse: json['totalResponse'] as int,
      totalSuccessRate: (json['totalSuccessRate']as num? ?? -1 ).toDouble(),
      content: List<String>.from(json['content'] ?? <dynamic>[]),
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
    );
  }

  // Convert instance to JSON if needed
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalResponse': totalResponse,
      'totalSuccessRate': totalSuccessRate,
      'content': content,
      'date': date.toIso8601String(),
      'name': name,
    };
  }

  @override
  String toString() {
    return 'AirlineSubmission(totalResponse: $totalResponse, totalSuccessRate: $totalSuccessRate, content: $content, date: $date, name: $name)';
  }
}
