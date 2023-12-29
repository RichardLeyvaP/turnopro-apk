//****************************************************************************** */
//****************************************************************************** */

import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  YourPageViewScreenState createState() => YourPageViewScreenState();
}

class YourPageViewScreenState extends State<HomePageView> {
  PageController _pageController = PageController();

  bool isPageViewEnabled =
      false; // Variable para habilitar/deshabilitar PageView.
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Probando PageView')),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPageViewEnabled = !isPageViewEnabled;
                  });
                },
                child:
                    Text(isPageViewEnabled ? 'Deshab Scroll' : 'Habili Scroll'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Cambiar a la siguiente página.
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Text('Siguiente Página'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cambiar a la siguiente página.
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                child: Text('Atras'),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: isPageViewEnabled
                  ? BouncingScrollPhysics() // Habilitar desplazamiento
                  : NeverScrollableScrollPhysics(), // Deshabilitar desplazamiento
              onPageChanged: (index) {
                // Almacena el índice de la página actual cuando cambia.

                setState(() {
                  currentPageIndex = index;
                });
              },
              children: [
                // Agrega tus páginas aquí
                Container(
                  color: Colors.red,
                  child: Center(
                    child: Text('Página 1'),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Página 2'),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text('Página 3'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//****************************************************************************** */
//****************************************************************************** */
