// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Views/products-services/products/productsBody.dart';
import 'package:turnopro_apk/Views/products-services/services/servicesBodyPage.dart';
//import 'package:turnopro_apk/Views/products-services/services/servicesBody.dart';
import '../../Components/BottomNavigationBar.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class ServicesProductsPage extends StatefulWidget {
  const ServicesProductsPage({super.key});

  @override
  State<ServicesProductsPage> createState() => _ServicesProductsPageState();
}

class _ServicesProductsPageState extends State<ServicesProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ServiceController controller = Get.put(ServiceController());
  final ProductController controllerProduct = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //VARIABLE A UTILIZAR
    BoxDecoration clickServicesDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    BoxDecoration decorationBackground = const BoxDecoration(
      color: Color.fromARGB(155, 231, 232, 234),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    const backgroundColor = Color.fromARGB(255, 231, 232, 234);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
          child: BottomNavigationBarNew(),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 241, 130, 84), // Color de fondo del AppBar
          elevation: 0, // Sombra del AppBar
          toolbarHeight: 120, // Altura del AppBar
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
          // ],

          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back), // Icono que deseas mostrar
                onPressed: () {
                  Get.back();
                }, // Evento onPress
              ),
              Column(
                children: [
                  Icon(
                    Icons.person,
                    size: (MediaQuery.of(context).size.width * 0.22),
                  ),
                  const Text('RICHARD LEYVA',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              StreamBuilder<int>(
                  stream: controllerProduct.shoppingCart.stream,
                  builder: (context, snapshot) {
                    return Badge(
                        label: Text(snapshot.data?.toString() ?? '0'),
                        child: snapshot.data != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  size: 30,
                                ), // Icono que deseas mostrar
                                onPressed: () {
                                  Get.snackbar(
                                    'Mensaje del Carrito de Compra',
                                    'LLamar a la pagina correspondiente',
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 81, 93, 117),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color.fromARGB(255, 241, 130, 84)),
                                    overlayBlur: 3,
                                  );
                                }, // Evento onPress
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 30,
                                ), // Icono que deseas mostrar
                                onPressed: () {
                                  Get.snackbar(
                                    'Mensaje',
                                    snapshot.data.toString(),
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 81, 93, 117),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color.fromARGB(255, 241, 130, 84)),
                                    overlayBlur: 3,
                                  );
                                }, // Evento onPress
                              ));
                  }),
              // const Text("          "),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50), // Altura del TabBar
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                width: (MediaQuery.of(context).size.width * 0.8),
                height: (MediaQuery.of(context).size.width * 0.07),
                decoration: decorationBackground,
                child: TabBar(
                  // isScrollable: true,//rlp si son muchos tab para que tenga scroll entre los tab
                  indicator: clickServicesDecoration,
                  labelColor: const Color.fromARGB(255, 241, 130, 84),
                  unselectedLabelColor: Colors.white,
                  automaticIndicatorColorAdjustment: false,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Servicios'),
                    Tab(text: 'Productos'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              color: backgroundColor,
              child:
                  const ServicesBodyPage(), //RLP AQUI SE CARGA LA PAGINA DE LOS SERVICIOS
            ),
            Container(
              color: backgroundColor,
              child: ProductsBody(controllerProduct: controllerProduct),
            ),
          ],
        ),
      ),
    );
  }
}
