// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HeaderPage extends StatefulWidget {
  const HeaderPage({super.key});

  @override
  State<HeaderPage> createState() => _HeaderPageState();
}

class _HeaderPageState extends State<HeaderPage> {
  BoxDecoration clickProductsDecoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
  BoxDecoration clickServicesDecoration = const BoxDecoration();
  bool onTapService = true;
  bool onTapProduct = false;

  @override
  Widget build(BuildContext context) {
    const String name = 'WILLIAM MILLER';
    const String imagePerson = '';
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 130, 84),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
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
                Icon(
                  Icons.person,
                  size: (MediaQuery.of(context).size.height * 0.08),
                  color: Colors.white,
                ),
              SizedBox(
                width: (MediaQuery.of(context).size.height * 0.08),
              ),
            ],
          ),
          Text(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: (MediaQuery.of(context).size.height * 0.03),
                fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width * 0.85),
                height: (MediaQuery.of(context).size.width * 0.08),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(155, 231, 232, 234),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/servicesProductsPage');
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width * 0.425),
                        height: (MediaQuery.of(context).size.width * 0.08),
                        decoration: clickServicesDecoration,
                        child: const Center(
                            child: Text(
                          'Servicios',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                    Container(
                      decoration: clickProductsDecoration,
                      width: (MediaQuery.of(context).size.width * 0.425),
                      height: (MediaQuery.of(context).size.width * 0.08),
                      child: const Center(
                          child: Text(
                        'Productos',
                        style: TextStyle(
                            color: Color.fromARGB(255, 241, 130, 84),
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height * 0.01),
          )
        ],
      ),
      //Dar espacio en los wid que yo quiera
    );
  }
}
