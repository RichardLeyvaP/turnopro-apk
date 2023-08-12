// ignore_for_file: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigationBarNew extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BottomNavigationBarNew({super.key});

  @override
  State<BottomNavigationBarNew> createState() => _BottomNavigationBarNewState();
}

class _BottomNavigationBarNewState extends State<BottomNavigationBarNew> {
  int _selecteIndex = 0;

  void _navigateBottomBar(int index) {
    _selecteIndex = index;
    setState(() {});
    //Navigator.pushReplacementNamed(context, '/servicesProductsPage');
    Navigator.pushNamed(context, '/servicesPage');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 43, 44, 49),
            fixedColor: const Color.fromARGB(255, 241, 130, 84),
            currentIndex: _selecteIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _navigateBottomBar,
            items: [
              BottomNavigationBarItem(
                  icon: Badge(
                    label: Text('$_selecteIndex'),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                  label: 'Perfil'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.storage,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  label: 'Agenda'),
              BottomNavigationBarItem(
                  icon: Badge(
                    label: Text('$_selecteIndex'),
                    child: Icon(
                      Icons.notifications,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                  label: 'Notificaciones'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bar_chart,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  label: 'Estadistica'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_emoticon,
                  size: MediaQuery.of(context).size.width * 0.08,
                ),
                label: 'Home',
              ),
            ]));
  }
}
