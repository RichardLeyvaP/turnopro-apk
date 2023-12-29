// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Views/products-services/products/productsBody.dart';
import 'package:turnopro_apk/Views/products-services/services/servicesBodyPage.dart';
//import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';

class ServicesProductsPage extends StatefulWidget {
  const ServicesProductsPage({super.key});

  @override
  State<ServicesProductsPage> createState() => _ServicesProductsPageState();
}

class _ServicesProductsPageState extends State<ServicesProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //final ServiceController controller = Get.put(ServiceController());

  final ProductController controllerProduct = Get.put(ProductController());

  final ServiceController controllerService = Get.find<ServiceController>();
  final ClientsScheduledController clientsController =
      Get.find<ClientsScheduledController>();
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controllerProduct.initializeData();
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

        appBar: AppBar(
          backgroundColor: const Color(0xFFF18254), // Color de fondo del AppBar
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
                  pagesConfigC.previousPage();
                  //Get.back();
                }, // Evento onPress
              ),
              Column(
                children: [
                  Icon(
                    Icons.person,
                    size: (MediaQuery.of(context).size.width * 0.22),
                  ),
                  Text(clientsController.nameClientTemporary,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),

              GetBuilder<ShoppingCartController>(builder: (_) {
                return Badge(
                    label: Text(_.shoppingCart.toString()),
                    child: _.shoppingCart == 0
                        ? IconButton(
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 30,
                            ), // Icono que deseas mostrar
                            onPressed: () {
                              Get.snackbar(
                                'Mensaje del Carrito de Compra',
                                'Su carrito esta vacio',
                                duration: const Duration(milliseconds: 2500),
                                showProgressIndicator: true,
                                progressIndicatorBackgroundColor:
                                    const Color.fromARGB(255, 81, 93, 117),
                                progressIndicatorValueColor:
                                    const AlwaysStoppedAnimation(
                                        Color(0xFFF18254)),
                                overlayBlur: 3,
                              );
                            }, // Evento onPress
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 30,
                            ), // Icono que deseas mostrar
                            onPressed: () async {
                              // Muestra el indicador de carga
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFF18254),
                                  ),
                                ),
                                barrierDismissible: false,
                              );

                              try {
                                await _.loadCart();
                                // await Future.delayed(
                                //     Duration(seconds: 3)); //todo esperar 3 segundos
                                // Oculta el indicador de carga y navega a la página del carrito
                                Get.back(); // Cierra el diálogo

                                // Get.toNamed('/ShoppingCartPage');
                                pagesConfigC.nextPage();
                              } catch (e) {
                                // En caso de error, oculta el indicador de carga y muestra un mensaje de error
                                Get.back();
                                Get.snackbar('Error',
                                    'Hubo un error al cargar el carrito: $e');
                              }
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
                  labelColor: const Color(0xFFF18254),
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
        body: controllerShoppingCart.internetError != -99
            ? TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    color: backgroundColor,
                    child:
                        ServicesBodyPage(), //RLP AQUI SE CARGA LA PAGINA DE LOS SERVICIOS
                  ),
                  Container(
                    color: backgroundColor,
                    child: const ProductsBody(),
                  ),
                ],
              )
            : AlertDialogPago(
                controllerShoppingCart:
                    controllerShoppingCart), // Muestra el AlertDialog
      ),
    );
  }
}

class AlertDialogPago extends StatelessWidget {
  final ShoppingCartController controllerShoppingCart;
  const AlertDialogPago({Key? key, required this.controllerShoppingCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const SizedBox(
        height: 30.0, // Ajusta la altura según tu necesidad
        child: Column(
          mainAxisSize: MainAxisSize.min, // Establece el tamaño mínimo
          children: [
            FittedBox(
                fit: BoxFit.contain,
                child: Text('Por favor revise su conexión a Internet')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            Get.back();
          },
          child: const Text('Atras'),
        ),
        TextButton(
          onPressed: () async {
            // Cerrar el AlertDialog
            try {
              await controllerShoppingCart.loadDataInitiallyNecessary();
              Get.toNamed(
                '/Professional',
              );
            } catch (e) {
              Get.toNamed(
                '/Professional',
              );
            }
          },
          child: const Text('Volver Intentarlo'),
        ),
      ],
    );
  }
}
