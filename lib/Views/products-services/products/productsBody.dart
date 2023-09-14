// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';

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

    return GetBuilder<ProductController>(builder: (_) {
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
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                itemCount: _.productListLength,
                itemBuilder: (context, index) => Column(
                  children: [
                    newMethod(
                        'assets/images/pngegg.png',
                        _.product[index].name,
                        _.product[index].description,
                        _.product[index].sale_price,
                        context),
                    SizedBox(
                      height: (MediaQuery.of(context).size.width * 0.02),
                    ),
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
    });
  }
}

Padding newMethod(String addressProduct, String productName,
    String propertiesName, String priceProduct, BuildContext context) {
  //VARIABLES DE PROPIEDADES DEL WIDGET
  const double borderRadiusValue = 12; //container que carga la imagen
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height * 0.26),
          width: (MediaQuery.of(context).size.width * 0.4),
          decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadiusValue)),
              color: Color.fromARGB(255, 241, 130, 84)),
          child: FractionallySizedBox(
            widthFactor: 0.6, // 50% del ancho del contenedor padre
            heightFactor: 0.65, // 50% del alto del contenedor padre
            child: Center(
              child: Image.asset(addressProduct),
            ),
          ),
        ),
        SizedBox(
          height: (MediaQuery.of(context).size.height * 0.26),
          width: (MediaQuery.of(context).size.width * 0.52),
          child: Column(
            //AQUI ES LA PARTE DERECHA DE LOS DATOS DEL PRODUCTO
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                title: Text(
                  productName,
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.05),
                      fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  propertiesName,
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.03)),
                ),
              ),
              ListTile(
                title: Center(
                  child: Text(
                    priceProduct,
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.width * 0.06),
                        fontWeight: FontWeight.w900),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height * 0.035),
                        width: (MediaQuery.of(context).size.width * 0.2),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(95, 46, 20, 20),
                          borderRadius: BorderRadius.all(
                              Radius.circular(borderRadiusValue)),
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
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.03),
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                      CircleAvatar(
                        radius: (MediaQuery.of(context).size.width *
                            0.04), // Ajusta este valor según tu preferencia
                        backgroundColor:
                            const Color.fromARGB(255, 241, 130, 84),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: (MediaQuery.of(context).size.height * 0.03),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
