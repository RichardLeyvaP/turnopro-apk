// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProductsBody extends StatefulWidget {
  const ProductsBody({super.key});

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabValues = ["Especializados", "Snacks", "Otros"];

    return Column(
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.width) * 0.09,
          child: TabBar(
              labelColor: Colors.black,
              indicatorColor: const Color.fromARGB(255, 241, 130, 84),
              controller: _tabController,
              tabs: [
                Text(tabValues[0]),
                Text(tabValues[1]),
                Text(tabValues[2]),
              ]),
        ),
        SizedBox(
          height: (MediaQuery.of(context).size.width * 0.005),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  newMethod('assets/images/pngegg.png', 'Coca Cola',
                      'Coca Cola Max 350ml', 2.559, context),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width * 0.02),
                  ),
                  newMethod('assets/images/pngegg.png', 'Coca Cola',
                      'Coca Cola Max 350ml', 2.559, context),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width * 0.02),
                  ),
                  newMethod('assets/images/pngegg.png', 'Coca Cola',
                      'Coca Cola Max 350ml', 2.559, context),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_business_outlined,
                  size: 80,
                ),
                Text(
                  'Contenido SNACKS',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.addchart_outlined,
                  size: 80,
                ),
                Text(
                  'Contenido de OTROS',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        )),
      ],
    );
  }
}

Row newMethod(String addressProduct, String productName, String propertiesName,
    double priceProduct, BuildContext context) {
  //VARIABLES DE PROPIEDADES DEL WIDGET
  const double borderRadiusValue = 12; //container que carga la imagen
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        height: (MediaQuery.of(context).size.height * 0.26),
        width: (MediaQuery.of(context).size.width * 0.4),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
            color: Color.fromARGB(255, 241, 130, 84)),
        child: FractionallySizedBox(
          widthFactor: 0.6, // 50% del ancho del contenedor padre
          heightFactor: 0.65, // 50% del alto del contenedor padre
          child: Center(
            child: Image.asset(addressProduct),
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      SizedBox(
        height: (MediaQuery.of(context).size.height * 0.26),
        width: (MediaQuery.of(context).size.width * 0.4),
        child: Column(
          //AQUI ES LA PARTE DERECHA DE LOS DATOS DEL PRODUCTO
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                productName,
                style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width * 0.06),
                    fontWeight: FontWeight.w900),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                propertiesName,
                style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width * 0.03)),
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.width * 0.09),
            ),
            Text(
              '$priceProduct',
              style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.08),
                  fontWeight: FontWeight.w900),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height * 0.035),
                  width: (MediaQuery.of(context).size.width * 0.2),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(95, 46, 20, 20),
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadiusValue)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 238, 234, 234),
                        Color.fromARGB(255, 134, 134, 136),
                      ],
                      stops: [0.0, 0.8],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Agregar',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.width * 0.03),
                        fontWeight: FontWeight.w600),
                  )),
                ),
                CircleAvatar(
                  radius: (MediaQuery.of(context).size.width *
                      0.04), // Ajusta este valor según tu preferencia
                  backgroundColor: const Color.fromARGB(255, 241, 130, 84),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: (MediaQuery.of(context).size.height * 0.03),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ],
  );
}
