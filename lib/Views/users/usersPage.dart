// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/main.controller.dart';

class UserPage extends GetView<MainController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de Api de prueba. '),
      ),
      body: _body(),
      bottomNavigationBar: GetBuilder<MainController>(
        builder: (add) => InkWell(
          child: const Icon(Icons.add),
          onTap: () {
            Get.snackbar(
              'MENSAJE',
              'AGREGADO CORECTAMENTE',
              duration: const Duration(milliseconds: 2000),
            );
            add.addUser();
          },
        ),
      ),
    );
  }

  _body() {
    return Center(
      child: GetBuilder<MainController>(
        builder: (_) => ListView.builder(
            itemCount: _.userListLength,
            itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(7),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      onLongPress: () {
                        Get.snackbar(
                          'ElIMINANDO CORRECTAMENTE',
                          _.users[index].name.toString(),
                          duration: const Duration(milliseconds: 2000),
                        );
                        _.deleteUser(index); // Llama a la función para eliminar
                      },
                      title: Text(_.users[index].name.toString()),
                      subtitle: Text(_.users[index].username.toString()),
                      selected: false,
                      //selectedColor: Colors.amber,
                      //selectedTileColor: Colors.blue,
                    ),
                  ),
                )),
      ),
    );
  }
}
