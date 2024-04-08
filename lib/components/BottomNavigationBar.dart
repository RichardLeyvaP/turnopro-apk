// ignore_for_file: file_names, prefer_final_fields
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigationBarNew extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BottomNavigationBarNew({super.key});

  @override
  State<BottomNavigationBarNew> createState() => _BottomNavigationBarNewState();
}

class _BottomNavigationBarNewState extends State<BottomNavigationBarNew> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    const ProfilePage(), // Página 0
    const AgendaPage(), // Página 1
    const NotificationsPage(), // Página 2
    const StatisticsPage(), // Página 3
    const HomePage(), // Página 4
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      _pages[_selectedIndex];
    });
  }

/*
  void _navigateBottomBar(int index) {
    _selecteIndex = index;
    setState(() {});
    //Navigator.pushReplacementNamed(context, '/servicesProductsPage');
    if (_selecteIndex == 0) {
      Navigator.pushNamed(context, '/servicesPage');
    }
    if (_selecteIndex != 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text('Todavia no esta Implementado.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Cerrar el AlertDialog
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  */

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
            fixedColor: const Color(0xFFFDAE2A),
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _navigateBottomBar,
            items: [
              BottomNavigationBarItem(
                  icon: Badge(
                    label: Text('$_selectedIndex'),
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
                    label: Text('$_selectedIndex'),
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
                  label: 'Estadística'),
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

// Define tus páginas correspondientes aquí
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Perfil Page'));
  }
}

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Agenda Page'));
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notificaciones Page'));
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Estadísticas Page'));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}
