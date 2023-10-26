// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:turnopro_apk/Models/user_model.dart';

// class UserRepository extends GetConnect {
//   Future<List<ServiceModel>> getUserList() async {
//     List<ServiceModel> userList = [];
//     var url = 'http://jsonplaceholder.typicode.com/users';

//     final response = await get(url);
//     if (response.statusCode == 200) {
//       final users = response.body;
//       for (Map user in users) {
//         ServiceModel u = ServiceModel.fromJson(jsonEncode(user));
//         userList.add(u);
//       }
//       return userList;
//     } else {
//       return userList;
//     }
//   }
// }
