import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_constants.dart';
import 'package:pass_rate/core/config/app_sizes.dart';
import 'package:pass_rate/core/design/app_colors.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import 'package:pass_rate/shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/support_controller.dart';
import '../widgets/support_plan.dart';

class SupportScreen extends GetView<SupportController> {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Column(
              children: <Widget>[
                const CustomAppBar(label: AppStrings.supportPassRate),
                const SizedBox(height: AppSizes.md),
                Text(
                  AppStrings.helpUsKeepTheAppFree.tr,
                  style: context.txtTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(AppStrings.yourSupportGoes.tr),
                bulletinText(bodyText: AppStrings.assessmentInsights.tr),
                bulletinText(bodyText: AppStrings.salaryComparisonData.tr),
                const SizedBox(height: AppSizes.sm),
                SupportPlanSelector(
                  plans: <PlanOption>[
                    PlanOption(title: 'Monthly', price: '€1/Month'),
                    PlanOption(title: 'Yearly', price: '€8/Year'),
                  ],
                  onPlanSelected: (int index) {
                    LoggerUtils.debug('Selected plan at index: $index');
                  },
                ),
                const SizedBox(height: AppSizes.sm),

                /// Proceed button ============>
                AppButton(labelText: AppStrings.proceed.tr, onTap: () {}),

                /// Proceed button lower part  ============>
                const SizedBox(height: AppSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      AppStrings.cancel,
                      style: context.txtTheme.labelSmall?.copyWith(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(AppStrings.thisIsOptional.tr, textAlign: TextAlign.start),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding bulletinText({required String bodyText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        spacing: AppSizes.md,
        children: <Widget>[
          Container(
            height: 5,
            width: 5,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          ),
          Text(bodyText),
        ],
      ),
    );
  }
}
