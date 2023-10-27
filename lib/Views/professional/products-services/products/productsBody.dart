// ignore_for_file: file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ShoppingCartController controllerShoppingCart =
      Get.put(ShoppingCartController());

  final ProductController controllerProduct = Get.find<ProductController>();

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

    return GetBuilder<ProductController>(builder: (controllerProduct) {
      return controllerProduct.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFFF18254),
            ))
          : Column(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.width) * 0.09,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    indicatorColor: const Color(0xFFF18254),
                    controller: _tabController,
                    tabs: tabs2,
                    onTap: (int tabIndex) {
                      // Llama al método del controlador y pasa el valor deseado
                      controllerProduct.fetchproductList(tabsID[tabIndex]);
                    },
                  ),
                ),
                controllerProduct.productListLength != -99
                    ? Expanded(
                        child: TabBarView(
                        controller: _tabController,
                        children: List<Widget>.generate(
                          tabs2.length,
                          (index) {
                            return ListView.builder(
                              itemCount: controllerProduct.productListLength,
                              itemBuilder: (context, itemIndex) => Column(
                                children: [
                                  controllerProduct.productListLength != 0 &&
                                          controllerProduct.productListLength >
                                              0
                                      ? newMethod(
                                          'assets/images/pngegg.png',
                                          controllerProduct
                                              .product[itemIndex].id,
                                          controllerProduct
                                              .product[itemIndex].name,
                                          controllerProduct
                                              .product[itemIndex].product_exit,
                                          controllerProduct
                                              .product[itemIndex].description,
                                          controllerProduct
                                              .product[itemIndex].sale_price,
                                          context,
                                          controllerShoppingCart,
                                          itemIndex,
                                        )
                                      : controllerProduct.productListLength == 0
                                          ? const Text('')
                                          : const Text(
                                              'Fallo la carga de los datos, revise su coneccion a internet'),
                                  SizedBox(
                                    height: (MediaQuery.of(context).size.width *
                                        0.02),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ))
                    : const Text(
                        'Falló la conexion,revise su coneccion de Internet.'),
              ],
            );
    });
  }
}

Padding newMethod(
    String addressProduct,
    int id,
    String productName,
    int productExit,
    String propertiesName,
    String priceProduct,
    BuildContext context,
    ShoppingCartController controllerShoppingCart,
    itemIndex) {
  //VARIABLES DE PROPIEDADES DEL WIDGET
  const double borderRadiusValue = 12; //container que carga la imagen
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height * 0.26),
              width: (MediaQuery.of(context).size.width * 0.4),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadiusValue)),
                  color: Color(0xFFF18254)),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          propertiesName,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(148, 0, 0, 0)),
                        ),
                        Text(
                          'Cantidad Disponible: $productExit',
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(148, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        priceProduct,
                        style: TextStyle(
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.03),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controllerShoppingCart.updateShoppingCartValue(
                                  itemIndex, 'product', id);
                            },
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.035),
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
                                        (MediaQuery.of(context).size.width *
                                            0.03),
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                          CircleAvatar(
                            radius: (MediaQuery.of(context).size.width *
                                0.04), // Ajusta este valor según tu preferencia
                            backgroundColor: const Color(0xFFF18254),
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
      ],
    ),
  );
}
