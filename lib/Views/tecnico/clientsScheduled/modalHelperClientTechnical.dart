// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/env.dart';

final LoginController loginController = Get.find<LoginController>();
NotificationController notiController = Get.find<NotificationController>();

class ModalHelperTecnical {
  static showModalTechnical(PageController pageController, BuildContext context,
      String cliente, int reservationId, int carId, int idProf) async {
    String imageDirection =
        '${Env.apiEndpoint}/images/professional/ejemplo1.jpg';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return GetBuilder<ClientsTechnicalController>(
            builder: (controllClient) {
          return Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 130, 84),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controllClient.statusClientTemporary == 5
                        ? const Text(
                            '   Cliente',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18),
                          )
                        : const Text(
                            '   Cliente en Espera',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context); // Cierra el modal
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          weight: VisualDensity.maximumDensity,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 12, left: 12, bottom: 20),
                child: Container(
                  height: (MediaQuery.of(context).size.height * 0.075),
                  width: (MediaQuery.of(context).size.width * 0.95),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 223, 221, 221),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(imageDirection),
                                radius: 28, // Ajusta el tamaño del círculo aquí
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // controllClient
                                    //   .serviceCustomerSelected[index].name,
                                    cliente,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        80, // Ajusta la altura según sea necesario
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          167, 241, 131, 84),
                                      borderRadius: BorderRadius.circular(
                                          3), // La mitad de la altura para hacerlo circular
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'FRECUENTE',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: null,
                    ),
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  controllClient.statusClientTemporary ==
                          5 //solo si se esta atendiendo es que me muestra el botón de atendido
                      ? ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF2B3141)),
                          ),
                          onPressed: () async {
                            //llamo al ocntrolador y lo paso attended = 11 que significa que esta ya atendido y lo mando con el profesional
                            await controllClient.acceptClientTechnical(
                                reservationId, 11);
                            //AQUI ENVIAR NOTIFICACION AL PROFESIONAL QUE YA VA EL CLIENTE DE VUELTA PARA ACABAR EL SERVICIO
                            notiController.storeNotification(
                                'Cliente Regresando',
                                loginController.branchIdLoggedIn,
                                idProf,
                                ' El cliente $cliente ya está disponible para que continúes con el servicio');
                            Navigator.pop(context); // Cierra el modal
                          },
                          child: Row(
                            children: [
                              Icon(
                                MdiIcons.stop,
                                color: Colors.white,
                              ),
                              const Text(
                                'CLIENTE ATENDIDO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        )
                      : Text(''),
                ],
              )
            ],
          );
        });
      },
    );
  }
}
