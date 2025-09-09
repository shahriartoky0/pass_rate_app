import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/common/widgets/custom_modal.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/shared/widgets/app_button.dart';
import '../../../core/common/widgets/custom_svg.dart';
import '../../../core/config/app_sizes.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_icons.dart';
import '../../../core/utils/enum.dart';

class SubmissionTile extends StatelessWidget {
  final String bodyText;
  final String name;
  final String resultStatus;
  final VoidCallback onDelete;

  const SubmissionTile({
    super.key,
    required this.bodyText,
    required this.name,
    required this.resultStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                splashColor: Colors.grey,
                onTap: () {
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
          ),
          const SizedBox(height: AppSizes.sm),
          Align(alignment: Alignment.center, child: Text(bodyText)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name, style: context.txtTheme.titleMedium),
              Row(
                spacing: 5,
                children: <Widget>[
                  CustomSvgImage(
                    assetName:
                        resultStatus == ResultStatus.passed.displayName
                            ? AppIcons.passedIcon
                            : AppIcons.failedIcon,
                    height: 22,
                  ),
                  Text(
                    resultStatus,
                    style: context.txtTheme.headlineMedium?.copyWith(
                      color:
                          resultStatus == ResultStatus.passed.displayName
                              ? AppColors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
