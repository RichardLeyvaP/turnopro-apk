// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinator.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class CoexistencePageCoordinator extends StatefulWidget {
  const CoexistencePageCoordinator({super.key});

  @override
  _CoexistencePageCoordinatorState createState() =>
      _CoexistencePageCoordinatorState();
}

final ClientsCoordinatorController controllerClient =
    Get.find<ClientsCoordinatorController>();
final LoginController controllerLogin = Get.find<LoginController>();
final PagesConfigController pagesConfigCont = Get.find<PagesConfigController>();

class _CoexistencePageCoordinatorState
    extends State<CoexistencePageCoordinator> {
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
                pagesConfigCont.back();
                // Navigator.pop(context);
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
                  Icons.stars,
                  size: 50,
                ),
                Text(
                  'Convivencias',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.14),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: GetBuilder<CoexistenceController>(builder: (controll) {
        List<ProfessionalModel> profesionales = controll.professional;
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    DropdownButton<ProfessionalModel>(
                      value: controll.selectedProfessional,
                      onChanged: (ProfessionalModel? newValue) {
                        setState(() {
                          controll.selectedProfessional = newValue;
                          if (newValue != null) {
                            print('${newValue.name}');
                            print('${newValue.id}');
                            int idProfessional = newValue.id;
                            controll.specificCoexistenceList(idProfessional);
                          }
                        });
                      },
                      items: [
                        const DropdownMenuItem<ProfessionalModel>(
                          value: null,
                          child: Text(' Seleccione un profesional '),
                        ),
                        ...profesionales
                            .map<DropdownMenuItem<ProfessionalModel>>(
                          (ProfessionalModel profesional) {
                            return DropdownMenuItem<ProfessionalModel>(
                              value: profesional,
                              child: Text(profesional.name),
                            );
                          },
                        ),
                      ].toList(),
                    ),
                  ],
                ),
              ),
            ),
            controll.selectedProfessional != null
                ? Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount: controll.coexistenceListLength,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          (MediaQuery.of(context).size.height * 0.013),
                          (MediaQuery.of(context).size.height * 0.006),
                          (MediaQuery.of(context).size.height * 0.013),
                          (MediaQuery.of(context).size.height * 0.006),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: InkWell(
                            onTap: () {
                              {
                                // Mostrar el modal al hacer clic en el botón
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          controll.coexistence[index].name
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          )),
                                      content: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Column(
                                          children: [
                                            // Opción 1
                                            SimpleDialogOption(
                                              onPressed: () {
                                                controllerClient
                                                    .changeNoncomplianceP(
                                                        controll
                                                            .coexistence[index]
                                                            .type,
                                                        controllerLogin
                                                            .branchIdLoggedIn,
                                                        controll
                                                            .selectedProfessional!
                                                            .id,
                                                        0);
                                                // Lógica para la opción 1
                                                Navigator.pop(context,
                                                    'Opción 1 seleccionada');
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      99, 244, 67, 54),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Incumplió'),
                                                      Icon(
                                                        Icons.star,
                                                        size: 30,
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Opción 2
                                            SimpleDialogOption(
                                              onPressed: () {
                                                controllerClient
                                                    .changeNoncomplianceP(
                                                        controll
                                                            .coexistence[index]
                                                            .type,
                                                        controllerLogin
                                                            .branchIdLoggedIn,
                                                        controll
                                                            .selectedProfessional!
                                                            .id,
                                                        1);
                                                // Lógica para la opción 2
                                                Navigator.pop(
                                                    context, 'Cumplió');
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      108, 76, 175, 79),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Cumplió'),
                                                      Icon(
                                                        Icons.star,
                                                        size: 30,
                                                        color: Color.fromARGB(
                                                            255, 10, 116, 13),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Botón de aceptar
                                      actions: [
                                        Center(
                                          child: Container(
                                            width: 100,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 10.0),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                              ),
                                              onPressed: () {
                                                // Lógica para el botón de aceptar
                                                Navigator.pop(
                                                    context, 'Cerrar');
                                              },
                                              child: const Center(
                                                child: Text(
                                                  'Cerrar',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: GetBuilder<ClientsScheduledController>(
                                builder: (controllerCient) {
                              return Row(
                                children: [
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height *
                                            0.11),
                                    width:
                                        (MediaQuery.of(context).size.width * 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(-5, 5),
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: ListTile(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.77,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controll
                                                          .coexistence[index]
                                                          .name
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    Text(
                                                      controll
                                                          .coexistence[index]
                                                          .description
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            148, 0, 0, 0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          controllerCient.noncomplianceProfessional[
                                                      controll
                                                          .coexistence[index]
                                                          .type] ==
                                                  0
                                              ? const Icon(
                                                  Icons.star,
                                                  color: Colors.red,
                                                  shadows: [
                                                    Shadow(
                                                        offset:
                                                            Offset(0.5, 0.9))
                                                  ],
                                                  size: 50,
                                                )
                                              : controllerCient
                                                              .noncomplianceProfessional[
                                                          controll
                                                              .coexistence[
                                                                  index]
                                                              .type] ==
                                                      1
                                                  ? const Icon(
                                                      Icons.star,
                                                      color: Color.fromRGBO(
                                                          26, 177, 71, 1),
                                                      shadows: [
                                                        Shadow(
                                                            offset: Offset(
                                                                0.5, 0.9))
                                                      ],
                                                      size: 50,
                                                    )
                                                  : const Icon(
                                                      Icons.star,
                                                      color: Color.fromRGBO(
                                                          145, 148, 145, 1),
                                                      shadows: [
                                                        Shadow(
                                                            offset: Offset(
                                                                0.5, 0.9))
                                                      ],
                                                      size: 50,
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controllerLogin.greeting,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const Icon(
                                Icons.auto_awesome,
                                size: 30,
                                color: Color.fromARGB(255, 236, 181, 14),
                                shadows: [Shadow(offset: Offset(0.3, 0.9))],
                              ),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Por favor ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                                TextSpan(
                                  text: controllerLogin.nameUserLoggedIn,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromARGB(255, 18, 41,
                                        71), // Cambia el color según tu preferencia
                                    fontWeight: FontWeight
                                        .bold, // Puedes ajustar otros estilos según tu preferencia
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      ', seleccione algún profesional y podrá modificar las reglas del mismo.',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
            //todo
            //AQUI PONER EL SINO HA SELECCIONADO A NADIE
          ],
        );
      }),
    );
  }
}
