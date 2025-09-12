import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/core/extensions/strings_extensions.dart';
import 'package:pass_rate/core/extensions/widget_extensions.dart';
import 'package:pass_rate/features/submissions/model/my_submission.dart';
import '../../../core/common/widgets/custom_modal.dart';
import '../../../core/common/widgets/custom_svg.dart';
import '../../../core/config/app_sizes.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_icons.dart';
import '../../../core/utils/enum.dart';
import '../../../shared/widgets/app_button.dart' show AppButton;

class SubmissionTile extends StatelessWidget {
  final String submitDate;
  final String name;
  final VoidCallback onDelete;
  final List<AssessmentModel> assessments;

  const SubmissionTile({
    super.key,
    required this.submitDate,
    required this.name,
    required this.onDelete,
    required this.assessments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor,),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(name, style: context.txtTheme.titleMedium)),
              Material(
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  splashColor: AppColors.greyLight,
                  onTap: (){
                    /// =================> Open the Delete Modal ===============>
                    CustomBottomSheet.show(
                      title: AppStrings.deleteTitle.tr,
                      context: context,
                      child: Column(
                        children: <Widget>[
                          Row(
                            spacing: AppSizes.md,
                            children: <Widget>[
                              Expanded(
                                child: AppButton(
                                  bgColor: AppColors.primaryColor,
                                  textColor: AppColors.white,
                                  labelText: AppStrings.yes.tr,
                                  onTap: () {
                                    onDelete();
                                    Navigator.pop(context);

                                  },
                                ),
                              ),
                              Expanded(
                                child: AppButton(
                                  textColor: AppColors.primaryColor,
                                  labelText: AppStrings.no.tr,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(CupertinoIcons.delete, color: AppColors.red),
                  ),
                ),
              ),
            ],
          ),
          Text(
            submitDate,
            style: context.txtTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: AppSizes.lg),

          Visibility(
            visible: assessments.isNotEmpty,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.greyLight),
              ),
              child: Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(7),
                  1: FlexColumnWidth(3),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: AppColors.black.withValues(alpha: 0.2)),
                  verticalInside: BorderSide(color: AppColors.black.withValues(alpha: 0.3)),
                ),
                children: <TableRow>[
                  // Header row
                  TableRow(
                    decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Text(
                              AppStrings.assessment.tr,
                              style: context.txtTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ).centered,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Text(
                              AppStrings.status.tr,
                              style: context.txtTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ).centered,
                      ),
                    ],
                  ),
                  // Data rows
                  ...assessments.map(
                    (AssessmentModel assessment) => TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            assessment.name.toCapitalize,
                            style: context.txtTheme.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: _buildStatusChip(assessment.status)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final bool isPassed = status == ResultStatus.passed.displayName;

    return IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 60,
          maxWidth: 100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isPassed ? AppColors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isPassed ? AppColors.green : Colors.red, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                status,
                style: TextStyle(
                  color: isPassed ? AppColors.green : AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            CustomSvgImage(
              assetName: isPassed ? AppIcons.passedIcon : AppIcons.failedIcon,
              height: 12,
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
