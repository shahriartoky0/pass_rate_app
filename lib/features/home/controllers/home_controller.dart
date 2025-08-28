import 'package:get/get.dart';
import 'package:pass_rate/core/config/app_constants.dart';
import 'package:pass_rate/core/utils/device/device_info.dart';
import 'package:pass_rate/core/utils/get_storage.dart';
import 'package:pass_rate/core/utils/logger_utils.dart';

class HomeController extends GetxController {

  @override
  Future<void> onInit() async {
    final String? deviceId = await DeviceIdService.getDeviceId();
    GetStorageModel().saveString(AppConstants.deviceId, deviceId ?? '');
    LoggerUtils.debug(GetStorageModel().getString(AppConstants.deviceId));
    // LoggerUtils.info(GetStorageModel().getString(AppConstants.deviceId));
    super.onInit();
  }

}
