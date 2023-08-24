// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/main.controller.dart';
import 'package:turnopro_apk/Models/user_model.dart';

class UserPage extends GetView<MainController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de Api de prueba. '),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: FutureBuilder(
          future: controller.userList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('ERROR');
            } else if (snapshot.hasData) {
              final List<UserModel> user = snapshot.data as List<UserModel>;
              return ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.all(7),
                        child: ListTile(
                          title: Text(user[index].name.toString()),
                          subtitle: Text(user[index].username.toString()),
                        ),
                      ));
            }
            return const Center();
          }),
    );
  }
}
