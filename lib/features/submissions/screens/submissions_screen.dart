import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pass_rate/core/config/app_sizes.dart';
import 'package:pass_rate/core/config/app_strings.dart';
import 'package:pass_rate/core/extensions/context_extensions.dart';
import 'package:pass_rate/core/extensions/widget_extensions.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import 'package:pass_rate/shared/widgets/slide_animation.dart';
import '../../../core/config/app_asset_path.dart';
import '../../../core/design/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart' show CustomAppBar;
import '../../../shared/widgets/lottie_loader.dart';
import '../controllers/submissions_controller.dart';
import '../model/my_submission.dart';
import '../widget/submission_tile.dart';

class SubmissionsScreen extends GetView<SubmissionsController> {
  const SubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: AppStrings.mySubmission.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSizes.md),

            /// Search field  ====>
            TextFormField(
              controller: controller.searchTEController,
              decoration: InputDecoration(
                hintText: AppStrings.search.tr,
                prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            ///=====================> Search button ===============>
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                ),
                onPressed: () {},
                label: Text(AppStrings.search.tr, style: const TextStyle(color: AppColors.white)),
                // icon: const Icon(Icons.search,size: 32,color: AppColors.white,),
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            /// Submission Container  ====>
            Expanded(
              child: Obx(
                () => Visibility(
                  replacement: const LottieLoaderWidget().centered,
                  visible: controller.loader.value == false,
                  child: ListView.separated(
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.mySubmissions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final MySubmissionModel submission = controller.mySubmissions[index];
                      LoggerUtils.debug(submission.submissionTime);
                      // Parse the input string to a DateTime object
                      final DateTime date = DateTime.parse(submission.submissionTime);

                      // Format the date as "yyyy - Month .."
                      final String formattedDate = DateFormat('yyyy - MMMM').format(date);
                      return SlideAnimation(
                        delay: Duration(seconds: index * 2),
                        child: SubmissionTile(
                          submitDate: formattedDate,
                          name: submission.selectedAirline,
                          onDelete: () {
                            controller.handleDelete(submission: submission);
                          },
                          assessments: submission.assessments,
                        ),
                      );
                    },

                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: AppSizes.md);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
