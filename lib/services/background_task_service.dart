// import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:get/get.dart';

// class BackgroundTaskService {
//   void initializeWorkManager() {
//     Workmanager().initialize(
//       callbackDispatcher,
//       isInDebugMode: true,
//     );
//   }

//   void registerOneOffTask(
//       String type, int branchId, int professionalId, int estado) {
//     Workmanager().registerOneOffTask(
//       "1",
//       "simpleOneOffTask",
//       inputData: <String, dynamic>{
//         'type': type,
//         'branchId': branchId.toString(),
//         'professionalId': professionalId.toString(),
//         'estado': estado.toString(),
//       },
//     );
//   }

//   static void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       print("Native called background task: $task");

//       // Verificamos que inputData no sea nulo antes de acceder a sus valores
//       if (inputData != null) {
//         // Aquí obtenemos los datos pasados desde la tarea de WorkManager
//         final String? type = inputData['type'];
//         final int? branchId = int.tryParse(inputData['branchId'] ?? '');
//         final int? professionalId =
//             int.tryParse(inputData['professionalId'] ?? '');
//         final int? estado = int.tryParse(inputData['estado'] ?? '');

//         if (type != null &&
//             branchId != null &&
//             professionalId != null &&
//             estado != null) {
//           // Aquí llamamos al método de tu controlador para hacer la llamada a la API
//           final ClientsScheduledController clientsScheduledController =
//               Get.put(ClientsScheduledController());
//           clientsScheduledController.changeNoncomplianceP2(
//             type,
//             branchId,
//             professionalId,
//             estado,
//           );
//         }
//       }

//       // No es necesario registrar una nueva tarea, ya que WorkManager se encarga de eso automáticamente para tareas únicas

//       return Future.value(true);
//     });
//   }
// }
