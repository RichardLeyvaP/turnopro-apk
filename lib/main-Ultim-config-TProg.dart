// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
// import 'package:turnopro_apk/app_initializer.dart';
// import 'package:turnopro_apk/dependency_injection.dart';
// import 'package:turnopro_apk/myApp.dart';
// import 'package:turnopro_apk/providers.dart';
// import 'package:turnopro_apk/services/background_task_service.dart';
// import 'package:turnopro_apk/services/localNotification.dart';

// void main() async {
//   DependencyInjection.registerDependencies();
//   await AppInitializer.initializeApp();

//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeNotificationsNew();
//   await LocalStorage.configurePrefs();

//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()!
//       .requestNotificationsPermission();

//   BackgroundTaskService backgroundTaskService = BackgroundTaskService();
//   backgroundTaskService.initializeWorkManager();

//   runApp(
//     MultiProvider(
//       providers: providers,
//       child: Myapp(),
//     ),
//   );
// }
