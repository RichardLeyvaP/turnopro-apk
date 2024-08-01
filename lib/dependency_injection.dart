import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/services/connectivity_service.dart';

class DependencyInjection {
  static void registerDependencies() {
    Get.put(ConnectivityService());
    Get.put(LoginController(), permanent: true);
    Get.put(ClientsScheduledController(), permanent: true);
    Get.put(ClientsTechnicalController());
    Get.put(ShoppingCartController());
    Get.put(StatisticController());
    Get.put(NotificationController());
    Get.put(ClientsCoordinatorController());
    Get.put(ClientsTechnicalController());
    Get.put(ServiceController());
    Get.put(CoexistenceController());

    Get.put(PagesConfigController());
    Get.put(PagesConfigResponController());
    Get.put(ProductController());

    // Agrega más controladores según sea necesario
  }
}
