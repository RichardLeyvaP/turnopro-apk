// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:get/get.dart';

class ContainerData {
  final String titleService;
  final String descriptionService;
  final int price;
  final int time;
  final RxBool selectedProductDelete;

  ContainerData(
    this.titleService,
    this.descriptionService,
    this.price,
    this.time,
    bool selectedProductDelete,
  ) : selectedProductDelete = selectedProductDelete.obs;
}

// ignore: camel_case_types
class servicesBodyController extends GetxController {
  final RxList<ContainerData> containerDataList = [
    ContainerData('Lavado de Cabello', 'Lavado Profundo', 2, 55, false),
    ContainerData('Corte de Pelo', 'Estilo Moderno', 10, 45, false),
    ContainerData('Lavado de Cabello', 'Lavado Profundo', 2, 30, false),
    ContainerData('Corte de Pelo', 'Estilo Moderno', 2, 45, false),
    ContainerData('Corte de Pelo', 'Estilo Moderno', 2, 45, false),
    ContainerData('Corte de Pelo', 'Estilo Moderno', 2, 45, false),
  ].obs;
  // Define containerDataList como un observable

  double getTotalSum() {
    return containerDataList
        .map((data) => data.price)
        .fold(0, (sum, price) => sum + price)
        .toDouble();
  }

  /*
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
  */

  @override
  void onClose() {
    //print('Estoy Cerrando Todo');
    super.onClose();
  }
}
