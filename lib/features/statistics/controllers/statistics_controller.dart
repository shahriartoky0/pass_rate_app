import 'package:get/get.dart';
import 'package:pass_rate/core/common/widgets/custom_toast.dart';
import 'package:pass_rate/core/design/app_colors.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';
import 'package:pass_rate/features/statistics/model/top_airlines_submission_model.dart';
import '../../../core/config/app_url.dart';
import '../../../core/network/network_caller.dart';
import '../../../core/network/network_response.dart';
import '../model/top_airlines_pass_rate_model.dart';

class StatisticsController extends GetxController {
  // final TextEditingController assessmentDateTEController = TextEditingController();
  RxString statSearchAirlineName = ''.obs;
  final RxBool isLoadingPassRate = false.obs;
  final RxBool isLoadingSubmission = false.obs;
  RxString filterYearOfPassRate = ''.obs;
  RxString filterYearOfSubmission = ''.obs;
  RxString filterYearOfSubmissionCount = ''.obs;
  final RxList<TopAirlineByPassRateModel> topAirlinesByPassRate = <TopAirlineByPassRateModel>[].obs;
  final RxList<TopAirlineBySubmissionModel> topAirlinesBySubmission =
      <TopAirlineBySubmissionModel>[].obs;

  @override
  Future<void> onInit() async {
    await topAirlineByPassRate();
    await topAirlineBySubmission();
    super.onInit();
  }

  Future<void> topAirlineByPassRate() async {
    try {
      isLoadingPassRate.value = true;

      /// Setting the year if not selected ===== >
      if (filterYearOfPassRate.value.isEmpty) {
        filterYearOfPassRate.value = DateTime.now().year.toString();
      }
      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.topAirlinesByPassRate(year: filterYearOfPassRate.value),
      );
      final List<dynamic> jsonData = response.jsonResponse?['data'] ?? <dynamic>[];
      LoggerUtils.debug(jsonData);

      // Convert the list of maps to a list of AirlinePassRate objects
      topAirlinesByPassRate.value =
          jsonData.map((dynamic item) => TopAirlineByPassRateModel.fromJson(item)).toList();
    } catch (e) {
      ToastManager.show(
        message: e.toString(),
        backgroundColor: AppColors.darkRed,
        textColor: AppColors.white,
      );
      LoggerUtils.error(e);
    } finally {
      isLoadingPassRate.value = false;
    }
  }

  Future<void> topAirlineBySubmission() async {
    try {
      isLoadingSubmission.value = true;

      /// Setting the year if not selected ===== >
      if (filterYearOfSubmission.value.isEmpty) {
        filterYearOfSubmission.value = DateTime.now().year.toString();
      }
      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.topAirlinesBySubmission(year: filterYearOfSubmission.value),
      );
      final List<dynamic> jsonData = response.jsonResponse?['data'] ?? <dynamic>[];
      LoggerUtils.debug(jsonData);

      // Convert the list of maps to a list of AirlinePassRate objects
      topAirlinesBySubmission.value =
          jsonData.map((dynamic item) => TopAirlineBySubmissionModel.fromJson(item)).toList();
    } catch (e) {
      ToastManager.show(
        message: e.toString(),
        backgroundColor: AppColors.darkRed,
        textColor: AppColors.white,
      );
      LoggerUtils.error(e);
    } finally {
      isLoadingSubmission.value = false;
    }
  }

  /// [dispose] Lifecycle method called when the controller is destroyed.
  ///
  /// Cleans up by resetting loading states and clearing lists and more...
  @override
  void dispose() {
    super.dispose();
  }
}
