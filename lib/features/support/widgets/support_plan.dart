import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_constants.dart';
import 'package:pass_rate/core/config/app_sizes.dart';
import 'package:pass_rate/core/design/app_colors.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';

class PlanOption {
  final String title;
  final String price;
  final bool isSelected;

  PlanOption({required this.title, required this.price, this.isSelected = false});
}

class SupportPlanSelector extends StatefulWidget {
  final List<PlanOption> plans;
  final Function(int)? onPlanSelected;


  const SupportPlanSelector({
    super.key,
    required this.plans,
    this.onPlanSelected,

  });

  @override
  State<SupportPlanSelector> createState() => _SupportPlanSelectorState();
}

class _SupportPlanSelectorState extends State<SupportPlanSelector> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppStrings.chooseASupportPlan.tr,
            style: context.txtTheme.titleMedium?.copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(height: AppSizes.md),

          Row(
            children: <Widget>[
              for (int i = 0; i < widget.plans.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == widget.plans.length - 1 ? 0 : 8),
                    child: _buildPlanCard(i),
                  ),
                ),
            ],
          ),


        ],
      ),
    );
  }

  Widget _buildPlanCard(int index) {
    final PlanOption plan = widget.plans[index];
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        widget.onPlanSelected?.call(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.xl),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Text(
              plan.price,
              style: context.txtTheme.headlineMedium?.copyWith(
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
