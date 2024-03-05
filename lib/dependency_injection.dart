import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';

class DependencyInjection {
  static void registerDependencies() {
    Get.put(LoginController());
    Get.put(StatisticController());
    Get.put(NotificationController());
    Get.put(ClientsScheduledController());
    Get.put(ClientsCoordinatorController());
    Get.put(ClientsTechnicalController());
    Get.put(ServiceController());

    Get.put(PagesConfigController());
    Get.put(PagesConfigResponController());

    // Agrega más controladores según sea necesario
  }
}
