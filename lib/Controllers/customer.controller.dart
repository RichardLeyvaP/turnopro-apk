// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/customer_model.dart';
import 'package:turnopro_apk/get_connect/repository/customer.repository.dart';

class CustomerController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  CustomerController() {
    _fetchCustomerList();
  }
  //DECLARACION DE VARIABLES
  CustomerRepository repository = CustomerRepository();
  int customerListLength = 0;
  List<CustomerModel> customers = []; // Lista de servicios
  List<CustomerModel> selectCustomer = [];
  bool isLoading = true;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
      update();
    });
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

  Future<void> _fetchCustomerList() async {
    customers = await repository.getcustomersList();
    customerListLength = customers.length;
    update();
  }
}
