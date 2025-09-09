import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pass_rate/core/config/app_asset_path.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/config/app_sizes.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/core/extensions/widget_extensions.dart';
import 'package:pass_rate/core/routes/app_routes.dart';
import 'package:pass_rate/core/utils/custom_loader.dart';
import 'package:pass_rate/core/utils/enum.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import 'package:pass_rate/shared/widgets/app_button.dart';
import '../../../core/common/widgets/custom_dropdown.dart';
import '../../../core/common/widgets/custom_svg.dart';
import '../../../core/common/widgets/date_picker_field.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_icons.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../controllers/assessment_controller.dart';
import '../widgets/custom_progress_bar.dart';

class SubmitAssessmentScreen extends GetView<AssessmentController> {
  SubmitAssessmentScreen({super.key});

  final TextEditingController _assessmentDateTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: AppStrings.submitResultTitle.tr,
        // onPressed: () {
        //   Get.offAllNamed(AppRoutes.homeRoute);
        // },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // CustomAppBar(label: AppStrings.submitResultTitle.tr),
            // const SizedBox(height: AppSizes.md),
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
                controller.getAirlineAssessments(airlineName: value ?? '');
                if (value != null) {
                  controller.selectedAirlineName.value = value;
                }
                // LoggerUtils.debug(controller.selectedAirlineName);
              },
              validator: (String? value) {
                if (value == null) {
                  return 'Please select a type';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.lg),

            /*            /// Select Year and Month ================ >
            ReusableDatePickerField(
              labelText: AppStrings.selectYearAndMonth.tr,
              hintText: AppStrings.chooseAssessmentYear.tr,
              controller: _assessmentDateTEController,
            ),
            const SizedBox(height: AppSizes.lg),*/

            /// Assessment Items List ================ >
            Obx(
              () => Visibility(
                replacement:
                    Lottie.asset(
                      ////========= Lottie color changed in a way  =====>
                      delegates: LottieDelegates(
                        values: <ValueDelegate>[
                          ValueDelegate.color(const <String>['**'], value: AppColors.primaryColor),
                        ],
                      ),
                      AppAssetPath.aeroplaneLoader,
                      height: context.screenHeight * 0.25,
                      backgroundLoading: true,
                    ).centered,
                visible: controller.loader.value == false,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        assessmentField(
                          context: context,
                          assessmentText: controller.assessmentItemNames[index],
                        ),
                        const SizedBox(height: AppSizes.md),

                        /// Pass/Fail buttons for each item
                        Obx(
                          () => Row(
                            spacing: 12,
                            children: <Widget>[
                              Expanded(
                                child: passedFailedButton(
                                  context: context,
                                  onTap: () {
                                    controller.setAssessmentResult(
                                      index,
                                      ResultStatus.passed.displayName,
                                    );
                                  },
                                  selected:
                                      controller.getAssessmentResult(index) ==
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
                                    controller.setAssessmentResult(
                                      index,
                                      ResultStatus.failed.displayName,
                                    );
                                  },
                                  selected:
                                      controller.getAssessmentResult(index) ==
                                      ResultStatus.failed.displayName,
                                  label: ResultStatus.failed.displayName,
                                  iconPath: AppIcons.failedIcon,
                                  tileColor: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, _) {
                    return const SizedBox(height: AppSizes.lg);
                  },
                  itemCount: controller.assessmentItemNames.length,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.xl),
            Obx(() => SizedBox(height: controller.allAssessmentsCompleted ? 0 : AppSizes.xxxL)),

            /// Submit Button
            Obx(
              () =>
                  controller.allAssessmentsCompleted
                      ? Visibility(
                        visible: controller.submitLoader.value == false,
                        replacement: const CustomLoading(),
                        child: AppButton(
                          labelText: AppStrings.submit.tr,
                          onTap: () {
                            controller.submitAssessment();
                          },
                          bgColor:
                              controller.allAssessmentsCompleted
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor.withValues(alpha: 0.5),
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
              (controller.allAssessmentsCompleted)
                  ? Visibility(
                    visible: controller.isLottieVisible.value,
                    child: Lottie.asset(AppAssetPath.aeroplaneProgress),
                  )
                  : controller.assessmentResults.isNotEmpty
                  ? AirplaneProgressIndicator(
                    progress: controller.completionPercentage,
                    completed: controller.assessmentResults.length,
                    total: controller.assessmentItemNames.length,
                    primaryColor: AppColors.primaryColor,
                  )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }

  TextFormField assessmentField({required BuildContext context, required String assessmentText}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppStrings.assessment.tr,
        labelStyle: context.txtTheme.headlineMedium?.copyWith(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: assessmentText,
        hintStyle: context.txtTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      readOnly: true,
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
