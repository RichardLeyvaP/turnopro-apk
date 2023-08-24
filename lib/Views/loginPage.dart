// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int clicK = 0;
  final String title = 'Biemvenido!!!';

  @override
  Widget build(BuildContext context) {
    TextEditingController usuarioController = TextEditingController(text: '');
    TextEditingController passController = TextEditingController(text: '');
    // ignore: no_leading_underscores_for_local_identifiers
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //automaticallyImplyLeading: false,//RLP Oculta la flecha de retroceso
        title: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        )),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        elevation: 0, // Quits the shadow
        //shadowColor: Colors.amber, // Removes visual elevation
      ),
      //A PARTIR DE AQUI VIENE_TODO EL CONTENIDO QUE ESTA DEBAJO DE MIS CLIENTES
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 223, 129, 59),
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          child: Column(
            children: [
              Image.asset('assets/images/profile.png'),
              const SizedBox(height: 50),
              TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  fillColor: const Color.fromARGB(24, 96, 125, 139),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Color del borde
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: passController,
                //maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Pass',
                  fillColor: const Color.fromARGB(24, 96, 125, 139),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Color del borde
                  ),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    // Añadir más propiedades de estilo aquí
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/servicesProductsPage');
                    Navigator.pushNamed(context, '/servicesPage');
                    //print(usuarioController);
                    //print(passController);
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 12),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
