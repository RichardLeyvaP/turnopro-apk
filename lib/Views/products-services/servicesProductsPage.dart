// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/Views/products-services/products/productsBody.dart';
import 'package:turnopro_apk/Views/products-services/services/servicesBodyPage.dart';
//import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/ImageDetailScreen.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
//
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import '../../Routes/index.dart';

class ServicesProductsPage extends StatefulWidget {
  const ServicesProductsPage({super.key});

  @override
  State<ServicesProductsPage> createState() => _ServicesProductsPageState();
}

class _ServicesProductsPageState extends State<ServicesProductsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //final ServiceController controller = Get.put(ServiceController());

  final ProductController controllerProduct = Get.put(ProductController());

  final ServiceController controllerService = Get.find<ServiceController>();
  final ClientsScheduledController clientsController = Get.find<ClientsScheduledController>();
  final ShoppingCartController controllerShoppingCart = Get.find<ShoppingCartController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();
  final LoginController controllerLog = Get.put(LoginController());
  NotificationController notiController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // controllerProduct.initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loginController.setIsLoadingFor(false);
      //loginController.inTheClock(false);
    });
    bool hasText = false;
    void _checkText() {
      setState(() {
        hasText = commentController.text.trim().isNotEmpty;
      });
    }

    //VARIABLE A UTILIZAR
    BoxDecoration clickServicesDecoration = const BoxDecoration(
      color: Color(0xFFFDAE2A),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    BoxDecoration decorationBackground = const BoxDecoration(
      color: Color.fromARGB(100, 231, 232, 234),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    const backgroundColor = Color.fromARGB(255, 231, 232, 234);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 231, 232, 234), // Color de fondo del AppBar
            elevation: 0, // Sombra del AppBar
            toolbarHeight: 170, // Altura del AppBar
            // actions: [
            //   IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
            // ],

            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 0, bottom: 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color.fromARGB(255, 49, 48, 48),
                                  ), // Icono que deseas mostrar
                                  onPressed: () {
                                    // if (controllerLog.varInTheClock == true) //ir al home
                                    // {
                                    loginController.inTheClock(false);
                                    pagesConfigC.back();
                                    // } else {
                                    //   pagesConfigC.previousPage();
                                    // }

                                    //Get.back();
                                  }, // Evento onPress
                                ),
                                GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageDetailScreen(
                                            imageUrl:
                                            '${dotenv.env['API_ENDPOINT']}/${clientsController.urlImageTemporary}'),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white, // Fondo de la imagen
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: '${dotenv.env['API_ENDPOINT']}/images/${clientsController.urlImageTemporary}',
                                        fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                        width: 50, // Ancho deseado de la imagen dentro del círculo
                                        height: 50, // Alto deseado de la imagen dentro del círculo
                                        placeholder: (context, url) => const CircularProgressIndicator(
                                          color: Color(0xFFFDAE2A),
                                        ),
                                        errorWidget: (context, url, error) => CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              Colors.transparent, // Fondo transparente para que el borde sea visible
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/default_profile.jpg',
                                              fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                              width: 50, // Ancho deseado de la imagen dentro del círculo
                                              height: 50, // Alto deseado de la imagen dentro del círculo
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                //
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TruncatedText(
                                text: clientsController.nameClientTemporary,
                                maxLength: 22,
                                styleText: const TextStyle(
                                    fontSize: 16, color: const Color(0xFF2B3141), fontWeight: FontWeight.bold),
                              ),
                              /*   Text(clientsController.nameClientTemporary,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xFF2B3141),
                                      fontWeight: FontWeight.bold)),*/

                              Text('CLIENTE',
                                  style: const TextStyle(
                                      color: const Color(0xFF2B3141), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      GetBuilder<ShoppingCartController>(builder: (_) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _.shoppingCart == 0
                                  ? CircleAvatar(
                                      radius: 22, // Tamaño del CircleAvatar
                                      backgroundColor: const Color(0xFF2B3141), // Color de fondo del CircleAvatar
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.shopping_cart,
                                          size: 30,
                                          color: Colors.white,
                                        ), // Icono que deseas mostrar
                                        onPressed: () {
                                          Get.snackbar(
                                            'Mensaje del Carrito de Compra',
                                            'Su carrito esta vacio',
                                            duration: const Duration(milliseconds: 2500),
                                            showProgressIndicator: true,
                                            progressIndicatorBackgroundColor: const Color(0xFF4470F3),
                                            progressIndicatorValueColor:
                                                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                            overlayBlur: 3,
                                          );
                                        }, // Evento onPress
                                      ))
                                  : Badge(
                                      label: Text(_.shoppingCart.toString()),
                                      child: CircleAvatar(
                                          radius: 22, // Tamaño del CircleAvatar
                                          backgroundColor: const Color(0xFF2B3141), // Color de fondo del CircleAvatar
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.shopping_cart_outlined,
                                              size: 30,
                                              color: Colors.white,
                                            ), // Icono que deseas mostrar
                                            onPressed: () async {
                                              // Muestra el indicador de carga
                                              Get.dialog(
                                                const Center(
                                                  child: CircularProgressIndicator(
                                                    color: Color(0xFFFDAE2A),
                                                  ),
                                                ),
                                                barrierDismissible: false,
                                              );

                                              try {
                                                await _.loadCart();

                                                if (Get.isDialogOpen ?? false) {
                                                  Get.back();
                                                } // Cierra el diálogo

                                                pagesConfigC.nextPage();
                                              } catch (e) {
                                                // En caso de error, oculta el indicador de carga y muestra un mensaje de error
                                                if (Get.isDialogOpen ?? false) {
                                                  Get.back();
                                                }
                                                Get.snackbar('Error', 'Hubo un error al cargar el carrito: $e');
                                              }
                                            }, // Evento onPress
                                          ))),
                            ),
                          ],
                        );
                      }),

                      // const Text("          "),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 2000,
                        height: 1.5,
                        color: const Color.fromARGB(40, 128, 127, 127),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          if (loginController.branchTecnicLoggedIn == 1) ...[
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF4470F3),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0), // Radio de los bordes
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (controllerLog.usserPermissionQr == 1 || (controllerLog.usserPermissionQr == 2)) {
                                  Get.dialog(
                                    const Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Color(0xFFFDAE2A),
                                            ),
                                            SizedBox(height: 16),
                                            Text('Enviando al técnico...', style: TextStyle(color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();

                                  //mando a notificar al tecnico
                                  notiController.storeNotification(
                                      'Cliente llegando',
                                      loginController.branchIdLoggedIn,
                                      loginController.idProfessionalLoggedIn,
                                      'EL cliente "${clientsController.nameClientTemporary}" fue enviado por el Profesional ${loginController.nameUserLoggedIn}',
                                      'no',
                                      'Tecnico'); //esto es para quele llegue a coordinador y encargado

                                  await clientsController.acceptOrRejectClient(clientsController.idClientTemporary, 4,
                                      loginController.tokenUserLoggedIn); // Cierra el modal
                                  pagesConfigC.back();
                                  if (Get.isDialogOpen ?? false) {
                                    Get.back();
                                  }
                                }
                              },
                              child: const Text(
                                ' ENVIAR AL TÉCNICO ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFF6750),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Radio de los bordes
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (controllerLog.usserPermissionQr == 1) {
                                commentController.text = '';
                                clientsController.clearImage();
                                LocalStorage.prefs.setBool('verificatePhoto', false);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return GetBuilder<ClientsScheduledController>(builder: (_) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ), //this right here
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFDAE2A),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 12),
                                                    child: Text(
                                                      'Comentario',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close, color: Colors.white),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: (_.imagePath == null) ? 240 : 300,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                    ),
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        _checkText();
                                                      },
                                                      controller: commentController,
                                                      maxLines: 5,
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: 'Escribe tu comentario aquí...',
                                                        hintStyle: TextStyle(
                                                          color: Color.fromARGB(120, 241, 131, 84),
                                                        ), // Cambiar el color del hintText
                                                      ),
                                                    ),
                                                  ),
                                                  //
                                                  //
                                                  //

                                                  (_.imagePath == null)
                                                      ? const Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.image_outlined),
                                                            Text(
                                                              'Cargar foto del cliente',
                                                              style: TextStyle(fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          width: 70, // Establece el ancho deseado
                                                          height: 70, // Establece la altura deseada
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(
                                                                10), // Establece el radio de borde deseado
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(
                                                                10), // Asegúrate de que este radio sea igual al radio del borde del BoxDecoration
                                                            child: Image.file(
                                                              File(_.imagePath!),
                                                              fit: BoxFit
                                                                  .cover, // Puedes ajustar el modo de ajuste según tus necesidades
                                                            ),
                                                          ),
                                                        ),

                                                  //
                                                  //
                                                  //
                                                  //
                                                  ButtonBar(
                                                    alignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                            const EdgeInsets.symmetric(vertical: 0, horizontal: 26.0),
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<Color>(Color(0xFF4470F3)),
                                                        ),


                                                        onPressed: () async {
                                                          final ImagePicker _picker = ImagePicker();

                                                          // Elige la imagen con calidad reducida (por ejemplo, 50%)
                                                          final XFile? pickedFile = await _picker.pickImage(
                                                            source: ImageSource.camera,
                                                            imageQuality: 20, // Establece la calidad al 50%
                                                          );

                                                          // Guarda la imagen seleccionada en una variable y almacena la preferencia
                                                          if (pickedFile != null) {
                                                            _.setPickedFile(pickedFile);
                                                            await LocalStorage.prefs.setBool('verificatePhoto', true);

                                                            // Verifica si pickedFile no es nulo antes de acceder a su propiedad path
                                                            _.setImagePath(pickedFile.path);

                                                            print('DIRECCIONDELAIMAGEN : ${_.imagePath}');
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              MdiIcons.camera,
                                                              color: Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            const Text(
                                                              'FOTO',
                                                              style: TextStyle(
                                                                  color: Colors.white, fontWeight: FontWeight.w800),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                            const EdgeInsets.symmetric(vertical: 0, horizontal: 26.0),
                                                          ),
                                                          backgroundColor: MaterialStateProperty.all<Color>(hasText
                                                              ? Color(0xFF19CF9E)
                                                              : Color.fromARGB(155, 192, 191, 191)),
                                                        ),
                                                        onPressed: () async {
                                                          // Lógica para enviar el comentario
                                                          // Obtener el valor del campo de texto
                                                          String commentText = commentController.text;
                                                          // Eliminar espacios en blanco al principio y al final

                                                          // Verificar que el campo no esté vacío
                                                          // if (hasText &&
                                                          //     _.pickedFile !=
                                                          //         null) {

                                                          if (hasText) {
                                                            // Cerrar el primer modal
                                                            Navigator.pop(context);

                                                            Get.dialog(
                                                              const Center(
                                                                child: Material(
                                                                  color: Colors.transparent,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      CircularProgressIndicator(
                                                                        color: Color(0xFFFDAE2A),
                                                                      ),
                                                                      SizedBox(height: 16),
                                                                      Text('Espere...',
                                                                          style: TextStyle(color: Colors.white)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              barrierDismissible: false,
                                                            ); //Get.back();

                                                            dio.Dio dioClient = dio.Dio();
                                                            String imag = '';
                                                            if (_.pickedFile != null) {
                                                              imag = _.pickedFile!.path;
                                                            }

                                                            int resultFin =
                                                                await clientsController.storeByReservationId(
                                                                    imag,
                                                                    clientsController.idClientTemporary,
                                                                    commentText,
                                                                    dioClient);

                                                            if (resultFin == 1) //es que finalizó bien
                                                            {
                                                              //aqui poner una variable que espere por 30 segundos para cambiar al valor por defecto
                                                              //para con esta variable controlar que en ese tiempo no le caiga nadie en la cola

                                                              bool valRActiv =
                                                                  clientsController.verificateValueTimers();

                                                              print('valores de lso clok***Reloj:$valRActiv');
                                                              if (valRActiv == false) {
                                                                clientsController.setWaitTime(true);
                                                                clientsController.setBoolControlVision(false);
                                                              } else {
                                                                clientsController.setWaitTime(false);
                                                                clientsController.setBoolControlVision(true);
                                                              }

                                                              if (Get.isDialogOpen ?? false) {
                                                                Get.back();
                                                              } //aqui cierra el cargando
                                                              Get.snackbar(
                                                                'Mensaje',
                                                                'Finalizando servicio',
                                                                duration: const Duration(milliseconds: 2000),
                                                                backgroundColor:
                                                                    const Color.fromARGB(118, 255, 255, 255),
                                                                showProgressIndicator: true,
                                                                progressIndicatorBackgroundColor:
                                                                    const Color.fromARGB(255, 203, 205, 209),
                                                                progressIndicatorValueColor:
                                                                    const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                                                overlayBlur: 3,
                                                              );
                                                              final ClientsScheduledController cliCont =
                                                                  Get.find<ClientsScheduledController>();
                                                              loginController.setCodigoQrValid(1);
                                                              cliCont.setImagePath(null);
                                                              Future.delayed(const Duration(milliseconds: 1000), () {
                                                                // Aquí dentro puedes poner la acción que deseas realizar después de esperar 2 segundos
                                                                loginController.inTheClock(false);
                                                                pagesConfigC.back();

                                                              });

                                                              print('Comentario enviado - $commentText ');
                                                            } else {
                                                              if (Get.isDialogOpen ?? false) {
                                                                Get.back();
                                                              } //aqui cierra el cargando

                                                              Get.snackbar(
                                                                '!Alerta',
                                                                'No finalizó el servicio correctamente, vuelva a intentarlo',
                                                                duration: const Duration(milliseconds: 3000),
                                                                showProgressIndicator: true,
                                                                progressIndicatorBackgroundColor:
                                                                    const Color.fromARGB(255, 146, 99, 19),
                                                                progressIndicatorValueColor:
                                                                    const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                                                overlayBlur: 3,
                                                              );
                                                            }
                                                          } else {
                                                            if (hasText == false) {
                                                              Get.snackbar(
                                                                'Mensaje',
                                                                'Debe escribir un comentario al respecto',
                                                                duration: const Duration(milliseconds: 2500),
                                                                showProgressIndicator: true,
                                                                progressIndicatorBackgroundColor:
                                                                    Color.fromARGB(255, 146, 99, 19),
                                                                progressIndicatorValueColor:
                                                                    const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                                                overlayBlur: 3,
                                                              );
                                                            }

                                                            /*   else if (_.pickedFile == null) {
                                                              Get.snackbar(
                                                                'Mensaje',
                                                                'Debe de tomar una foto',
                                                                duration: const Duration(milliseconds: 2500),
                                                                showProgressIndicator: true,
                                                                progressIndicatorBackgroundColor:
                                                                    Color.fromARGB(255, 146, 99, 19),
                                                                progressIndicatorValueColor:
                                                                    const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                                                overlayBlur: 3,
                                                              );
                                                            }*/

                                                            // El campo de texto está vacío, puedes mostrar un mensaje o realizar alguna acción
                                                            print('El comentario no puede estar vacío');
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              MdiIcons.send,
                                                              color: Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            const Text(
                                                              'ENVIAR',
                                                              style: TextStyle(
                                                                  color: Colors.white, fontWeight: FontWeight.w800),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              } //ciere de if para saver si qr = 1
                              else if (controllerLog.usserPermissionQr == 2) {
                                Get.snackbar(
                                  'Mensaje',
                                  'Debe de esperar la respuesta a su solicitud',
                                  duration: const Duration(milliseconds: 2500),
                                  backgroundColor: const Color.fromARGB(118, 255, 255, 255),
                                  showProgressIndicator: true,
                                  progressIndicatorBackgroundColor: const Color.fromARGB(255, 203, 205, 209),
                                  progressIndicatorValueColor: const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                  overlayBlur: 3,
                                );
                              }
                            },
                            child: const Text(
                              ' FINALIZAR SERVICIO ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30), // Altura del TabBar
              child: Container(
                width: (MediaQuery.of(context).size.width * 0.935),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.88),
                      height: (MediaQuery.of(context).size.width * 0.09),
                      decoration: decorationBackground,
                      child: TabBar(
                        // isScrollable: true,//rlp si son muchos tab para que tenga scroll entre los tab
                        indicator: clickServicesDecoration,
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color.fromARGB(155, 136, 135, 135),
                        automaticIndicatorColorAdjustment: false,
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Servicios'),
                          Tab(text: 'Productos'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
          body:
              //  controllerShoppingCart.internetError != -99
              //     ?
              TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: backgroundColor,
                child: ServicesBodyPage(), //RLP AQUI SE CARGA LA PAGINA DE LOS SERVICIOS
              ),
              Container(
                color: backgroundColor,
                child: const ProductsBody(),
              ),
            ],
          )
          // : AlertDialogPago(
          //     controllerShoppingCart: controllerShoppingCart,
          //     pagesConfigC: pagesConfigC), // Muestra el AlertDialog
          ),
    );
  }
}

/*
class AlertDialogPago extends StatelessWidget {
  final ShoppingCartController controllerShoppingCart;
  final PagesConfigController pagesConfigC;
  const AlertDialogPago(
      {Key? key,
      required this.controllerShoppingCart,
      required this.pagesConfigC})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error de conexión'),
      content: const SizedBox(
        height: 30.0, // Ajusta la altura según tu necesidad
        child: Column(
          mainAxisSize: MainAxisSize.min, // Establece el tamaño mínimo
          children: [
            FittedBox(
                fit: BoxFit.contain,
                child: Text('Por favor revise su conexión a Internet')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            // Get.back();
            controllerShoppingCart.loadDataInitiallyNecessary();
            pagesConfigC.previousPage();
          },
          child: const Text('Atras'),
        ),
        TextButton(
          onPressed: () async {
            // Cerrar el AlertDialog
            try {
              await controllerShoppingCart.loadDataInitiallyNecessary();
              // Get.toNamed(
              //   '/Professional',
              // );
              pagesConfigC.previousPage();
            } catch (e) {
              // Get.toNamed(
              //   '/Professional',
              // );
              pagesConfigC.previousPage();
            }
          },
          child: const Text('Volver Intentarlo'),
        ),
      ],
    );
  }
}
*/
