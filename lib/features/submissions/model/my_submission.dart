class MySubmissionModel {
  final String id;
  final String deviceId;
  final String airline;
  final DateTime date;
  final List<SubmittedAssessment> assessments;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  MySubmissionModel({
    required this.id,
    required this.deviceId,
    required this.airline,
    required this.date,
    required this.assessments,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MySubmissionModel.fromJson(Map<String, dynamic> json) {
    return MySubmissionModel(
      id: json['_id'] as String,
      deviceId: json['deviceId'] as String,
      airline: json['airline'] as String,
      date: DateTime.parse(json['date']),
      assessments: (json['assessments'] as List<dynamic>)
          .map((dynamic e) => SubmittedAssessment.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'deviceId': deviceId,
      'airline': airline,
      'date': date.toIso8601String(),
      'assessments': assessments.map((SubmittedAssessment e) => e.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'Submission(id: $id, deviceId: $deviceId, airline: $airline, status: $status, assessments: $assessments)';
}

class SubmittedAssessment {
  final String id;
  final String assessment;
  final String airline;
  final String submission;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubmittedAssessment({
    required this.id,
    required this.assessment,
    required this.airline,
    required this.submission,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubmittedAssessment.fromJson(Map<String, dynamic> json) {
    return SubmittedAssessment(
      id: json['_id'] as String,
      assessment: json['assessment'] as String,
      airline: json['airline'] as String,
      submission: json['submission'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'assessment': assessment,
      'airline': airline,
      'submission': submission,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Assessment(id: $id, assessment: $assessment)';
}
