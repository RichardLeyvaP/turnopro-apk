// // ignore_for_file: depend_on_referenced_packages

// import 'package:get/get.dart';
// import 'package:turnopro_apk/get_connect/repository/main.repository.dart';
// import 'package:turnopro_apk/Models/user_model.dart';

// class MainController extends GetxController {
//   MainController() {
//     if (yaEntre == false) {
//       _fetchUserList(); // Llamar al método asincrónico en el constructor
//       yaEntre = true;
//       update();
//     }
//   }
//   UserRepository repository = UserRepository();
//   bool yaEntre = false;
//   int numero = 5;
//   int userListLength = 0;
//   List<ServiceModel> users = []; // Lista de usuarios

//   getList() {
//     return users;
//   }

//   //Future<List<UserModel>> userList() async => await repository.getUserList();

//   Future<void> _fetchUserList() async {
//     users = await repository.getUserList();
//     userListLength = users.length;
//     update();
//   }

//   void addUser() {
//     ServiceModel newUser = ServiceModel(
//         id: 12, name: "Usuario $userListLength", username: "nuevouser");
//     users.add(newUser);
//     userListLength = users.length;
//     update();
//   }

//   void deleteUser(int index) {
//     if (index >= 0 && index < users.length) {
//       //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
//       //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
//       users.removeAt(index);
//       userListLength = users.length;
//       update();
//     }
//   }
// }
