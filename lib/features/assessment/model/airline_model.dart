class Airline {
  final String id;
  final String name;

  Airline({required this.id, required this.name});

  // Factory constructor to create an Airline instance from a JSON object
  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'_id': id, 'name': name};
  }
}
