//  //Future<List<UserModel>> userList() async => await repository.getUserList();

// //***************************************************************
// //*METODOS ELIMINAR

//   //*ELIMINAR 1 ELEMENTO
//   void deleteproduct(int index) {
//     if (index >= 0 && index < product.length) {
//       //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
//       //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

//       if (selectproduct.contains(product[index])) {
//         selectproduct.removeWhere((products) => products == product[index]);
//       }
//     }
//     product.removeAt(index);
//     productListLength = product.length;

//     update();
//   }

//   //*ELIMINAR  ELEMENTOS SELECCIONADOS
//   void deleteMultipleproduct() {
//     if (selectproduct.isNotEmpty) {
//       //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
//       //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
//       product.removeWhere((element) => selectproduct.contains(element));
//       productListLength = product.length;
//       selectproduct = [];
//       update();
//     }
//   }

//   void deleteAll() {
//     product = [];
//     selectproduct = [];
//     productListLength = product.length;
//     update();
//   }