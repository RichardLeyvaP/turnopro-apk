// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
//import 'package:turnopro_apk/sidebar/MenuLateral.dart';
import 'package:turnopro_apk/Components/BottomNavigationBar.dart';

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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.stop_circle,
                              size: 60,
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
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 231, 232, 234),
                        Color.fromARGB(255, 243, 182, 138),
                      ],
                      stops: [0.0, 0.8],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.play_circle,
                              size: 60,
                              color: Color.fromARGB(255, 182, 43, 22),
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
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.stop_circle,
                              size: 60,
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
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 231, 232, 234),
                        Color.fromARGB(255, 243, 182, 138),
                      ],
                      stops: [0.0, 0.8],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.play_circle,
                              size: 60,
                              color: Color.fromARGB(255, 182, 43, 22),
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
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.stop_circle,
                              size: 60,
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
                height: (MediaQuery.of(context).size.height * 0.17),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 238),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            typeCut,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            typeWashed,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Icon(
                              Icons.stop_circle,
                              size: 60,
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
          ],
        ),
      ),
      //drawer: const MenuLateral(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BottomNavigationBarNew(),
      ),
    );
  }
}
