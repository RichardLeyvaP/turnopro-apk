// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:animate_do/animate_do.dart';

class LoginFormPage extends StatelessWidget {
  LoginFormPage({super.key});
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usserController = TextEditingController();

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
        body: Column(
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
                flex: 7,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, //todo
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 16, right: 16),
                    child: GetBuilder<LoginController>(builder: (_) {
                      return Column(
                        children: [
                          TextField(
                            controller: _usserController,
                            decoration: InputDecoration(
                              hintText: 'Usuario',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Color del borde
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromARGB(90, 0, 0, 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            obscureText: _.obscureText,
                            controller: _passController,
                            //maxLines: 3,
                            decoration: InputDecoration(
                              //labelText: 'Pass',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Color del borde
                              ),

                              hintText: 'Contraseña', // Este es el placeholder
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromARGB(90, 0, 0, 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _.obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: _.togglePasswordVisibility,
                              ),
                              fillColor: const Color.fromARGB(14, 96, 125, 139),
                              filled: true,

                              labelStyle: const TextStyle(
                                color: Color.fromARGB(176, 0, 0,
                                    0), // Cambia el color del texto aquí
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  onTap: () {
                                    Get.snackbar(
                                      '',
                                      'Cargar Formulario Recuperar Contraseña',
                                      colorText: Colors.black,
                                      titleText: const Text('Mensaje'),
                                      duration: const Duration(seconds: 4),
                                      showProgressIndicator: true,
                                      progressIndicatorBackgroundColor:
                                          const Color.fromARGB(
                                              255, 81, 93, 117),
                                      progressIndicatorValueColor:
                                          const AlwaysStoppedAnimation(
                                              Color.fromARGB(
                                                  255, 241, 130, 84)),
                                      overlayBlur: 3,
                                    );
                                  },
                                  child: const Text('Recuperar Contraseña'))),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 20.0,
                                            horizontal:
                                                60.0), // Ajusta el padding
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      // Añadir más propiedades de estilo aquí
                                    ),
                                    onPressed: () async {
                                      if (_usserController.text.isEmpty ||
                                          _passController.text.isEmpty) {
                                        _passController.text = '';
                                        _usserController.text = '';
                                        Get.snackbar(
                                          '',
                                          'Campos Vacio.',
                                          colorText: Colors.black,
                                          titleText: const Text('Error'),
                                          duration: const Duration(seconds: 1),
                                          showProgressIndicator: true,
                                          progressIndicatorBackgroundColor:
                                              const Color.fromARGB(
                                                  255, 81, 93, 117),
                                          progressIndicatorValueColor:
                                              const AlwaysStoppedAnimation(
                                                  Color.fromARGB(
                                                      255, 241, 130, 84)),
                                          overlayBlur: 3,
                                        );
                                      } else {
                                        await _.loadingValue(true);
                                        await _.loginGetIn(
                                            _usserController.text,
                                            _passController.text);
                                        if (_.incorrectFields == true) {
                                          Get.snackbar(
                                            '',
                                            'Usuario o Contraseña Incorrectos.',
                                            colorText: Colors.black,
                                            titleText: const Text('Error'),
                                            duration:
                                                const Duration(seconds: 2),
                                            showProgressIndicator: true,
                                            progressIndicatorBackgroundColor:
                                                const Color.fromARGB(
                                                    255, 81, 93, 117),
                                            progressIndicatorValueColor:
                                                const AlwaysStoppedAnimation(
                                                    Color.fromARGB(
                                                        255, 241, 130, 84)),
                                            overlayBlur: 3,
                                          );
                                        }
                                      }
                                    },
                                    child: _.isLoading
                                        ? Container(
                                            width: 22,
                                            height: 22,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 241, 130, 84),
                                              strokeWidth: 4,
                                            ),
                                          )
                                        : const Text(
                                            'ENTRAR',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                          )),
                              ),
                            ],
                          ),

                          /* ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 248, 246, 246)),
                                // Añadir más propiedades de estilo aquí
                              ),
                              onPressed: () {
                                _.updateData(
                                    _usserController.text, _passController.text);
                                _.getData();
    
                                if (_.pagina != 'nothing') {
                                  Navigator.pushReplacementNamed(
                                      context, _.pagina);
                                } else if (_.usuario.isNotEmpty ||
                                    _.pass.isNotEmpty) {
                                  _passController.text = '';
                                  _usserController.text = '';
                                  Get.snackbar(
                                    '',
                                    'Usuario o Contraseña incorecto,INTENTELO NUEVAMENTE.',
                                    colorText: Colors.red,
                                    titleText: const Text('Error'),
                                    duration: const Duration(seconds: 4),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 81, 93, 117),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color.fromARGB(255, 241, 130, 84)),
                                    overlayBlur: 3,
                                  );
                                }
                              },
                              child: const Text(
                                'LOG IN',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              )),*/
                        ],
                      );
                    }),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
