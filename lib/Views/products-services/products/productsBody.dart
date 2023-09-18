// ignore_for_file: file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';

class ProductsBody extends StatefulWidget {
  final ProductController controllerProduct;

  const ProductsBody({
    Key? key,
    required this.controllerProduct,
  }) : super(key: key);

  @override
  State<ProductsBody> createState() =>
      _ProductsBodyState(controllerProduct: controllerProduct);
}

class _ProductsBodyState extends State<ProductsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductController controllerProduct;

  _ProductsBodyState({required this.controllerProduct});

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: controllerProduct.categoryListLength, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //*AQUI CREO LA LISTA con los nombres que tiene categorias de productos que vienen de la api
    List<String> tabValues = [];

    var tabsID = [];
    for (int i = 0; i < controllerProduct.categoryListLength; i++) {
      tabValues.add(controllerProduct.category[i].name);
      tabsID.add(controllerProduct.category[i].id);
    }
    //*AQUI ASIGNO A tabs los nombres que tiene la lista de categorias de productos
    var tabs2 = <Widget>[];
    for (int i = 0; i < controllerProduct.categoryListLength; i++) {
      tabs2.add(Text(tabValues[i]));
    }

    return GetBuilder<ProductController>(builder: (_) {
      return _.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 241, 130, 84),
            ))
          : Column(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.width) * 0.09,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    indicatorColor: const Color.fromARGB(255, 241, 130, 84),
                    controller: _tabController,
                    tabs: tabs2,
                    onTap: (int tabIndex) {
                      // Llama al método del controlador y pasa el valor deseado
                      controllerProduct.fetchproductList(tabsID[tabIndex]);
                    },
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: List<Widget>.generate(
                    tabs2.length,
                    (index) {
                      return ListView.builder(
                        itemCount: _.productListLength,
                        itemBuilder: (context, itemIndex) => Column(
                          children: [
                            newMethod(
                              'assets/images/pngegg.png',
                              _.product[itemIndex].name,
                              _.product[itemIndex].description,
                              _.product[itemIndex].sale_price,
                              context,
                              controllerProduct,
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width * 0.02),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
              ],
            );
    });
  }
}

Padding newMethod(
    String addressProduct,
    String productName,
    String propertiesName,
    String priceProduct,
    BuildContext context,
    ProductController controllerProduct) {
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
                      InkWell(
                        onTap: () {
                          controllerProduct.updateAppBarValue(1);
                        },
                        child: Container(
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
