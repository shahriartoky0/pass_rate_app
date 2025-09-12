import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pass_rate/core/config/app_asset_path.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/config/app_sizes.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/core/utils/custom_loader.dart';
import 'package:pass_rate/core/utils/enum.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import 'package:pass_rate/shared/widgets/app_button.dart';
import '../../../core/common/widgets/custom_dropdown.dart';
import '../../../core/common/widgets/custom_svg.dart';
import '../../../core/common/widgets/date_picker_field.dart';
import '../../../core/common/widgets/multi_select_drop_down.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_icons.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../controllers/assessment_controller.dart';
import '../widgets/custom_progress_bar.dart';

class SubmitAssessmentScreen extends GetView<AssessmentController> {
  SubmitAssessmentScreen({super.key});

  final List<MultiSelectItem<String>> assessmentItems = <MultiSelectItem<String>>[
    const MultiSelectItem(value: 'safety', label: 'Safety Briefing'),
    const MultiSelectItem(value: 'service', label: 'Customer Service'),
    const MultiSelectItem(value: 'food', label: 'Food and Beverages'),
    const MultiSelectItem(value: 'emergency', label: 'Emergency Procedures'),
    const MultiSelectItem(value: 'communication', label: 'Communication Skills'),
    const MultiSelectItem(value: 'teamwork', label: 'Teamwork'),
    const MultiSelectItem(value: 'grooming', label: 'Uniform & Grooming'),
    const MultiSelectItem(value: 'punctuality', label: 'Punctuality'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: AppStrings.submitResultTitle.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(AppStrings.submitResultTitle.tr, style: context.txtTheme.labelLarge),

            /// ============> Airline Name ==========>
            const SizedBox(height: AppSizes.xl),
            CustomDropdown<String>(
              label: AppStrings.airlineName.tr,
              isRequired: true,
              items: controller.airlineNames,
              hint: AppStrings.chooseAirlineName.tr,
              dropdownMaxHeight: 250,
              onChanged: (String? value) {
                controller.updateSelectedAirline(value);
              },
              validator: (String? value) {
                if (value == null) {
                  return 'Please select a type';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.lg),

            /// Select Year and Month ================ >
          ReusableDatePickerField(
            labelText: AppStrings.selectYearAndMonth.tr,
            hintText: AppStrings.chooseAssessmentYear.tr,
            controller: controller.assessmentDateTEController, // Use regular controller
            onDateSelected: (DateTime? selectedDate) {
              // LoggerUtils.debug("Date picker callback triggered with: $selectedDate");
              controller.onDateSelected(selectedDate);
            },
          ),
            const SizedBox(height: AppSizes.lg),

            MultiSelectDropdown<String>(
              items: assessmentItems,
              label: AppStrings.assessmentList.tr,
              onChanged: (List<String> selected) {
                controller.updateAssessmentList(selected);
                LoggerUtils.debug('Selected: $selected');
              },
            ),
            const SizedBox(height: AppSizes.lg),

            Obx(
              () => Row(
                spacing: 12,
                children: <Widget>[
                  Expanded(
                    child: passedFailedButton(
                      context: context,
                      onTap: () {
                        controller.assessmentStatusButtonSelected(ResultStatus.passed);
                      },
                      selected:
                          controller.resultStatus.value.displayName ==
                          ResultStatus.passed.displayName,
                      label: ResultStatus.passed.displayName,
                      iconPath: AppIcons.passedIcon,
                      tileColor: AppColors.green,
                    ),
                  ),
                  Expanded(
                    child: passedFailedButton(
                      context: context,
                      onTap: () {
                        controller.assessmentStatusButtonSelected(ResultStatus.failed);
                      },
                      selected:
                          controller.resultStatus.value.displayName ==
                          ResultStatus.failed.displayName,
                      label: ResultStatus.failed.displayName,
                      iconPath: AppIcons.failedIcon,
                      tileColor: AppColors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),
            Obx(() => SizedBox(height: controller.allAssessmentsCompleted ? 0 : AppSizes.xxxL)),

            /// Submit Button
            Obx(
              () =>
                  controller.allAssessmentsCompletedRx.value
                      ? Visibility(
                        visible: controller.submitLoader.value == false,
                        replacement: const CustomLoading(),
                        child: AppButton(
                          labelText: AppStrings.submit.tr,
                          onTap: () {
                            controller.submitAssessment();
                          },
                          bgColor: AppColors.primaryColor,
                          textColor: Colors.white,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => SizedBox(
          width: context.screenWidth * 0.9,
          child:
              controller.isLottieVisible.value
                  ? // Show only Lottie when visible
                  Lottie.asset(AppAssetPath.aeroplaneProgress, repeat: false)
                  : // Show progress bar when lottie not visible
                  AirplaneProgressIndicator(
                    progress: controller.completionPercentage,
                    completed: controller.completedSteps,
                    total: 4,
                    primaryColor: AppColors.primaryColor,
                  ),
        ),
      ),
    );
  }

  InkWell passedFailedButton({
    required BuildContext context,
    required String label,
    required String iconPath,
    required VoidCallback onTap,
    required bool selected,
    required Color tileColor,
  }) {
    return InkWell(
      splashColor: selected ? tileColor.withValues(alpha: 0.1) : Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: 0),
        decoration: BoxDecoration(
          color: selected ? tileColor.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(color: tileColor, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomSvgImage(assetName: iconPath, color: tileColor, height: 28),
            Text(
              label,
              style: context.txtTheme.labelMedium?.copyWith(
                color: tileColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
