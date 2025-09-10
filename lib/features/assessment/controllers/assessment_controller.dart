import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/design/app_colors.dart';
import 'package:pass_rate/core/extensions/strings_extensions.dart';
import 'package:pass_rate/core/utils/device/device_info.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import '../../../core/common/widgets/custom_dropdown.dart';
import '../../../core/common/widgets/custom_toast.dart';
import '../../../core/config/app_url.dart';
import '../../../core/network/network_caller.dart';
import '../../../core/network/network_response.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/device/device_utility.dart';
import '../model/airline_model.dart';
import '../model/assessment_model.dart';
import '../model/submission_response.dart';

class AssessmentController extends GetxController {
  RxBool isLottieVisible = false.obs;
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  RxString selectedAirlineName = ''.obs;

  @override
  Future<void> onInit() async {
    await getAirlineNames();
    super.onInit();
  }

  ///================================> For the Airline Name section ==========================>
  final RxList<DropdownItem<String>> airlineNames = <DropdownItem<String>>[]
      .obs;

  Future<void> getAirlineNames() async {
    try {
      loader.value = true;
      final NetworkResponse postResponse = await NetworkCaller().getRequest(
          AppUrl.getAirlines);

      // Check if the response is successful
      if (postResponse.isSuccess) {
        final List<dynamic> data = postResponse.jsonResponse?['data'] ??
            <dynamic>[];

        // If data is not empty, process the airlines
        if (data.isNotEmpty) {
          // Clear the previous data before adding the new list of airline names
          airlineNames.clear();

          // Map the raw data to Airline models and add them to the RxList
          final List<Airline> airlines =
          data.map((dynamic json) => Airline.fromJson(json)).toList();
          for (final Airline airline in airlines) {
            airlineNames.add(
              DropdownItem<String>(
                  value: airline.name, label: airline.name.toCapitalize),
            );
          }
        } else {
          // Show a message if no data is found
          _showErrorMessage(AppStrings.noAirlineFound.tr);
        }
      } else {
        // Handle the case where the network request fails
        _showErrorMessage(AppStrings.networkError.tr);
      }
    } catch (e) {
      // Handle unexpected errors during the request or parsing
      LoggerUtils.debug("Error in getAirlineNames: $e");
      _showErrorMessage(AppStrings.unexpectedError.tr);
    } finally {
      loader.value = false;
    }
  }

  // Helper method to show an error message
  void _showErrorMessage(String message) {
    ToastManager.show(
      message: message,
      icon: const Icon(Icons.info_outline, color: Colors.red),
      backgroundColor: AppColors.white,
      textColor: Colors.red,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeInSine,
      duration: const Duration(seconds: 1),
    );
  }

  ///================================> For the Assessment section ==========================>

  final RxList<String> assessmentItemNames = <String>[].obs;

  Future<void> getAirlineAssessments({required String airlineName}) async {
    try {
      loader.value = true;
      assessmentResults.clear();
      final NetworkResponse postResponse = await NetworkCaller().getRequest(
        AppUrl.airlineAssessment(airlineName: airlineName),
      );

      // Check if the response is successful
      if (postResponse.isSuccess) {
        final List<dynamic> data = postResponse.jsonResponse?['data'] ??
            <dynamic>[];

        // If data is not empty, process the airlines
        if (data.isNotEmpty) {
          // Clear the previous data before adding the new list of airline names
          assessmentItemNames.clear();

          // Map the list of raw JSON objects to a list of Assessment objects
          final List<Assessment> assessments =
          data.map((dynamic json) => Assessment.fromJson(json)).toList();
          for (final Assessment assessment in assessments) {
            assessmentItemNames.add(assessment.assessment);
          }
        } else {
          // Show a message if no data is found
          _showErrorMessage(AppStrings.noAirlineFound.tr);
        }
      } else {
        // Handle the case where the network request fails
        _showErrorMessage(AppStrings.networkError.tr);
      }
    } catch (e) {
      // Handle unexpected errors during the request or parsing
      LoggerUtils.debug("Error in getAirlineNames: $e");
      _showErrorMessage(AppStrings.unexpectedError.tr);
    } finally {
      loader.value = false;
    }
  }

  // Map to store results for each assessment item by index
  final RxMap<int, String> assessmentResults = <int, String>{}.obs;

