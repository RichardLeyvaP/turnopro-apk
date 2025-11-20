// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/ImageDetailScreen.dart';
import 'package:turnopro_apk/Views/tecnico/clientsScheduled/modalHelperClientTechnical.dart';
import 'package:turnopro_apk/env.dart';

import '../../../Controllers/clientsCoordinatorController.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AssignProfessional extends StatefulWidget {
  const AssignProfessional({super.key});

  @override
  State<AssignProfessional> createState() => _AssignProfessionalState();
}

class _AssignProfessionalState extends State<AssignProfessional> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final ClientsCoordinatorController clientCord =
      Get.find<ClientsCoordinatorController>();
  int cantVisitas = 3;

  List<String> direcc = [
    'assets/images/icons/montoGen.png',
    'assets/images/icons/propina.png',
    'assets/images/icons/80.png',
    'assets/images/icons/porcentageGan.png',
    'assets/images/icons/serviceRea.png',
    'assets/images/icons/serviceRegul.png',
    'assets/images/icons/serviceEsp.png',
    'assets/images/icons/montoEsp.png',
    'assets/images/icons/gananciaBar.png',
    'assets/images/icons/gananciaTot.png',
    'assets/images/icons/clientesAten.png',
    'assets/images/icons/seleccionado.png',
    'assets/images/icons/aleatorio.png',
  ];

  Icon icon = Icon(
    MdiIcons.tag,
  );
  final colorCont = Colors.white;
  double borderCont = 12;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsCoordinatorController>(builder: (controllerCoord) {
      return Scaffold(
        /* appBar: AppBar(
          toolbarHeight: 170,
          leading: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      pagesConfigCont.goToPage(
                          1, pagesConfigCont.pageController2);

                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width:
                      72.0, // Ajusta el tamaño del círculo según sea necesario
                  height: 72.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(76, 224, 224,
                        224), // Puedes ajustar el tono del gris según tus preferencias
                  ),
                ),
              )
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 43, 44, 49),
                        width:
                            2, // Ajusta el ancho del borde según tus preferencias
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      child: ClipOval(
                        child: Image.network(
                          '${Env.apiEndpoint}/images/${controllerCoord.imageLookCORD}',
                          fit: BoxFit
                              .cover, // Ajusta la imagen para cubrir completamente el área
                          width:
                              50, // Ancho deseado de la imagen dentro del círculo
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Si la imagen se carga correctamente, mostramos la imagen
                              return child;
                            } else {
                              // Si la imagen aún se está cargando, mostramos un indicador de progreso
                              return const CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                            if (kDebugMode) {
                              return CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors
                                    .transparent, // Fondo transparente para que el borde sea visible
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/default_profile.jpg',
                                    fit: BoxFit
                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                    width:
                                        50, // Ancho deseado de la imagen dentro del círculo
                                    height:
                                        50, // Alto deseado de la imagen dentro del círculo
                                  ),
                                ),
                              );
                            } else {
                              // Si no estamos en modo de depuración, mostramos un texto de error
                              return CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors
                                    .transparent, // Fondo transparente para que el borde sea visible
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/default_profile.jpg',
                                    fit: BoxFit
                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                    width:
                                        50, // Ancho deseado de la imagen dentro del círculo
                                    height:
                                        50, // Alto deseado de la imagen dentro del círculo
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Text(
                    controllerCoord.clientNameCORD,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  Text(
                    'Barbero Actual: ${controllerCoord.professActualNameCORD}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w100, fontSize: 11, height: 1.0),
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
        ),*/
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: GetBuilder<ClientsScheduledController>(
          builder: (_) {
            return 1 == 4 //aqui si no ha cargado aun mostrar el  indicador
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFDAE2A),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: SafeArea(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 5, right: 10, left: 10),
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0,
                                        3), // Cambia el desplazamiento de la sombra
                                  ),
                                ],
                                color: colorCont, //todo
                                borderRadius: BorderRadius.all(
                                    Radius.circular(borderCont)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      pagesConfigCont.goToPage(
                                          1, pagesConfigCont.pageController2);

                                      // Navigator.pop(context);
                                    },
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            //'${Env.apiEndpoint}/images/${controllerCoord.imageLookCORD}'
                                            radius: 25,
                                            backgroundColor: Colors
                                                .white, //fondo de la imagen
                                            child: GestureDetector(
                                              onDoubleTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageDetailScreen(
                                                            imageUrl:
                                                                '${dotenv.env['API_ENDPOINT']}/images/${controllerCoord.imageLookCORD}'),
                                                  ),
                                                );
                                              },
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${dotenv.env['API_ENDPOINT']}/images/${controllerCoord.imageLookCORD}',
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: const Center(
                                                      child: SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth:
                                                              2, // Personaliza el ancho del indicador como desees
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Color
                                                                      .fromARGB(
                                                                          110,
                                                                          253,
                                                                          176,
                                                                          42)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/default_profile.jpg',
                                                    cacheWidth: 30,
                                                    cacheHeight: 30,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        controllerCoord.clientNameCORD,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'Barbero Actual: ${controllerCoord.professActualNameCORD}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 11,
                                            height: 1.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                        0.14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 18, //cantidad aqui de profesionales disponibles
                        child: _.professionalDisponLength >
                                0 //todo si hay cargarlos aqui
                            ? ListView.builder(
                                padding: EdgeInsets
                                    .zero, // Elimina cualquier padding del ListView
                                itemCount: _.professionalDisponLength,
                                itemBuilder: (context, index) {
                                  // Utiliza la función cardOptions para construir cada Card
                                  return cardOptions(
                                      context,
                                      // Pasa aquí los datos necesarios para cardOptions
                                      icon,
                                      _.professionalDispon[index]
                                          .position, //todo aqui que me devuelva
                                      '${_.professionalDispon[index].name}  ${_.professionalDispon[index].surname}',
                                      _.professionalDispon[index].id,
                                      _.professionalDispon[index].image_url,
                                      _.professionalDispon[index].free);
                                },
                              )
                            : const Center(
                                child: Text('No hay Barberos disponibles'),
                              ),
                      ),
                    ],
                  );
          },
        ),
      );
    });
  }

  Padding cardOptions(
      BuildContext context, icon, title, name, idProfess, imageUrl, free) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 8, left: 10),
      child: Container(
        height: (MediaQuery.of(context).size.height * 0.1),
        width: (MediaQuery.of(context).size.width * 0.95),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white, //fondo de la imagen
                    child: ClipOval(
                      child: Image.network(
                        '${dotenv.env['API_ENDPOINT']}/images/$imageUrl',
                        fit: BoxFit
                            .cover, // Ajusta la imagen para cubrir completamente el área
                        width:
                            50, // Ancho deseado de la imagen dentro del círculo
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Si la imagen se carga correctamente, mostramos la imagen
                            return child;
                          } else {
                            // Si la imagen aún se está cargando, mostramos un indicador de progreso
                            return const CircularProgressIndicator(
                              color: Color(0xFFFDAE2A),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                          if (kDebugMode) {
                            return CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors
                                  .transparent, // Fondo transparente para que el borde sea visible
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/default_profile.jpg',
                                  fit: BoxFit
                                      .cover, // Ajusta la imagen para cubrir completamente el área
                                  width:
                                      50, // Ancho deseado de la imagen dentro del círculo
                                  height:
                                      50, // Alto deseado de la imagen dentro del círculo
                                ),
                              ),
                            );
                          } else {
                            // Si no estamos en modo de depuración, mostramos un texto de error
                            return CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors
                                  .transparent, // Fondo transparente para que el borde sea visible
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/default_profile.jpg',
                                  fit: BoxFit
                                      .cover, // Ajusta la imagen para cubrir completamente el área
                                  width:
                                      50, // Ancho deseado de la imagen dentro del círculo
                                  height:
                                      50, // Alto deseado de la imagen dentro del círculo
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  //
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      Container(
                        width: 80, // Ajusta la altura según sea necesario
                        decoration: BoxDecoration(
                          color: free.toString() == 'Libre'
                              ? const Color(0xFF19CF9E)
                              : const Color(0xFFFDAE2A),
                          borderRadius: BorderRadius.circular(
                              6), // La mitad de la altura para hacerlo circular
                        ),
                        child: Center(
                          child: Text(
                            free.toString(),
                            style: const TextStyle(
                              fontSize: 10,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Agrega un contenedor para alinear el icono al centro verticalmente

                  ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Ajusta el valor según sea necesario
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 26.0), // Ajusta el padding
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF4470F3)),

                        // Añadir más propiedades de estilo aquí
                      ),
                      onPressed: () async {
                        //(reservationId, clientId, professionalId)
                        int clientIdCORD = clientCord.clientIdCORD;
                        int reservationId = clientCord.idReservCORD;
                        //todo falta poner un cargando
                        clientCord.setLoading(true);
                        bool result = await clientCord.reasignedClientCoord(
                            reservationId,
                            clientIdCORD,
                            idProfess,
                            loginController.tokenUserLoggedIn);
                        if (result == true) {
                          Get.snackbar(
                            'Mensaje',
                            'Cliente reasignado correctamente',
                            duration: const Duration(milliseconds: 2500),
                            backgroundColor:
                                const Color.fromARGB(118, 255, 255, 255),
                            showProgressIndicator: true,
                            progressIndicatorBackgroundColor:
                                const Color.fromARGB(255, 203, 205, 209),
                            progressIndicatorValueColor:
                                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                            overlayBlur: 3,
                          );
                          //aqui actualizo la cola que se muestra en el home
                          await clientCord.fetchClientsScheduledBranch(
                              loginController.branchIdLoggedIn);
                          //  setLoading(value)
                          clientCord.setLoading(false);
                          print('Aqui lo mando al home despue de reasinarlo');
                          //aqui lo mando al home
                          //todo falta probarlo porque en el momento que se hizo no habia barberos disponibles
                          pagesConfigCont.pageController2
                              .jumpToPage(0); //AQUI VA  AL HOME
                          pagesConfigCont.showAppBar(true);

                          //ENVIAR UNA NOTIFICACION AL PROFESSIONAL //TODO 32:00
                        } else {
                          {
                            Get.snackbar(
                              'Error',
                              'Cliente no pudo ser reasignado,Inténtelo nuevamnete.',
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor: Color.fromARGB(118, 230, 30, 30),
                              showProgressIndicator: true,
                              progressIndicatorBackgroundColor:
                                  const Color.fromARGB(255, 203, 205, 209),
                              progressIndicatorValueColor:
                                  const AlwaysStoppedAnimation(
                                      Color.fromARGB(255, 250, 6, 6)),
                              overlayBlur: 3,
                            );
                          }
                        }
                      },
                      child: const Text(
                        'ASIGNAR',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )),
                ],
              ),
            ],
          ),
          subtitle: null,
        ),
      ),
    );
  }
}
