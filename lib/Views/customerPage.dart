// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Components/BottomNavigationBar.dart';
import 'package:turnopro_apk/Controllers/customer.controller.dart';

class CustomersPage extends GetView<CustomerController> {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.person,
                  size: 70,
                ),
                Text(
                  'Mis Clientes',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.14),
            ),
          ],
        ),
        //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        elevation: 0, // Quits the shadow
        //shadowColor: Colors.amber, // Removes visual elevation
      ),
      body: Center(
        child: GetBuilder<CustomerController>(
          builder: (_) => _.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 241, 130, 84),
                ))
              : ListView.builder(
                  itemCount: _.customerListLength,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 10, top: 6, right: 10),
                    child: Container(
                      decoration: _.selectCustomer.contains(_.customers[index])
                          ? const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 231, 232, 234),
                                  Color.fromARGB(255, 243, 182, 138),
                                ],
                                stops: [0.0, 0.8],
                                begin: FractionalOffset.centerRight,
                                end: FractionalOffset.centerLeft,
                              ))
                          : const BoxDecoration(
                              color: Color.fromARGB(255, 240, 240, 238),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        onTap: () {
                          _.getselectCustomer(index);
                        },
                        onLongPress: () {
                          Get.snackbar(
                            'ElIMINANDO CORRECTAMENTE',
                            _.customers[index].name.toString(),
                            duration: const Duration(milliseconds: 2000),
                          );
                          _.deleteCustomer(
                              index); // Llama a la función para eliminar
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _.selectCustomer.contains(_.customers[index])
                                    ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Badge(
                                              label: Text('a'),
                                              child: Icon(
                                                Icons.access_time,
                                                color: Color.fromARGB(
                                                    255, 150, 37, 19),
                                              )),
                                          Text(
                                            '   01:53',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 150, 37, 19),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Badge(
                                              backgroundColor: Color.fromARGB(
                                                  255, 71, 143, 43),
                                              label: Text('+'),
                                              isLabelVisible: true,
                                              alignment: Alignment.bottomRight,
                                              child: Icon(
                                                Icons.access_time,
                                                color: Color.fromARGB(
                                                    255, 71, 143, 43),
                                              )),
                                          Text(
                                            '   08:10 - 09:10',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                Text(
                                  _.customers[index].name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'typeCut-${_.customers[index].username}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(129, 0, 0, 0)),
                                ),
                                Text(
                                  'typeWashed-${_.customers[index].username}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(129, 0, 0, 0)),
                                ),
                                Text(
                                  'typeWashed-${_.customers[index].id}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(129, 0, 0, 0)),
                                ),
                              ],
                            ),
                            _.selectCustomer.contains(_.customers[index])
                                ? const Row(
                                    children: [
                                      Opacity(
                                        opacity: 1,
                                        child: Icon(
                                          Icons.play_circle,
                                          size: 60,
                                          color:
                                              Color.fromARGB(255, 150, 37, 19),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    children: [
                                      Opacity(
                                        opacity: 1,
                                        child: Icon(
                                          Icons.play_circle,
                                          size: 60,
                                          color: Color.fromARGB(85, 83, 82, 82),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                        //subtitle: Text(_.users[index].username.toString()),
                        selected: false,
                        //selectedColor: Colors.amber,
                        //selectedTileColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BottomNavigationBarNew(),
      ),
    );
  }
}
