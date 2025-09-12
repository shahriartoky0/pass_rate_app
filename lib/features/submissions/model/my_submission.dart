class MySubmissionModel {
  String submissionTime;
  String id;
  String selectedAirline;
  List<AssessmentModel> assessments;

  MySubmissionModel({
    required this.submissionTime,
    required this.selectedAirline,
    required this.assessments,
    required this.id,
  });

  factory MySubmissionModel.fromJson(Map<String, dynamic> json) {
    return MySubmissionModel(
      submissionTime: json['submissionTime'],
      selectedAirline: json['selectedAirline'],
      assessments:
          (json['assessments'] as List<dynamic>)
              .map((dynamic assessment) => AssessmentModel.fromJson(assessment))
              .toList(),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'submissionTime': submissionTime,
      'selectedAirline': selectedAirline,
      'id': id,
      'assessments': assessments.map((AssessmentModel assessment) => assessment.toJson()).toList(),
    };
  }
}

class AssessmentModel {
  String name;
  String status;

  AssessmentModel({required this.name, required this.status});

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(name: json['name'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'status': status};
  }
}
