// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/professional/shoppingCartPage.dart';
import 'package:turnopro_apk/Views/responsible/homeResponsiblePage.dart';

class RoutesConfig {
  static List<GetPage<dynamic>> getRoutes() {
    return [
      GetPage(
        name: '/SplashPage',
        page: () => const SplashPage(),
      ),
      GetPage(
        name: '/StatisticPage',
        page: () => const StatisticPage(),
        binding: BindingsBuilder.put(() => StatisticController()),
      ),
      GetPage(
        name: '/Professional',
        page: () => const HomePages(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/HomeResponsible',
        page: () => const HomeResponsiblePages(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/loginNewPage',
        page: () => LoginNewPage(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),
      GetPage(
        name: '/LoginFormPage',
        page: () => LoginFormPage(),
        binding: BindingsBuilder.put(() => LoginController()),
      ),

      GetPage(
        name: '/servicesProductsPage',
        page: () => const ServicesProductsPage(),
      ), //ESTA ESTA CARGANDO UNA API
      GetPage(
        name: '/NotificationsPageNew',
        page: () => NotificationsPageNew(),
        binding: BindingsBuilder.put(() => NotificationController()),
      ),
      GetPage(
        name: '/NotificationsPageProf',
        page: () => NotificationsPageProf(),
        binding: BindingsBuilder.put(() => NotificationController()),
      ),
      GetPage(
        name: '/clients',
        page: () => const ClientsScheduled(),
        binding: BindingsBuilder.put(() => ClientsScheduledController()),
      ), //ESTA ESTA CARGANDO UNA API
      GetPage(
        name: '/CoexistencePage',
        page: () => const CoexistencePage(),
        binding: BindingsBuilder.put(() => CoexistenceController()),
      ),
      GetPage(name: '/Error', page: () => const Page404()),
      GetPage(name: '/AuthCheck', page: () => const AuthCheck()),
      // GetPage(name: '/CodeQrPage', page: () => const CodeQrPage()),
      GetPage(name: '/QRViewExample', page: () => const QRViewPage()),
      GetPage(name: '/ShoppingCartPage', page: () => ShoppingCartPage()),
    ];
  }
}
