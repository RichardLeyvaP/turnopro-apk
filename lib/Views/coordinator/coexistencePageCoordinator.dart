// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';

class CoexistencePageCoordinator extends StatefulWidget {
  const CoexistencePageCoordinator({super.key});

  @override
  _CoexistencePageCoordinatorState createState() => _CoexistencePageCoordinatorState();
}

final ClientsScheduledController controllerClient = Get.find<ClientsScheduledController>();
final LoginController controllerLogin = Get.find<LoginController>();
final PagesConfigController pagesConfigCont = Get.find<PagesConfigController>();

class _CoexistencePageCoordinatorState extends State<CoexistencePageCoordinator> {
  // Lista para rastrear el estado expandido/contraído de cada elemento
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos la lista después de que se construya el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controll = Get.find<CoexistenceController>();
      setState(() {
        _isExpandedList = List<bool>.filled(controll.coexistenceListLength, false);
      });
    });
  }

  // Declaración de variables
  double borderRadiusValue = 12;
//
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.starOutline;

  String title = 'Convivencia';
  String subTitle = 'Cumplimiento de reglas';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFFFDAE2A);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  @override
  Widget build(BuildContext context) {
    print('ENTRANDO A CONVIVENCIAS');
    return Scaffold(
      body: GetBuilder<CoexistenceController>(builder: (controll) {
        List<ProfessionalModel> profesionales = controll.professional;
        // Aseguramos que la lista de estados coincida con la longitud de la lista de datos
        if (_isExpandedList.length != controll.coexistenceListLength) {
          _isExpandedList = List<bool>.filled(controll.coexistenceListLength, false);
        }
        return Column(
          children: [
            Expanded(
              flex: 4,
              child: topPage(
                panddCont: panddCont,
                colorCont: colorCont,
                borderCont: borderCont,
                IconnsBack: IconnsBack,
                pagesConfigC: pagesConfigCont,
                isPagesConfig: true,
                IconnsP: IconnsP,
                title: title,
                subTitle: subTitle,
                colorIcon: colorIcon,
                buttonRight: false,
              ),
            ),
            Expanded(
              flex: 18,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<ProfessionalModel>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Color(0xFFFDAE2A),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Selecciona al profesional',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFDAE2A), // Cambia el color del texto a blanco
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                          ...profesionales.map<DropdownMenuItem<ProfessionalModel>>(
                            (ProfessionalModel profesional) {
                              return DropdownMenuItem<ProfessionalModel>(
                                value: profesional,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white, //fondo de la imagen
                                      child: ClipOval(
                                        child: Image.network(
                                          '${dotenv.env['API_ENDPOINT']}/images/${profesional.image_url}',
                                          fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el área
                                          width: 50, // Ancho deseado de la imagen dentro del círculo
                                          height: 50,
                                          loadingBuilder:
                                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                            if (kDebugMode) {
                                              return CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors
                                                    .transparent, // Fondo transparente para que el borde sea visible
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/default_profile.jpg',
                                                    fit: BoxFit
                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                    width: 50, // Ancho deseado de la imagen dentro del círculo
                                                    height: 50, // Alto deseado de la imagen dentro del círculo
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Si no estamos en modo de depuración, mostramos un texto de error
                                              return CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors
                                                    .transparent, // Fondo transparente para que el borde sea visible
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/default_profile.jpg',
                                                    fit: BoxFit
                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                    width: 50, // Ancho deseado de la imagen dentro del círculo
                                                    height: 50, // Alto deseado de la imagen dentro del círculo
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),

                                    //

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '   ${profesional.name} ${profesional.surname}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFDAE2A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '   ${profesional.charge_id}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(150, 0, 0, 0), fontSize: 12, height: 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
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
                          padding: const EdgeInsets.only(top: 2, left: 14, right: 14, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 20,
                          iconEnabledColor: Color(0xFFFDAE2A),
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 340,
                          width: (MediaQuery.of(context).size.width * 0.85),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          offset: const Offset(40, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 50,
                          padding: EdgeInsets.only(left: 14, right: 14, bottom: 5),
                        ),
                      ),
                    ),
                    controll.selectedProfessional != null
                        ? Expanded(
                            child: controll.coexistenceListLength > 0
                                ? ListView.builder(
                                    padding: EdgeInsets.zero, // Elimina cualquier padding
                                    itemCount: controll.coexistenceListLength,
                                    itemBuilder: (context, index) {
                                      final item = controll.coexistence[index];
                                      final isExpanded = _isExpandedList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(-5, 5),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              {
                                                if (controllerLogin.codigoQrValid() == true) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return GetBuilder<ClientsScheduledController>(builder: (_) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
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
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 12),
                                                                      child: Text(
                                                                        controll.coexistence[index].name.toString(),
                                                                        style: const TextStyle(
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
                                                              SizedBox(
                                                                height: 150,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    //Cart de cumplida

                                                                    //Cart de  imcumplida
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        await controllerClient.changeNoncompliancePId(
                                                                            controll.coexistence[index].id,
                                                                            controll.coexistence[index].type,
                                                                            controllerLogin.branchIdLoggedIn,
                                                                            controll.selectedProfessional!.id,
                                                                            1);

                                                                        /*   await controllerClient.changeNoncomplianceP(
                                                                            controll.coexistence[index].type,
                                                                            controllerLogin.branchIdLoggedIn,
                                                                            controll.selectedProfessional!.id,
                                                                            1);*/
                                                                        setState(() {});
                                                                        // Lógica para la opción 2
                                                                        Navigator.pop(context, 'Cumplió');
                                                                      },
                                                                      child: Container(
                                                                        height: 40,
                                                                        width:
                                                                            (MediaQuery.of(context).size.width * 0.7),
                                                                        alignment: Alignment.centerLeft,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(
                                                                            color: Color.fromARGB(100, 154, 155, 154),
                                                                            width: 1,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8),
                                                                              child: Icon(
                                                                                MdiIcons.starBox,
                                                                                color: const Color(0xFF4470F3),
                                                                                size: 35,
                                                                              ),
                                                                            ),
                                                                            const Text(
                                                                              'CUMPLIÓ',
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            const Padding(
                                                                              padding: EdgeInsets.only(right: 8),
                                                                              child: Text('     '),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 20,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        await controllerClient.changeNoncompliancePId(
                                                                            controll.coexistence[index].id,
                                                                            controll.coexistence[index].type,
                                                                            controllerLogin.branchIdLoggedIn,
                                                                            controll.selectedProfessional!.id,
                                                                            0);

                                                                        /* await controllerClient.changeNoncomplianceP(
                                                                            controll.coexistence[index].type,
                                                                            controllerLogin.branchIdLoggedIn,
                                                                            controll.selectedProfessional!.id,
                                                                            0);*/
                                                                        setState(() {});
                                                                        // Lógica para la opción 1
                                                                        Navigator.pop(context, 'Incumplio');
                                                                      },
                                                                      child: Container(
                                                                        height: 40,
                                                                        width:
                                                                            (MediaQuery.of(context).size.width * 0.7),
                                                                        alignment: Alignment.centerLeft,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(
                                                                            color: Color.fromARGB(100, 154, 155, 154),
                                                                            width: 1,
                                                                          ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 8),
                                                                                child: Icon(
                                                                                  MdiIcons.minusBox,
                                                                                  color: const Color(0xFFFF6750),
                                                                                  size: 35,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                'INCUMPLIÓ',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.only(right: 8),
                                                                                child: Text('     '),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
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
                                                } else {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Debe de escanear el código Qr de entrada',
                                                    duration: const Duration(milliseconds: 2500),
                                                    backgroundColor: const Color.fromARGB(118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                                                    overlayBlur: 3,
                                                  );
                                                }
                                              }
                                            },
                                            child: ListTile(
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                              ),
                                              leading: _getIcon(controll, index),
                                              title: TruncatedText(
                                                text: item.name.toString(),
                                                maxLength: 28,
                                                styleText: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.8, // Ajusta este valor para reducir el espacio vertical.
                                                ),
                                              ),
                                              subtitle: AnimatedCrossFade(
                                                firstChild: Padding(
                                                  padding: const EdgeInsets.only(bottom: 6),
                                                  child: Text(
                                                    item.description.toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(148, 0, 0, 0),
                                                      height:
                                                          1.4, // Ajusta este valor para reducir el espacio vertical.
                                                    ),
                                                  ),
                                                ),
                                                secondChild: Padding(
                                                  padding: const EdgeInsets.only(bottom: 6),
                                                  child: Text(
                                                    item.description.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(148, 0, 0, 0),
                                                      height:
                                                          1.4, // Ajusta este valor para reducir el espacio vertical.
                                                    ),
                                                  ),
                                                ),
                                                crossFadeState:
                                                    isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                duration: const Duration(milliseconds: 400),
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                  color: Colors.grey[600],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isExpandedList[index] = !_isExpandedList[index];
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No hay Convivencias'),
                                  ),
                          )
                        : Text(' '),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Función para obtener el icono adecuado basado en el tipo y no conformidad
  Widget _getIcon(CoexistenceController controller, int index) {
    final type = controller.coexistence[index].id;
    final nonCompliance = Get.find<ClientsScheduledController>().noncomplianceProfessional[type.toString()] ?? -1;

    if (nonCompliance == 3) {
      return Icon(
        MdiIcons.checkboxBlankOutline,
        color: const Color(0xFFFDAE2A),
        size: 45,
      );
    } else if (nonCompliance == 0) {
      return Icon(
        MdiIcons.minusBox,
        color: const Color(0xFFFF6750),
        size: 45,
      );
    } else {
      return Icon(
        MdiIcons.starBox,
        color: const Color(0xFF4470F3),
        size: 45,
      );
    }
  }
}
