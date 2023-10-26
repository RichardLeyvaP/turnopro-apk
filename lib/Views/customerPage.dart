// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Components/BottomNavigationBar.dart';
import 'package:turnopro_apk/Controllers/customer.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomersPage extends GetView<CustomerController> {
  CustomersPage({super.key});
  final List<String> nameClient = [
    'Alexis Campos',
    'Alejandro Hernandez',
    'Daniel Farias',
    'Gerardo Saucedo',
    'Miguel Romero',
    'Victor Días'
  ];
  final List<String> typeCurtClient = [
    'Pelado Normal',
    'Pintado de Cabello',
    'Corte de Barba',
    'Pelado de Corte bajo',
    'Pelado Normal',
    'Pelado y Corte de Barba'
  ];
  final List<String> typeCurt2Client = [
    'Afeitado de barba',
    'Corte de barba',
    'Corte de Barba',
    'Corte con diseño',
    'Afeitado clasico de barba',
    'Bigote,NariZ y Orejas'
  ];
  final List<String> hrClient = [
    '  08:10 - 09:15',
    '  09:17 - 10:10',
    '  10:12 - 10:55',
    '  10:58 - 11:45',
    '  11:50 - 12:30',
    '  02:00 - 03:15',
  ];

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
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 18,
                      child: ListView.builder(
                        itemCount: 6, //_.customerListLength,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.fromLTRB(
                              (MediaQuery.of(context).size.height * 0.013),
                              (MediaQuery.of(context).size.height * 0.006),
                              (MediaQuery.of(context).size.height * 0.013),
                              (MediaQuery.of(context).size.height * 0.006)),
                          child: Container(
                            decoration:
                                _.selectCustomer.contains(_.customers[index])
                                    ? BoxDecoration(
                                        border: Border.all(width: 0.01),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(-5,
                                                5), // Ajusta los valores para personalizar la sombra
                                          ),
                                        ],
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 231, 232, 234),
                                            Color.fromARGB(255, 243, 182, 138),
                                          ],
                                          stops: [0.0, 0.8],
                                          begin: FractionalOffset.centerRight,
                                          end: FractionalOffset.centerLeft,
                                        ))
                                    : BoxDecoration(
                                        border: Border.all(width: 0.01),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(-5,
                                                5), // Ajusta los valores para personalizar la sombra
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              // onTap: () {
                              //   _.getselectCustomer(index);
                              // },
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _.selectCustomer
                                              .contains(_.customers[index])
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  MdiIcons
                                                      .formatListNumbered, //todo
                                                  color: const Color.fromARGB(
                                                      255, 150, 37, 19),
                                                ),
                                                Text(
                                                  hrClient[index],
                                                  //  '   01:53',
                                                  style: const TextStyle(
                                                      height: 1.0,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 150, 37, 19),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  MdiIcons.clockPlus,
                                                  color: const Color.fromARGB(
                                                      255, 71, 143, 43),
                                                ),
                                                Text(
                                                  hrClient[index],
                                                  // '   08:10 - 09:10',
                                                  style: const TextStyle(
                                                    height: 1.0,
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                        180, 0, 0, 0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      Text(
                                        nameClient[index],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        typeCurtClient[index],
                                        //'typeCut-${_.customers[index].username}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(148, 0, 0, 0),
                                          height: 1.0,
                                        ),
                                      ),
                                      Text(
                                        typeCurt2Client[index],
                                        // 'typeWashed-${_.customers[index].username}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(148, 0, 0, 0),
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      )
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
                                                color: Color.fromARGB(
                                                    255, 150, 37, 19),
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
                                                color: Color.fromARGB(
                                                    85, 83, 82, 82),
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
                  ],
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
