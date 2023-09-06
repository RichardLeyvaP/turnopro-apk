// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/customer_model.dart';
import 'package:turnopro_apk/get_connect/repository/customer.repository.dart';

class CustomerController extends GetxController {
  //LLAMANDO AL CONTROLADOR

  CustomerController() {
    getTotalSum();
    calculateTime();
    if (yaEntre == false) {
      _fetchCustomerList(); // Llamar al método asincrónico en el constructor
      getTotalSum();
      yaEntre = true;
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
      update();
    });
  }

  CustomerRepository repository = CustomerRepository();
  bool yaEntre = false;
  double getTotal = 20.0;
  int numero = 5;
  int customerListLength = 0;
  List<CustomerModel> customers = []; // Lista de servicios
  List<CustomerModel> selectCustomer =
      []; // Lista de servicios seleccionados vacia
  int time = 30;
  bool isLoading = true;

  void calculateTime() {
    if (time > 60) {
      //controlando que el tiempo no sea mayor que 60 min
      time = 60;
    }
    if (time < 0) {
      //controlando que el tiempo no sea negativo
      time = 0;
    }
    update();
  }

  getList() {
    return customers;
  }

  getselectCustomer(index) {
    (selectCustomer.contains(customers[index]))
        ? selectCustomer.remove(customers[index])
        : selectCustomer.add(customers[index]);
    update();
  }

  getTotalSum() {
    getTotal = getTotal + 5;

    // getTotal = customers
    //     .map((service) => service.id)
    //     .fold(0.0, (sum, id) => sum + id)
    //     .toDouble();
    // print(getTotal);
    update();
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

  Future<void> _fetchCustomerList() async {
    customers = await repository.getcustomersList();
    customerListLength = customers.length;
    update();
  }

  void addCustomer() {
    CustomerModel newCustomer = CustomerModel(
        id: 12, name: "Cliente $customerListLength", username: "Nuevo Cliente");
    customers.add(newCustomer);
    customerListLength = customers.length; //actualizo la logitud de la lista
    getTotalSum();
    update();
  }

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  void deleteCustomer(int index) {
    if (index >= 0 && index < customers.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectCustomer.contains(customers[index])) {
        selectCustomer.removeWhere((service) => service == customers[index]);
        getTotal = getTotal - 5;
      }
    }
    customers.removeAt(index);
    customerListLength = customers.length;

    update();
  }

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
  void deleteMultipleService() {
    if (selectCustomer.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      customers.removeWhere((element) => selectCustomer.contains(element));
      customerListLength = customers.length;
      selectCustomer = [];
      getTotal = getTotal - 5;
      update();
    }
  }

  void deleteAll() {
    customers = [];
    selectCustomer = [];
    customerListLength = customers.length;
    getTotal = 0.0;
    update();
  }
}
