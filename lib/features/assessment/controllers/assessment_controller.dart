import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_asset_path.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/design/app_colors.dart';

import '../../../core/common/widgets/custom_dropdown.dart';
import '../../../core/common/widgets/custom_toast.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/device/device_utility.dart';

class AssessmentController extends GetxController {
  RxBool isLottieVisible = false.obs;

  // Airline Names Demo Data
  final RxList<DropdownItem<String>> airlineNames =
      <DropdownItem<String>>[
        const DropdownItem<String>(value: 'emirates', label: 'Emirates'),
        const DropdownItem<String>(value: 'qatar', label: 'Qatar Airways'),
        const DropdownItem<String>(value: 'lufthansa', label: 'Lufthansa'),
        const DropdownItem<String>(value: 'british', label: 'British Airways'),
        const DropdownItem<String>(value: 'singapore', label: 'Singapore Airlines'),
        const DropdownItem<String>(value: 'american', label: 'American Airlines'),
        const DropdownItem<String>(value: 'delta', label: 'Delta Air Lines'),
        const DropdownItem<String>(value: 'united', label: 'United Airlines'),
        const DropdownItem<String>(value: 'air_france', label: 'Air France'),
        const DropdownItem<String>(value: 'klm', label: 'KLM Royal Dutch Airlines'),
        const DropdownItem<String>(value: 'turkish', label: 'Turkish Airlines'),
        const DropdownItem<String>(value: 'etihad', label: 'Etihad Airways'),
        const DropdownItem<String>(value: 'cathay', label: 'Cathay Pacific'),
        const DropdownItem<String>(value: 'ana', label: 'All Nippon Airways'),
        const DropdownItem<String>(value: 'jal', label: 'Japan Airlines'),
      ].obs;

  // Assessment Items Demo Data
  final RxList<DropdownItem<String>> assessmentItems =
      <DropdownItem<String>>[
        const DropdownItem<String>(value: 'safety_briefing', label: 'Safety Briefing'),
        const DropdownItem<String>(value: 'emergency_procedures', label: 'Emergency Procedures'),
        const DropdownItem<String>(value: 'customer_service', label: 'Customer Service'),
        const DropdownItem<String>(value: 'cabin_preparation', label: 'Cabin Preparation'),
        const DropdownItem<String>(value: 'food_service', label: 'Food & Beverage Service'),
        const DropdownItem<String>(value: 'boarding_process', label: 'Boarding Process'),
        const DropdownItem<String>(value: 'communication_skills', label: 'Communication Skills'),
        const DropdownItem<String>(value: 'conflict_resolution', label: 'Conflict Resolution'),
        const DropdownItem<String>(value: 'first_aid', label: 'First Aid Knowledge'),
        const DropdownItem<String>(value: 'uniform_grooming', label: 'Uniform & Grooming'),
        const DropdownItem<String>(value: 'teamwork', label: 'Teamwork'),
        const DropdownItem<String>(value: 'punctuality', label: 'Punctuality'),
        const DropdownItem<String>(value: 'language_skills', label: 'Language Skills'),
        const DropdownItem<String>(value: 'cultural_awareness', label: 'Cultural Awareness'),
        const DropdownItem<String>(value: 'technical_knowledge', label: 'Technical Knowledge'),
      ].obs;

  // List of assessment items with their names
  final List<String> assessmentItemNames = <String>[
    'Food and Beverages',
    'Safety Briefing',
    'Emergency Procedures',
    'Customer Service',
    'Cabin Preparation',
    'Boarding Process',
    'Communication Skills',
    'Conflict Resolution',
    'First Aid Knowledge',
    'Uniform & Grooming',
    'Teamwork',
    'Punctuality',
  ];

  // Map to store results for each assessment item by index
  final RxMap<int, String> assessmentResults = <int, String>{}.obs;

  void setAssessmentResult(int index, String status) {
    assessmentResults[index] = status;
    if (allAssessmentsCompleted) {
      isLottieVisible.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        isLottieVisible.value = false;
      });
    }
  }

  String? getAssessmentResult(int index) {
    return assessmentResults[index];
  }

  // Check if all assessments have been completed
  bool get allAssessmentsCompleted {
    return assessmentResults.length == assessmentItemNames.length;
  }

  // Get completion percentage
  double get completionPercentage {
    return assessmentResults.length / assessmentItemNames.length;
  }

  ///===================> Submission Logic ================>
  void submitAssessment() {
    if (allAssessmentsCompleted) {
      DeviceUtility.hapticFeedback();
      Get.toNamed(AppRoutes.confirmSubmissionPage);
    } else {
      ToastManager.show(
        message: AppStrings.pleaseMarkAllTheAssessment.tr,
        icon: const Icon(CupertinoIcons.info_circle_fill, color: AppColors.white),
        backgroundColor: AppColors.darkRed,
        textColor: AppColors.white,
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.easeInSine,
        duration: const Duration(seconds: 1),
      );
    }
  }
}
