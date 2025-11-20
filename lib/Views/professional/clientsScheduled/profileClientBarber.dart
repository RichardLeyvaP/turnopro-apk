// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/ImageDetailScreen.dart';
import 'package:turnopro_apk/env.dart';

import '../../../Controllers/clientsScheduled.controller.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileClientBarber extends StatefulWidget {
  const ProfileClientBarber({super.key});

  @override
  State<ProfileClientBarber> createState() => _ProfileClientBarberState();
}

class _ProfileClientBarberState extends State<ProfileClientBarber> {
  TextEditingController commentController = TextEditingController();
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final ClientsScheduledController clientSchedControl =
      Get.find<ClientsScheduledController>();
  final ClientsCoordinatorController clientCoordControl =
      Get.find<ClientsCoordinatorController>();
  final LoginController loginControl = Get.find<LoginController>();

  int cantVisitas = 3;

  String title = 'Servicios';
  Icon icon = Icon(
    MdiIcons.tag,
    color: const Color.fromARGB(211, 0, 0, 0),
  );
  Icon iconService = Icon(
    MdiIcons.server,
    color: const Color.fromARGB(211, 0, 0, 0),
  );

  get closedCompleter => null;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pagesConfigCont.showAppBar(false);
    });
  }

  final colorCont = Colors.white;
  double borderCont = 12;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clientSchedControl.showingServiceClient(true);
    });

    // Recupera los argumentos pasados desde la ruta anterior
    final Map<String, dynamic> args = Get.arguments;

    // Extrae los valores individuales de los argumentos
    String clientName = args['clientName'];
    String urlImageClient = args['urlImage'];
    List<ServiceModel> servicesList = Get.arguments['servicesList'];
    return GetBuilder<ClientsScheduledController>(builder: (controllerCoord) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(
                              0, 3), // Cambia el desplazamiento de la sombra
                        ),
                      ],
                      color: colorCont, //todo
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderCont)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            Get.back();
                            /* await pagesConfigCont.showAppBar(true);
                            pagesConfigCont.goToPreviousPage();*/

                            // Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                Stack(children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.white, //fondo de la imagen
                                      radius: 45,
                                      child:
                                          //
                                          GestureDetector(
                                        onDoubleTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageDetailScreen(
                                                      imageUrl:
                                                          '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient'),
                                            ),
                                          );
                                        },
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
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
                                                            Color.fromARGB(110,
                                                                253, 176, 42)),
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
                                    //
                                  ),
                                  Positioned(
                                    top: 66,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xFFFDAE2A)
                                          // Puedes agregar otras propiedades de estilo aquí si es necesario
                                          ),
                                      width: 82,
                                      height: 20,
                                      child: Center(
                                        child: Text(
                                          ' ${controllerCoord.frecuenciaBarber1}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            Text(
                              clientName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Text(
                              'Visitas : ${controllerCoord.cantVisitBarber1}',
                              style: const TextStyle(
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: servicesList.isNotEmpty //todo si hay cargarlos aqui
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets
                              .zero, // Elimina cualquier padding del ListView
                          itemCount: servicesList.length,
                          itemBuilder: (context, index) {
                            // Utiliza la función cardOptions para construir cada Card
                            return Column(
                              children: [
                                cardOptions2(
                                  context,
                                  // Pasa aquí los datos necesarios para cardOptions
                                  servicesList[index].name,
                                  servicesList[index].type_service,
                                  servicesList[index].image_service,
                                ),
                                index == servicesList.length - 1
                                    ? SizedBox(
                                        height: 8,
                                      )
                                    : SizedBox(
                                        height: 0,
                                      )
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No hay Servicios'),
                    ),
            ),
            Expanded(
              flex: 18,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //todo1 estructura de los cart
                        SizedBox(
                          height: 5,
                        ),

                        const SizedBox(
                          height: 0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // Puedes agregar otras propiedades de estilo aquí si es necesario
                          ),
                          height: MediaQuery.of(context).size.height * 0.425,
                          child: Column(
                            children: [
                              // professionalNameBarber
                              // imageUrlBarber
                              // imageLookBarber
                              // cantVisitBarber
                              // endLookBarber
                              // frecuenciaBarber

                              //
                              cardOptionsImage(
                                context,
                                Icon(
                                  MdiIcons.camera,
                                  color: const Color.fromARGB(211, 0, 0, 0),
                                ),
                                'Último look',
                                pagesConfigCont,
                                pagesConfigCont.pageController2,
                                clientSchedControl.endLookBarber1,
                                clientSchedControl.professionalNameBarber1,
                                clientSchedControl
                                    .imageUrlBarber1, // 'CARGAR LA IMAGEN DEL BARBERO',
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    clipBehavior: Clip
                                        .antiAlias, // Recorta el contenido del contenedor para que se ajuste al borde redondeado
                                    child: InteractiveViewer(
                                      minScale: 0.1,
                                      maxScale: 7.0,
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageDetailScreen(
                                                      imageUrl:
                                                          '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient'),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                          fit: BoxFit
                                              .fill, // Puedes ajustar el modo de ajuste según sea necesario
                                          width: 360,
                                          height: loginControl
                                                  .androidInfoHeight! *
                                              0.260, // todo cambiadoNuevoValores
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFDAE2A),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              kDebugMode
                                                  ? Image.asset(
                                                      'assets/images/default_profile.jpg',
                                                      fit: BoxFit
                                                          .cover, // Ajusta la imagen para cubrir completamente el área
                                                      width:
                                                          50, // Ancho deseado de la imagen dentro del círculo
                                                      height:
                                                          50, // Alto deseado de la imagen dentro del círculo
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default_profile.jpg',
                                                      fit: BoxFit
                                                          .cover, // Ajusta la imagen para cubrir completamente el área
                                                      width:
                                                          50, // Ancho deseado de la imagen dentro del círculo
                                                      height:
                                                          50, // Alto deseado de la imagen dentro del círculo
                                                    ),
                                        ),
                                      ),
                                    ),
                                  )),
                              //
                              //
                              //
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Padding cardOptions2(BuildContext context, name, description, image) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 8, left: 10),
      child: Container(
        height: (MediaQuery.of(context).size.height * 0.08),
        width: (MediaQuery.of(context).size.width * 0.95),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 240, 240),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 8, top: 2),
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white, //color de fondo de la imagen

                      radius: 24,
                      child: ClipOval(
                        child: Image.network(
                          '${dotenv.env['API_ENDPOINT']}/images/$image',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            description.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //
              //
            ],
          ),
          subtitle: null,
        ),
      ),
    );
  }

  InkWell cardOptions(BuildContext context, icon, title,
      PagesConfigController pagesConfigCont, page) {
    return InkWell(
      onTap: () async {
        print('estoy dando click');
        await pagesConfigCont.showAppBar(false);
        pagesConfigCont.goToPage(page, pagesConfigCont.pageController2);

        /*pageController2.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );*/
      },
      child: Container(
        height: (MediaQuery.of(context).size.height * 0.07),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Agrega un contenedor para alinear el icono al centro verticalmente
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(55, 124, 123, 123),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                margin: const EdgeInsets.only(right: 10),
                width: 35,
                height: 35,
                child: icon,
              ),
              Text(
                title.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          subtitle: null,
          trailing: page != null
              ? Icon(
                  Icons.navigate_next,
                  color: const Color.fromARGB(
                      255, 43, 44, 49), // Cambia el color a negro
                  size: 30.0,
                )
              : null,
        ),
      ),
    );
  }

  InkWell cardOptionsImage(
      BuildContext context,
      icon,
      title,
      PagesConfigController pagesConfigCont,
      PageController pageController2,
      endLook,
      ultimateBarber,
      urlImage) {
    return InkWell(
      onTap: () async {
        print('estoy dando click');
      },
      child: Column(
        children: [
          /**último look */ Container(
            height: (MediaQuery.of(context).size.height * 0.07),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Agrega un contenedor para alinear el icono al centro verticalmente
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(55, 124, 123, 123),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    width: 35,
                    height: 35,
                    child: icon,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2),
                      ),
                      TruncatedText(
                        text: endLook.toString(),
                        maxLength: 35,
                        styleText: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.2),
                      ),
                    ],
                  )
                ],
              ),
              subtitle: null,
              trailing: null,
            ),
          ),
          /**último professional */ Container(
            height: (MediaQuery.of(context).size.height * 0.07),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Agrega un contenedor para alinear el icono al centro verticalmente
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     color: Color.fromARGB(55, 124, 123, 123),
                  //     borderRadius: BorderRadius.all(Radius.circular(12)),
                  //   ),
                  //   margin: const EdgeInsets.only(right: 10),
                  //   width: 35,
                  //   height: 35,
                  //   child: Icon(
                  //     MdiIcons.accountTie,
                  //     color: const Color.fromARGB(255, 43, 44, 49),
                  //   ),
                  // ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white, //fondo de la imagen
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImage',
                        placeholder: (context, url) => Container(
                          width: 30,
                          height: 30,
                          child: const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    2, // Personaliza el ancho del indicador como desees
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(110, 253, 176, 42)),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
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
                  SizedBox(
                    width: 6,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Último profesional',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.2),
                          ),
                          /*  Text(
                            '(16/01/2024)',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.2),
                          ),*/
                        ],
                      ),
                      Text(
                        ultimateBarber,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.2),
                      ),
                    ],
                  )
                ],
              ),
              subtitle: null,
              trailing: null,
            ),
          ),
        ],
      ),
    );
  }
}
