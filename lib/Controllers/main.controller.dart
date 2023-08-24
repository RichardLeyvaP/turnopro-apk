// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/get_connect/repository/main.repository.dart';
import 'package:turnopro_apk/Models/user_model.dart';

class MainController extends GetxController {
  UserRepository repository = UserRepository();
  Future<List<UserModel>> userList() async => await repository.getUserList();
}
