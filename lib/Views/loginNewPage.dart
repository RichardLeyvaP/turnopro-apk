// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginNewPage extends StatelessWidget {
  const LoginNewPage({super.key});
  //final TextEditingController _passController = TextEditingController();
  //final TextEditingController _usserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
              flex: 8,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/logo_negro_simplifies_trans.png',
                      ),
                      width: 300,
                      height: 600,
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFF18254), //todo
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              fontFamily: String.fromEnvironment(
                                  AutofillHints.addressCity)),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Estamos emocionados de tenerte como parte de nuestro equipo,para comenzar a trabajar presione QR SCANNER,si no estás trabajando y necesitas revisar tus estadisticas,agendas,etc. presione LOGIN',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        //vertical: 16.0,
                                        horizontal: 60.0), // Ajusta el padding
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  // Añadir más propiedades de estilo aquí
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    '/LoginFormPage',
                                  );
                                },
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        //vertical: 16.0,
                                        horizontal: 50.0), // Ajusta el padding
                                  ),
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 248, 246, 246)),
                                  // Añadir más propiedades de estilo aquí
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    '/QRViewExample',
                                  );
                                },
                                child: const Text(
                                  'QR SCANNER',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
