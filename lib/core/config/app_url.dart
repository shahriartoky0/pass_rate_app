class AppUrl {
  AppUrl._();

  static const String baseUrl = 'https://qemu-api.billal.space';
  static const String getAirlines = '$baseUrl/airlines';

  static String airlineAssessment({required String airlineName}) {
    return '$baseUrl/assessments/airline/$airlineName';
  }

  static const String postSubmission = '$baseUrl/submissions';

  static String topAirlinesByPassRate({String? year}) {
    return '$baseUrl/statistics/top-airlines-pass-rate?date=$year';
  }

  static String topAirlinesBySubmission({String? year}) {
    return '$baseUrl/statistics/top-airlines-submission?date=$year';
  }

  static String statSearchByAirline({required String airlineName}) =>
      '$baseUrl/statistics/airlines-overview?name=$airlineName';
}