  void setAssessmentResult(int index, String status) {
    assessmentResults[index] = status;

    /// =========for lottie visibility logic =======>
    if (allAssessmentsCompleted) {
      isLottieVisible.value = true;
      Future<void>.delayed(const Duration(seconds: 2), () {
        isLottieVisible.value = false;
      });
    }
  }

  String? getAssessmentResult(int index) {
    return assessmentResults[index];
  }

  // Check if all assessments have been completed
  bool get allAssessmentsCompleted {
    return (assessmentResults.length == assessmentItemNames.length &&
        assessmentResults.isNotEmpty);
  }

  // Get completion percentage
  double get completionPercentage {
    return assessmentResults.length / assessmentItemNames.length;
  }

  ///===================> Submission Logic ================>
  Future<void> submitAssessment() async {
    submitLoader.value = true;
    try {
      if (allAssessmentsCompleted) {
        DeviceUtility.hapticFeedback();
        final String deviceID = await DeviceIdService.getDeviceId() ?? '';

        // Create the submission map
        final Map<String, dynamic> submissionData = <String, dynamic>{
          // "deviceId": deviceID,
          "deviceId": "#_#sd@#sd#-dfsdsdkdfshkdfj5ashrdssdsd@!!=",
          "selectedAirline": selectedAirlineName.value,
          "selectedYear": DateTime
              .now()
              .millisecondsSinceEpoch,
          "assessments": _buildAssessmentsArray(),
        };

        LoggerUtils.debug("Submission Data: ${jsonEncode(submissionData)}");

        final NetworkResponse response = await NetworkCaller().postRequest(
          AppUrl.postSubmission,
          body: submissionData,
        );

        if (response.statusCode == 200) {
          ToastManager.show(
            message: AppStrings.responsesSubmitted.tr,
            icon: const Icon(
                CupertinoIcons.check_mark_circled, color: AppColors.white),
          );


          /// Pass the submission model to the nect page
          final SubmissionResponse submissionResponse = SubmissionResponse
              .fromJson(
            response.jsonResponse ?? <String, dynamic>{},
          );
          // LoggerUtils.debug(submissionResponse.totalRate);

          /// After a successful submit the new page appear =====>
          Get.offNamed(
              AppRoutes.confirmSubmissionPage, arguments: submissionResponse);
        } else {
          ToastManager.show(
            message: response.jsonResponse?['error'] ??
                AppStrings.unexpectedError.tr,
            icon: const Icon(
                CupertinoIcons.info_circle_fill, color: AppColors.white),
            backgroundColor: AppColors.darkRed,
            textColor: AppColors.white,
          );
        }

        // LoggerUtils.debug(
        //   "This is the response ${response.jsonResponse} : and status code : ${response.statusCode}",
        // );
      } else {
        ToastManager.show(
          message: AppStrings.pleaseMarkAllTheAssessment.tr,
          icon: const Icon(
              CupertinoIcons.info_circle_fill, color: AppColors.white),
          backgroundColor: AppColors.darkRed,
          textColor: AppColors.white,
        );
      }
    } catch (e, stackTrace) {
      LoggerUtils.error("Error submitting assessment: $e\n$stackTrace");
      ToastManager.show(
        message: AppStrings.unexpectedError.tr,
        icon: const Icon(
            CupertinoIcons.info_circle_fill, color: AppColors.white),
        backgroundColor: AppColors.darkRed,
        textColor: AppColors.white,
      );
    } finally {
      submitLoader.value = false;
      // await resetAssessments();
    }
  }

  // Helper method to build assessments array
  List<Map<String, String>> _buildAssessmentsArray() {
    final List<Map<String, String>> assessments = <Map<String, String>>[];

    assessmentResults.forEach((int index, String status) {
      if (index < assessmentItemNames.length) {
        assessments.add(<String, String>{
          "name": assessmentItemNames[index],
          "status": status
        });
      }
    });

    return assessments;
  }

  ///================= Resets the page ==============>
  Future<void> resetAssessments() async {
    assessmentResults.clear();
    assessmentItemNames.clear();
    airlineNames.clear();
    selectedAirlineName.value = '';
    isLottieVisible.value = false;
    loader.value = false;
    submitLoader.value = false;
    await getAirlineNames();
  }
}
