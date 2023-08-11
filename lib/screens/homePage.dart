// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:turnopro_apk/components/BottomNavigationBar.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = 12;
    const Color colorVariable = Color.fromARGB(255, 26, 50, 82);
    const Color colorBottom =
        Color.fromARGB(255, 231, 233, 233); // Define el color a través de una
    const iconCart = (Icons.perm_contact_calendar);
    String titleCart = 'Agenda';
    String descriptionTitleCart = 'Clientes Agendados';

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        appBar: CustomAppBar(),
        body: Column(
          children: [
            Expanded(
              flex: 1, // 20% del espacio disponible para esta parte
              // child: bannerProfile(context),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadiusValue)),
                    color: const Color.fromARGB(255, 241, 130, 84),
                  ),
                ),
              ), //Header
            ),
            Expanded(
                flex: 2, // 85% del espacio disponible para esta parte
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      color: const Color.fromARGB(255, 231, 232, 234),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cartsHome(
                                      context,
                                      borderRadiusValue,
                                      colorVariable,
                                      colorBottom,
                                      titleCart,
                                      descriptionTitleCart,
                                      iconCart),
                                  cartsHome(
                                      context,
                                      borderRadiusValue,
                                      const Color.fromARGB(255, 81, 93, 117),
                                      colorBottom,
                                      'Notificaciones',
                                      'Tus Notificaciones',
                                      Icons.notifications),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cartsHome(
                                      context,
                                      borderRadiusValue,
                                      const Color.fromARGB(255, 177, 174, 174),
                                      colorBottom,
                                      'Estadisticas',
                                      'Revisa Tus Ingresos',
                                      Icons.bar_chart),
                                  cartsHome(
                                      context,
                                      borderRadiusValue,
                                      const Color.fromARGB(255, 241, 130, 84),
                                      colorBottom,
                                      'Convivencia',
                                      'Cumplimiento de Reglas',
                                      Icons.star_border),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
          child: BottomNavigationBarNew(),
        ));
  }

  Container cartsHome(
      BuildContext context,
      double borderRadiusValue,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.height * 0.21),
      height: (MediaQuery.of(context).size.height * 0.22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 20, // Tamaño del CircleAvatar
                backgroundColor: colorBottom, // Color de fondo del CircleAvatar
                child: Icon(
                  iconCart, // Icono que deseas mostrar
                  size: 30, // Tamaño del icono
                  color:
                      const Color.fromARGB(255, 26, 50, 82), // Color del icono
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  descriptionTitleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  String nameUser = 'Paula Rego';
  String imageDirection = 'assets/images/image_perfil.jpg';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Oculta la flecha de retroceso
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 32, 32, 32),
                width: 2, // Ajusta el ancho del borde según tus preferencias
              ),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(imageDirection),
              radius: 25, // Ajusta el tamaño del círculo aquí
            ),
          ),
          const SizedBox(width: 10), // Espacio entre la imagen y el texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hola',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Text(
                nameUser,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {
            // Acción al presionar el ícono de ajustes
          },
        ),
      ],
    );
  }
}
