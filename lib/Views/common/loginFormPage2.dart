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

class LoginFormPage2 extends StatefulWidget {
  LoginFormPage2({super.key});

  @override
  State<LoginFormPage2> createState() => _LoginFormPage2State();
}

final ClientsScheduledController controllerClient =
    Get.find<ClientsScheduledController>();

class _LoginFormPage2State extends State<LoginFormPage2> {
  final LoginController controllerLogin = Get.find<LoginController>();

  final ClientsScheduledController clientContro =
      Get.find<ClientsScheduledController>();

  final LoginController loginController = Get.find<LoginController>();
  int branchIdLoggedIn = -99;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child: Scaffold(
        backgroundColor: const Color(0xFFF18254),
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
                      color: Colors.white, //todo
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 16, right: 16),
                    child: Column(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<BranchModel>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  MdiIcons.homeCircleOutline,
                                  color: Colors.white,
                                  size: (MediaQuery.of(context).size.height *
                                      0.04),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Seleccione la Sucursal',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Cambia el color del texto a blanco
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            value: controll.selectedBranch,
                            onChanged: (BranchModel? newValue) {
                              setState(() {
                                controll.selectedBranch = newValue;
                                print('result-newValue:${newValue}');

                                if (newValue != null) {
                                  print(
                                      'result-newValue-nameBranch:${newValue.nameBranch}');
                                  print(
                                      'result-newValue-branch_id:${newValue.branch_id}');
                                  //  print('${newValue.nameBranch}');
                                  //print('${newValue.branch_id}');

                                  //AQUI LLAMAR AL CONTROLADOR DEL LOGIN Y MANDARLE LA
                                  //Y MANDARLE EL USUSARIO Y
                                  setState(() {
                                    branchIdLoggedIn = newValue.branch_id;
                                  });
                                }
                              });
                            },
                            items: [
                              ...getBranch.map<DropdownMenuItem<BranchModel>>(
                                (BranchModel branchProf) {
                                  return DropdownMenuItem<BranchModel>(
                                    value: branchProf,
                                    child: Row(
                                      children: [
                                        Text(
                                          '  ${branchProf.nameBranch}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ].toList(),
                            buttonStyleData: ButtonStyleData(
                              height: 60,
                              width: (MediaQuery.of(context).size.width * 0.95),
                              padding: const EdgeInsets.only(
                                  top: 2, left: 14, right: 14, bottom: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color.fromARGB(255, 75, 24, 2),
                                ),
                                color: const Color(0xFFF18254),
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 340,
                              width: (MediaQuery.of(context).size.width * 0.80),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color.fromARGB(200, 241, 131, 84),
                              ),
                              offset: const Offset(40, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 50,
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, bottom: 5),
                            ),
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
                                            vertical: 12.0,
                                            horizontal: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12)), // Ajusta el padding
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 43, 44, 49)),
                                      // Añadir más propiedades de estilo aquí
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
                                            vertical: 12.0,
                                            horizontal: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12)), // Ajusta el padding
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 43, 44, 49)),
                                      // Añadir más propiedades de estilo aquí
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
                                            height: 26,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 241, 130, 84),
                                              strokeWidth: 4,
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
