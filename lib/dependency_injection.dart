import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinator.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';

class DependencyInjection {
  static void registerDependencies() {
    Get.put(LoginController());
    Get.put(StatisticController());
    Get.put(NotificationController());
    Get.put(ClientsScheduledController());
    Get.put(ClientsCoordinatorController());
    Get.put(ClientsTechnicalController());

    Get.put(PagesConfigController());
    Get.put(PagesConfigResponController());

    // Agrega más controladores según sea necesario
  }
}
