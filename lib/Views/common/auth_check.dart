// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Components/button_custom.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/services/local_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final ValueNotifier<bool> isLocalAuthFailed = ValueNotifier(false);
  final LoginController controllerLogin = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    checkLocalAuth();
  }

  checkLocalAuth() async {
    final auth = context.read<LocalAuthService>();
    final isLocalAuthAvailable = await auth.isBiometricAvailable();
    isLocalAuthFailed.value = false;

    if (isLocalAuthAvailable) {
      final authenticated = await auth.authenticate();

      if (!authenticated) {
        isLocalAuthFailed.value = true;
      } else {
        if (!mounted) return;
        //comprobar que tds las variables estan creadas
        if (LocalStorage.prefs.getString('EntryFootprintUser') != null &&
            LocalStorage.prefs.getString('EntryFootprintPass') != null &&
            LocalStorage.prefs.getInt('EntryFootprintBranch') != null) {
          controllerLogin.loginGetIn(
              LocalStorage.prefs.getString('EntryFootprintUser')!,
              LocalStorage.prefs.getString('EntryFootprintPass')!,
              LocalStorage.prefs.getInt('EntryFootprintBranch')!);
        }

        //Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    controllerLogin.getScreenResolution(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ValueListenableBuilder<bool>(
        valueListenable: isLocalAuthFailed,
        builder: (context, failed, _) {
          if (failed) {
            return Center(
              child: CustomButton(
                onPressed: checkLocalAuth,
                text: 'Intentar autenticarse nuevamente',
              ),
            );
          }
          return const Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Color(0xFFFDAE2A),
                  ),
                  Text(
                    'Cargando...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
