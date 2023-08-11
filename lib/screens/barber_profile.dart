// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:turnopro_apk/sidebar/MenuLateral.dart';
import 'package:turnopro_apk/components/BottomNavigationBar.dart';
//LLamadas de paginas
//import 'package:barbershop/presentation/screens/page_show_customers.dart';

class BarberProfile extends StatefulWidget {
  const BarberProfile({super.key});

  @override
  State<BarberProfile> createState() => _BarberProfileState();
}

class _BarberProfileState extends State<BarberProfile> {
  int clicK = 0;
  final String name = 'WILIAM MILLER';
  final String typeCut = 'Corte Normal';
  final String typeWashed = 'Lavado y Secado';
  final String title = 'PERFIL';

  @override
  Widget build(BuildContext context) {
    final _widthTextTitle = (MediaQuery.of(context).size.width / 20);
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            flex: 1, // 20% del espacio disponible para esta parte
            child: bannerProfile(context),
          ),
          Expanded(
            flex: 3, // 85% del espacio disponible para esta parte
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storage,
                          size: 24,
                        ),
                        const SizedBox(
                            width: 8), // Espacio entre el icono y el texto
                        Text(
                          'SERVICIOS',
                          style: TextStyle(
                            fontSize: _widthTextTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  typesServices(context),
                  typesServices(context),
                  typesServices(context),
                  typesServices(context),
                  typesServices(context),
                  typesServices(context),
                  typesServices(context),
                ],
              ),
            ),
          )
        ],
      ),

/*ESTE ES EL PRIMERO QUE HICE 'AGENDAMIENTO DE CLIENTES'
const SingleChildScrollView(
        child: ShowCustomers(name: name, clicK: clicK, typeCut: typeCut, typeWashed: typeWashed),
      )*/

      floatingActionButton: floatingButton(),
      drawer: const MenuLateral(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BottomNavigationBarNew(),
      ),
    );
  }

//HEADER CON LA FOTO DEL PERFIL Y EL NOMBRE
  Container bannerProfile(BuildContext context) {
    const String name = 'WILLIAM MILLER';
    const String imagePerson =
        'https://th.bing.com/th/id/R.1679993f34aba713da2d2fc704b0c569?rik=6DaSn%2fUFKwwEtA&pid=ImgRaw&r=0';
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 46, 45, 45),
      child: Column(
        children: [
          if (imagePerson != '')
            const Expanded(
              child: ClipOval(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(imagePerson),

                  // Redimensiona y recorta la imagen para que se ajuste al círculo
                ),
              ),
            ),
          //ESTE ESRA EL CODIGO QUE ESTABA ANTERIORMENTE CON EL ICON DE PERSON PARA CUANDO NO TENGA FOTO EL USUARIO
          if (imagePerson == '')
            const Icon(
              Icons.person,
              size: 140,
              color: Color.fromARGB(255, 245, 206, 89),
            ),
          Text(
            name,
            style: TextStyle(
                color: const Color.fromARGB(255, 245, 206, 89),
                fontSize: (MediaQuery.of(context).size.width / 15),
                fontWeight: FontWeight.w700),
          )
        ],
      ),
      //Dar espacio en los wid que yo quiera
    );
  }

//CONTAINER CON LOS TIPOS DE SERVICIOS
  Padding typesServices(BuildContext context) {
    final _widthTextNormal = (MediaQuery.of(context).size.width / 23);
    final _circleScissors = (MediaQuery.of(context).size.width / 13);
    final _heightContainerService = (MediaQuery.of(context).size.height / 12);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromARGB(255, 46, 45, 45),
        ),
        height: _heightContainerService,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: _circleScissors,
                  height: _circleScissors,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.content_cut_rounded,
                    size: _widthTextNormal,
                  ),
                ),
                const SizedBox(width: 8), // Espacio entre el icono y el texto
                Text(
                  'Corte Normal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _widthTextNormal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              '\$12.99',
              style: TextStyle(color: Colors.amber),
            )
          ],
        ),
      ),
    );
  }

  Container floatingButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 241, 212, 74).withOpacity(0.5),
            spreadRadius: 7,
            blurRadius: 7,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 43, 44, 49),
        onPressed: () {
          clicK++;
          setState(() {});
        },
        child: const Icon(Icons.add,
            color: Color.fromARGB(255, 241, 212, 74), size: 50.0),
      ),
    );
  }
}
