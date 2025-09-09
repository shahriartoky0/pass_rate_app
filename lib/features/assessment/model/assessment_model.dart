class Assessment {
  final String id;
  final String assessment; // This represents the "assessment" name
  final String airline; // This represents the airline
  final int version;

  // Constructor to initialize the class properties
  Assessment({
    required this.id,
    required this.assessment,
    required this.airline,
    required this.version,
  });

  // Factory constructor to create an instance from a JSON object
  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['_id'], // The ID from the response
      assessment: json['name'], // The name (assessment) from the response
      airline: json['airline'], // The airline name from the response
      version: json['__v'], // The version field from the response (if needed)
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'_id': id, 'name': assessment, 'airline': airline, '__v': version};
  }
}
