// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:get/get.dart';

class ShoppingCartPage extends StatelessWidget {
  ShoppingCartPage({super.key});
  final double valuePadding = 12;
  final String imageDirection = 'assets/images/image_perfil.jpg';

  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return Scaffold(
        appBar: AppBar(
          leading: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 50,
                  ),
                  Text(
                    'Carro de Compra',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.14),
              ),
            ],
          ),
          //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
          elevation: 0, // Quits the shadow
          //shadowColor: Colors.amber, // Removes visual elevation
        ),
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Column(
          children: [
            controllerShoppingCart.serviceListLength > 0
                ? Text(
                    'Servicios Solicitados',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height * 0.02),
                        fontWeight: FontWeight.w900),
                  )
                : const Text(''),
            controllerShoppingCart.serviceListLength > 0
                ? Expanded(
                    flex:
                        heightFlexBody, // 85% del espacio disponible para esta parte
                    child: ListView.builder(
                        itemCount: controllerShoppingCart.serviceListLength,
                        itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.fromLTRB(
                                  (MediaQuery.of(context).size.height * 0.013),
                                  (MediaQuery.of(context).size.height * 0.006),
                                  (MediaQuery.of(context).size.height * 0.013),
                                  (MediaQuery.of(context).size.height * 0.006)),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  children: [
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.08),
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              1),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(-5,
                                                5), // Ajusta los valores para personalizar la sombra
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(borderRadiusValue)),
                                      ),
                                      child: ListTile(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.77,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          controllerShoppingCart
                                                              .selectserviceCart[
                                                                  index]
                                                              .nameService
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                        Text(
                                                          controllerShoppingCart
                                                              .selectserviceCart[
                                                                  index]
                                                              .price_service
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GetBuilder<
                                                      ShoppingCartController>(
                                                  builder: (_) {
                                                return InkWell(
                                                  onTap: () {
                                                    //todooo
                                                    Get.snackbar(
                                                      'Mensaje',
                                                      'Enviada solicitud de eliminación.',
                                                      duration: const Duration(
                                                          milliseconds: 2000),
                                                    );
                                                    controllerShoppingCart
                                                        .requestDelete(
                                                            controllerShoppingCart
                                                                .selectserviceCart[
                                                                    index]
                                                                .id,
                                                            1);
                                                  },
                                                  child: _.requestDeleteOrder.contains(
                                                          controllerShoppingCart
                                                              .selectserviceCart[
                                                                  index]
                                                              .id)
                                                      ? const Icon(
                                                          Icons.delete,
                                                          size: 35,
                                                          color: Color.fromARGB(
                                                              105,
                                                              241,
                                                              130,
                                                              84),
                                                        )
                                                      : const Icon(
                                                          Icons.delete,
                                                          size: 35,
                                                          color: Color.fromARGB(
                                                              255,
                                                              241,
                                                              130,
                                                              84),
                                                        ),
                                                );
                                              })
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  )
                : const Text(''),
            controllerShoppingCart.productListLength > 0
                ? Text(
                    'Productos Solicitados',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height * 0.02),
                        fontWeight: FontWeight.w900),
                  )
                : const Text(''),
            controllerShoppingCart.productListLength != -99
                ? controllerShoppingCart.productListLength > 0
                    ? Expanded(
                        flex:
                            heightFlexBody, // 85% del espacio disponible para esta parte

                        child: ListView.builder(
                            //todo builder
                            itemCount: controllerShoppingCart.productListLength,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006),
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006)),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(-5,
                                                    5), // Ajusta los valores para personalizar la sombra
                                              ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        borderRadiusValue)),
                                          ),
                                          child: ListTile(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.77,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              controllerShoppingCart
                                                                  .selectproduct[
                                                                      index]
                                                                  .name
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            Text(
                                                              controllerShoppingCart
                                                                  .selectproduct[
                                                                      index]
                                                                  .sale_price
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GetBuilder<
                                                          ShoppingCartController>(
                                                      builder: (_) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.snackbar(
                                                          'Mensaje',
                                                          'Enviada solicitud de eliminación.',
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      2000),
                                                        );
                                                        //todooo
                                                        controllerShoppingCart
                                                            .requestDelete(
                                                                controllerShoppingCart
                                                                    .selectproduct[
                                                                        index]
                                                                    .id,
                                                                1);
                                                      },
                                                      child: _.requestDeleteOrder
                                                              .contains(
                                                                  controllerShoppingCart
                                                                      .selectproduct[
                                                                          index]
                                                                      .id)
                                                          ? const Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: Color
                                                                  .fromARGB(
                                                                      105,
                                                                      241,
                                                                      130,
                                                                      84),
                                                            )
                                                          : const Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      241,
                                                                      130,
                                                                      84),
                                                            ),
                                                    );
                                                  })
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    : const Text('')
                : const Text(
                    'Fallo su conexion a Internet,por favor revise su conexión.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a pagar:',
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height * 0.02),
                      fontWeight: FontWeight.w900),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogPago(
                          totalPrice: controllerShoppingCart.totalPrice,
                        ); // Muestra el AlertDialog
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(borderRadiusValue)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 140, 141, 143),
                              Color.fromARGB(255, 241, 130, 84),
                            ],
                            stops: [0.0, 0.8],
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                          )),
                      child: const Center(child: Text('Confirmar')),
                    ),
                  ),
                ),
                Text(
                  controllerShoppingCart.totalPrice.toStringAsFixed(2),
                  /*esto garantiza 2 lugares despues de la coma */
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height * 0.031),
                      fontWeight: FontWeight.w800),
                ),
              ],
            )
          ],
        ));
  }
}

class AlertDialogPago extends StatelessWidget {
  final double totalPrice;

  const AlertDialogPago({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmación'),
      content: SizedBox(
        height: 50.0, // Ajusta la altura según tu necesidad
        child: Column(
          mainAxisSize: MainAxisSize.min, // Establece el tamaño mínimo
          children: [
            const Text('¿Desea Confirmar el pago?'),
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.height * 0.02),
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            Navigator.of(context).pop();
          },
          child: const Text('Aceptar'),
        ),
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
