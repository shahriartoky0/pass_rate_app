class TopAirlineByPassRateModel {
  final double passRate;
  final String airline;

  TopAirlineByPassRateModel({required this.passRate, required this.airline});

  // Factory constructor to create an instance from JSON
  factory TopAirlineByPassRateModel.fromJson(Map<String, dynamic> json) {
    return TopAirlineByPassRateModel(
      passRate: (json['passRate'] as num).toDouble(),
      airline: json['airline'] as String,
    );
  }

  // Convert instance to JSON if needed
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'passRate': passRate, 'airline': airline};
  }

  @override
  String toString() {
    return 'AirlinePassRate(airline: $airline, passRate: $passRate)';
  }
}
