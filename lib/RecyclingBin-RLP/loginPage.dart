// // ignore_for_file: file_names, depend_on_referenced_packages

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:get/get.dart';
// import 'package:turnopro_apk/Controllers/login.controller.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final int clicK = 0;

//   final String logMeIn = 'Login';
//   final String registerMe = 'Registrarse';
//   final TextEditingController _passController = TextEditingController();
//   final TextEditingController _usserController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // ignore: no_leading_underscores_for_local_identifiers
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 50,
//         // backgroundColor: const Color.fromARGB(34, 0, 0, 0),
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false, //RLP Oculta la flecha de retroceso
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: GetBuilder<LoginController>(builder: (_) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   _.login ? logMeIn : registerMe,
//                   style: const TextStyle(
//                       color: const Color.fromARGB(255, 43, 44, 49),
//                       fontSize: 30,
//                       fontWeight: FontWeight.w900),
//                 ),
//                 const SizedBox(
//                   width: 100,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _.changeLoginValue();
//                   },
//                   child: Text(
//                     _.login ? registerMe : logMeIn,
//                     style: const TextStyle(
//                         color: Color.fromARGB(131, 0, 0, 0), fontSize: 10),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//         elevation: 0, // Quits the shadow
//         //shadowColor: Colors.amber, // Removes visual elevation
//       ),
//       //A PARTIR DE AQUI VIENE_TODO EL CONTENIDO QUE ESTA DEBAJO DE MIS CLIENTES
//       body: loginForm(context),
//     );
//   }

//   SingleChildScrollView loginForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: GetBuilder<LoginController>(builder: (_) {
//         return _.login
//             ? Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     children: [
//                       Lottie.network(
//                           "https://lottie.host/75031932-899f-4149-8acc-9e77e1d1325f/prRgl3HYwd.json",
//                           height: (MediaQuery.of(context).size.height * 0.3),
//                           width: (MediaQuery.of(context).size.width * 0.6)),
//                       SizedBox(
//                         // color: Colors.blue,
//                         height: 250,
//                         width: (MediaQuery.of(context).size.width * 0.8),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GetBuilder<LoginController>(builder: (_) {
//                             return Column(
//                               children: [
//                                 TextField(
//                                   controller: _usserController,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(
//                                       Icons.person,
//                                       color: Color.fromARGB(90, 0, 0, 0),
//                                     ), // Ícono de persona (user)
//                                     //labelText: 'Usuario',
//                                     hintText:
//                                         'barbero ó responsable', // Este es el placeholder
//                                     fillColor:
//                                         const Color.fromARGB(14, 96, 125, 139),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           15.0), // Color del borde
//                                     ),
//                                     labelStyle: const TextStyle(
//                                       color: Color.fromARGB(176, 0, 0,
//                                           0), // Cambia el color del texto aquí
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//                                 TextField(
//                                   obscureText: _.obscureText,
//                                   controller: _passController,
//                                   //maxLines: 3,
//                                   decoration: InputDecoration(
//                                     //labelText: 'Pass',
//                                     hintText:
//                                         'pass = 123', // Este es el placeholder
//                                     prefixIcon: const Icon(
//                                       Icons.lock,
//                                       color: Color.fromARGB(90, 0, 0, 0),
//                                     ),
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         _.obscureText
//                                             ? Icons.visibility
//                                             : Icons.visibility_off,
//                                         color: Colors.grey,
//                                       ),
//                                       onPressed: _.togglePasswordVisibility,
//                                     ),
//                                     fillColor:
//                                         const Color.fromARGB(14, 96, 125, 139),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           15.0), // Color del borde
//                                     ),
//                                     labelStyle: const TextStyle(
//                                       color: Color.fromARGB(176, 0, 0,
//                                           0), // Cambia el color del texto aquí
//                                     ),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               const Color.fromARGB(
//                                                   255, 248, 246, 246)),
//                                       // Añadir más propiedades de estilo aquí
//                                     ),
//                                     onPressed: () {
//                                       // _.updateData(_usserController.text,
//                                       //     _passController.text);
//                                       // _.getData();

//                                       if (_.pagina != 'nothing') {
//                                         Navigator.pushReplacementNamed(
//                                             context, _.pagina);
//                                       } else if (_.usuario.isNotEmpty ||
//                                           _.pass.isNotEmpty) {
//                                         _passController.text = '';
//                                         _usserController.text = '';
//                                         Get.snackbar(
//                                           '',
//                                           'Usuario o Contraseña incorecto,INTENTELO NUEVAMENTE.',
//                                           colorText: Colors.red,
//                                           titleText: const Text('Error'),
//                                           duration: const Duration(seconds: 4),
//                                           showProgressIndicator: true,
//                                           progressIndicatorBackgroundColor:
//                                               const Color.fromARGB(
//                                                   255, 81, 93, 117),
//                                           progressIndicatorValueColor:
//                                               const AlwaysStoppedAnimation(
//                                                   Color.fromARGB(
//                                                       255, 241, 130, 84)),
//                                           overlayBlur: 3,
//                                         );
//                                       }
//                                     },
//                                     child: const Text(
//                                       'LOG IN',
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: const Color.fromARGB(255, 43, 44, 49),
//                                           fontWeight: FontWeight.w800),
//                                     )),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             : Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     children: [
//                       Lottie.network(
//                           "https://lottie.host/75031932-899f-4149-8acc-9e77e1d1325f/prRgl3HYwd.json",
//                           height: (MediaQuery.of(context).size.height * 0.3),
//                           width: (MediaQuery.of(context).size.width * 0.6)),
//                       SizedBox(
//                         height: 350,
//                         width: (MediaQuery.of(context).size.width * 0.8),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GetBuilder<LoginController>(builder: (_) {
//                             return Column(
//                               children: [
//                                 TextField(
//                                   controller: _usserController,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(
//                                       Icons.person,
//                                       color: Color.fromARGB(90, 0, 0, 0),
//                                     ), // Ícono de persona (user)
//                                     //labelText: 'Usuario',
//                                     hintText:
//                                         'Nombre', // Este es el placeholder
//                                     fillColor:
//                                         const Color.fromARGB(14, 96, 125, 139),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           15.0), // Color del borde
//                                     ),
//                                     labelStyle: const TextStyle(
//                                       color: Color.fromARGB(176, 0, 0,
//                                           0), // Cambia el color del texto aquí
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//                                 TextField(
//                                   controller: _usserController,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(
//                                       Icons.email,
//                                       color: Color.fromARGB(90, 0, 0, 0),
//                                     ), // Ícono de persona (user)
//                                     //labelText: 'Usuario',
//                                     hintText:
//                                         'Correo', // Este es el placeholder
//                                     fillColor:
//                                         const Color.fromARGB(14, 96, 125, 139),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           15.0), // Color del borde
//                                     ),
//                                     labelStyle: const TextStyle(
//                                       color: Color.fromARGB(176, 0, 0,
//                                           0), // Cambia el color del texto aquí
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//                                 TextField(
//                                   obscureText: _.obscureText,
//                                   controller: _passController,
//                                   //maxLines: 3,
//                                   decoration: InputDecoration(
//                                     //labelText: 'Pass',
//                                     hintText:
//                                         'Contraseña', // Este es el placeholder
//                                     prefixIcon: const Icon(
//                                       Icons.lock,
//                                       color: Color.fromARGB(90, 0, 0, 0),
//                                     ),
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         _.obscureText
//                                             ? Icons.visibility
//                                             : Icons.visibility_off,
//                                         color: Colors.grey,
//                                       ),
//                                       onPressed: _.togglePasswordVisibility,
//                                     ),
//                                     fillColor:
//                                         const Color.fromARGB(14, 96, 125, 139),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           15.0), // Color del borde
//                                     ),
//                                     labelStyle: const TextStyle(
//                                       color: Color.fromARGB(176, 0, 0,
//                                           0), // Cambia el color del texto aquí
//                                     ),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               const Color.fromARGB(
//                                                   255, 236, 232, 231)),
//                                       // Añadir más propiedades de estilo aquí
//                                     ),
//                                     onPressed: () {
//                                       // _.updateData(_usserController.text,
//                                       //     _passController.text);
//                                       // _.getData();

//                                       if (_.pagina != 'nothing') {
//                                         Navigator.pushReplacementNamed(
//                                             context, _.pagina);
//                                       } else if (_.usuario.isNotEmpty ||
//                                           _.pass.isNotEmpty) {
//                                         _passController.text = '';
//                                         _usserController.text = '';
//                                         Get.snackbar(
//                                           '',
//                                           'Usuario o Contraseña incorecto,INTENTELO NUEVAMENTE.',
//                                           colorText: Colors.red,
//                                           titleText: const Text('Error'),
//                                           duration: const Duration(seconds: 4),
//                                           showProgressIndicator: true,
//                                           progressIndicatorBackgroundColor:
//                                               const Color.fromARGB(
//                                                   255, 81, 93, 117),
//                                           progressIndicatorValueColor:
//                                               const AlwaysStoppedAnimation(
//                                                   Color.fromARGB(
//                                                       255, 241, 130, 84)),
//                                           overlayBlur: 3,
//                                         );
//                                       }
//                                     },
//                                     child: const Text(
//                                       'Registrarme',
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: const Color.fromARGB(255, 43, 44, 49),
//                                           fontWeight: FontWeight.w800),
//                                     )),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//       }),
//     );
//   }

//   SingleChildScrollView checkInForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Center(
//         child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             children: [
//               Lottie.network(
//                   "https://lottie.host/75031932-899f-4149-8acc-9e77e1d1325f/prRgl3HYwd.json",
//                   height: (MediaQuery.of(context).size.height * 0.3),
//                   width: (MediaQuery.of(context).size.width * 0.6)),
//               SizedBox(
//                 // color: Colors.blue,
//                 height: 250,
//                 width: (MediaQuery.of(context).size.width * 0.8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GetBuilder<LoginController>(builder: (_) {
//                     return Column(
//                       children: [
//                         TextField(
//                           controller: _usserController,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.person,
//                               color: Color.fromARGB(90, 0, 0, 0),
//                             ), // Ícono de persona (user)
//                             //labelText: 'Usuario',
//                             hintText: 'Nombre', // Este es el placeholder
//                             fillColor: const Color.fromARGB(14, 96, 125, 139),
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   15.0), // Color del borde
//                             ),
//                             labelStyle: const TextStyle(
//                               color: Color.fromARGB(176, 0, 0,
//                                   0), // Cambia el color del texto aquí
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         TextField(
//                           controller: _usserController,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.email,
//                               color: Color.fromARGB(90, 0, 0, 0),
//                             ), // Ícono de persona (user)
//                             //labelText: 'Usuario',
//                             hintText: 'Correo', // Este es el placeholder
//                             fillColor: const Color.fromARGB(14, 96, 125, 139),
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   15.0), // Color del borde
//                             ),
//                             labelStyle: const TextStyle(
//                               color: Color.fromARGB(176, 0, 0,
//                                   0), // Cambia el color del texto aquí
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         TextField(
//                           obscureText: _.obscureText,
//                           controller: _passController,
//                           //maxLines: 3,
//                           decoration: InputDecoration(
//                             //labelText: 'Pass',
//                             hintText: 'Contraseña', // Este es el placeholder
//                             prefixIcon: const Icon(
//                               Icons.lock,
//                               color: Color.fromARGB(90, 0, 0, 0),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _.obscureText
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: _.togglePasswordVisibility,
//                             ),
//                             fillColor: const Color.fromARGB(14, 96, 125, 139),
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   15.0), // Color del borde
//                             ),
//                             labelStyle: const TextStyle(
//                               color: Color.fromARGB(176, 0, 0,
//                                   0), // Cambia el color del texto aquí
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   const Color.fromARGB(255, 236, 232, 231)),
//                               // Añadir más propiedades de estilo aquí
//                             ),
//                             onPressed: () {
//                               // _.updateData(
//                               //     _usserController.text, _passController.text);
//                               // _.getData();

//                               if (_.pagina != 'nothing') {
//                                 Navigator.pushReplacementNamed(
//                                     context, _.pagina);
//                               } else if (_.usuario.isNotEmpty ||
//                                   _.pass.isNotEmpty) {
//                                 _passController.text = '';
//                                 _usserController.text = '';
//                                 Get.snackbar(
//                                   '',
//                                   'Usuario o Contraseña incorecto,INTENTELO NUEVAMENTE.',
//                                   colorText: Colors.red,
//                                   titleText: const Text('Error'),
//                                   duration: const Duration(seconds: 4),
//                                   showProgressIndicator: true,
//                                   progressIndicatorBackgroundColor:
//                                       const Color.fromARGB(255, 81, 93, 117),
//                                   progressIndicatorValueColor:
//                                       const AlwaysStoppedAnimation(
//                                           Color.fromARGB(255, 241, 130, 84)),
//                                   overlayBlur: 3,
//                                 );
//                               }
//                             },
//                             child: const Text(
//                               'Registrarme',
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: const Color.fromARGB(255, 43, 44, 49),
//                                   fontWeight: FontWeight.w800),
//                             )),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
