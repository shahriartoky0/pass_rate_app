class TopAirlineBySubmissionModel {
  final double count;
  final String name;

  TopAirlineBySubmissionModel({required this.count, required this.name});

  // Factory constructor to create an instance from JSON
  factory TopAirlineBySubmissionModel.fromJson(Map<String, dynamic> json) {
    return TopAirlineBySubmissionModel(
      count: (json['count'] as num).toDouble(),
      name: json['name'] as String,
    );
  }

  // Convert instance to JSON if needed
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'count': count, 'name': name};
  }

  @override
  String toString() {
    return 'AirlinePassRate(count: $count, name: $name)';
  }
}
