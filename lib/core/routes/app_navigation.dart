import 'package:get/get.dart';
import 'package:pass_rate/core/routes/app_routes.dart';
import 'package:pass_rate/features/assessment/bindings/assessment_binding.dart';
import 'package:pass_rate/features/assessment/screens/confirm_screen.dart';
import 'package:pass_rate/features/home/bindings/home_binding.dart';
import 'package:pass_rate/features/statistics/bindings/statistics_binding.dart';
import 'package:pass_rate/features/statistics/screens/statistics_screen.dart';
import 'package:pass_rate/features/statistics/screens/view_statistics.dart';
import 'package:pass_rate/features/submissions/bindings/submissions_binding.dart';
import 'package:pass_rate/features/submissions/screens/submissions_screen.dart';
import 'package:pass_rate/features/support/bindings/support_binding.dart';
import 'package:pass_rate/features/support/screens/support_screen.dart';
import '../../features/assessment/screens/submit_assessment_screen.dart';
import '../../features/home/screens/home_screen.dart';

class AppNavigation {
  AppNavigation._();

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    /// Add the pages like this ================>
    GetPage<dynamic>(
      name: AppRoutes.initialRoute,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.homeRoute,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.submissionPage,
      page: () => SubmissionsScreen(),
      binding: SubmissionsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.supportPage,
      page: () => const SupportScreen(),
      binding: SupportBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.submitAssessment,
      page: () => SubmitAssessmentScreen(),
      binding: AssessmentBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.confirmSubmissionPage,
      page: () => const ConfirmSubmissionPage(),
      binding: AssessmentBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.statisticsScreen,
      page: () => StatisticsScreen(),
      binding: StatisticsBinding(),
    ),  GetPage<dynamic>(
      name: AppRoutes.viewStatisticsScreen,
      page: () => ViewStatistics(),
      binding: StatisticsBinding(),
    ),
  ];
}
