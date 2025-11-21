// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:turnopro_apk/Models/branch_model.dart';

class SelectProfessionalPage extends StatefulWidget {
  SelectProfessionalPage({super.key});

  @override
  State<SelectProfessionalPage> createState() => _SelectProfessionalPageState();
}

final ClientsScheduledController controllerClient =
    Get.find<ClientsScheduledController>();

class _SelectProfessionalPageState extends State<SelectProfessionalPage> {
  final LoginController controllerLogin = Get.find<LoginController>();

  final ClientsScheduledController clientContro =
      Get.find<ClientsScheduledController>();

  final LoginController loginController = Get.find<LoginController>();
  int branchIdLoggedIn = -99;
  String? selectedOption; // Variable para almacenar la opción seleccionada
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDAE2A),
        appBar: AppBar(
          toolbarHeight: 30.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GetBuilder<CoexistenceController>(builder: (controll) {
          List<BranchModel> getBranch = controll.branchProfessional;
          return Column(
            children: [
              const Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/logo_black_simplifies_trans.png',
                        ),
                        width: 260,
                        height: 600,
                      ),
                    ],
                  )),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 204, 89, 89),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 16, right: 16),
                    child: Column(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Seleccione cómo va a entrar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            value: selectedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOption =
                                    newValue; // Actualiza la opción seleccionada
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Barbero',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.store,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                    Text(
                                      '  Barbero',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Encargado',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.store,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                    Text(
                                      '  Encargado',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        GetBuilder<LoginController>(builder: (contLog) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //CANCELAR
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 192, 191, 191)),
                                    ),
                                    onPressed: () async {
                                      controll.branchProfessional.clear();
                                      controll.selectedBranch = null;
                                      Get.offAllNamed('/LoginFormPage');
                                    },
                                    child: const Text(
                                      'CANCELAR',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    )),
                              ),
                              //ACEPTAR
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFF4470F3)),
                                    ),
                                    onPressed: () async {
                                      if (branchIdLoggedIn != -99) {
                                        await controllerLogin
                                            .loadingValue(true);
                                        String email = controllerLogin.uss;
                                        String password = controllerLogin.pass;
                                        controll.branchProfessional = [];
                                        controll.selectedBranch = null;
                                        controllerLogin.loginGetIn(
                                            email, password, branchIdLoggedIn);
                                      }
                                    },
                                    child: contLog.isLoading
                                        ? Container(
                                            width: 22,
                                            height: 22,
                                            child:
                                                const CircularProgressIndicator(
                                              color: const Color(0xFFFDAE2A),
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text(
                                            ' ENTRAR',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                          )),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              //AQUI PONER EL SINO HA SELECCIONADO A NADIE
            ],
          );
        }),
      ),
    );
  }
}
