import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:intl/intl.dart';
import 'package:turnopro_apk/services/background_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

final LoginController controllerLogin = Get.find<LoginController>();

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Obtener la fecha actual
    // Obtener la fecha actual
    DateTime now = DateTime.now();
    // Formatear la fecha para que solo incluya año, mes y día
    String dataAct = DateFormat('yyyy-MM-dd').format(now);
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (LocalStorage.prefs.getString('EntryFootprintData') != null &&
          LocalStorage.prefs.getString('EntryFootprintData') == dataAct &&
          LocalStorage.prefs.getBool('EntryFootprintOpen') != null &&
          LocalStorage.prefs.getBool('EntryFootprintOpen') == true &&
          LocalStorage.prefs.getString('EntryFootprintUser') != null &&
          LocalStorage.prefs.getString('EntryFootprintPass') != null &&
          LocalStorage.prefs.getInt('EntryFootprintBranch') !=
              null) //si essiste la variable fecha creada y coincide con la fecha de hoy abrir con huella
      {
        try {
          await controllerLogin.loginGetIn(LocalStorage.prefs.getString('EntryFootprintUser')!,
              LocalStorage.prefs.getString('EntryFootprintPass')!, LocalStorage.prefs.getInt('EntryFootprintBranch')!);
          //si todo esta bien y el servicio no esta activo - activarlo
          checkAndStartService(); //si esta detenido, aqui lo inicio
        } catch (e) {
          //si diera algun error ver si esta activo, detener el servicio
          checkAndStopService(); //si esta detenido, aqui lo inicio
          print(e);
        }

        // llamar al controlador y loguear con esos datos
        // Get.offAllNamed(
        //   '/AuthCheck',
        // );
      } else {
        Get.offAllNamed(
          '/LoginFormPage',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Pulse(
            duration: const Duration(milliseconds: 300),
            child: const Image(
              image: AssetImage(
                'assets/images/ico.png',
              ),
              width: 88,
              height: 88,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Visibility(
                visible: true,
                child: Text(
                  '     Simplifies',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              FadeIn(
                //  duration: const Duration(milliseconds: 500),
                // delay: const Duration(milliseconds: 500),
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                )),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
