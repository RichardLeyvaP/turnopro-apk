// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 43, 44, 49),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/profile.png'))),
              child: Text('MENÚ', textAlign: TextAlign.start),
            ),
          ),
          ListTile(title: Text('Inicio')),
          ListTile(
            title: Text('Administración'),
          ),
          ListTile(
            title: Text('Contactanos'),
          ),
          ListTile(title: Text('Ayuda'))
        ],
      ),
    );
  }
}
