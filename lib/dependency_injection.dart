import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.config.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';

class DependencyInjection {
  static void registerDependencies() {
    Get.put(LoginController());
    Get.put(StatisticController());
    Get.put(NotificationController());
    Get.put(ClientsScheduledController());
    Get.put(PagesConfigController());
    // Agrega más controladores según sea necesario
  }
}
