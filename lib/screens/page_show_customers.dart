// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:turnopro_apk/sidebar/MenuLateral.dart';
import 'package:turnopro_apk/components/BottomNavigationBar.dart';

class ShowCustomers extends StatelessWidget {
  const ShowCustomers({
    super.key,
    required this.name,
    required this.clicK,
    required this.typeCut,
    required this.typeWashed,
  });

  final String name;
  final int clicK;
  final String typeCut;
  final String typeWashed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Servicios',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        )),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        elevation: 0, // Quits the shadow
        //shadowColor: Colors.amber, // Removes visual elevation
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 212, 74),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_2),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Badge(
                                  label: Text('$clicK'),
                                  child: const Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 150, 37, 19),
                                  )),
                              const Text(
                                '   01:53',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 150, 37, 19),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.content_cut),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.wb_incandescent),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Icon(
                              Icons.play_circle,
                              size: 55,
                              color: Color.fromARGB(255, 163, 80, 80),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_2),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Badge(
                                  backgroundColor:
                                      Color.fromARGB(255, 71, 143, 43),
                                  label: Text('+'),
                                  isLabelVisible: true,
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 71, 143, 43),
                                  )),
                              Text(
                                '   08:10 - 09:10',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.content_cut),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.wb_incandescent),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.play_circle,
                              size: 55,
                              color: Color.fromARGB(255, 214, 214, 212),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_2),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Badge(
                                  backgroundColor:
                                      Color.fromARGB(255, 71, 143, 43),
                                  label: Text('+'),
                                  isLabelVisible: true,
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 71, 143, 43),
                                  )),
                              Text(
                                '   09:20 - 10:15',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.content_cut),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.wb_incandescent),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.play_circle,
                              size: 55,
                              color: Color.fromARGB(255, 214, 214, 212),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_2),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Badge(
                                  backgroundColor:
                                      Color.fromARGB(255, 71, 143, 43),
                                  label: Text('+'),
                                  isLabelVisible: true,
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 71, 143, 43),
                                  )),
                              Text(
                                '   11:00 - 12:00',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.content_cut),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.wb_incandescent),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.play_circle,
                              size: 55,
                              color: Color.fromARGB(255, 214, 214, 212),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const MenuLateral(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BottomNavigationBarNew(),
      ),
    );
  }
}
