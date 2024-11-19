import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';

class DynamicYearButtons extends StatefulWidget {
  const DynamicYearButtons({Key? key}) : super(key: key);

  @override
  _DynamicYearButtonsState createState() => _DynamicYearButtonsState();
}

class _DynamicYearButtonsState extends State<DynamicYearButtons> {
  final int startYear = 2024; // Año base desde el cual empezamos
  int? selectedYear; // Año seleccionado
  final CoexistenceController cControll = Get.find<CoexistenceController>();
  @override
  Widget build(BuildContext context) {
    // Obtener el año actual
    //final int currentYear = 2028;
    final int currentYear = DateTime.now().year;

    // Generar una lista de años desde el año base hasta el año actual
    final List<int> years = List.generate(currentYear - startYear + 1, (index) => startYear + index);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: years.map((year) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: selectedYear == year
                      ? Colors.green // Color verde si está seleccionado
                      : const Color(0xFF4470F3), // Color azul predeterminado
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  // Actualizar el año seleccionado
                  setState(() {
                    selectedYear = year;
                  });

                  // Mostrar diálogo de carga
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFDAE2A),
                      ),
                    ),
                    barrierDismissible: false,
                  );

                  // Llamar la función de cargar estadísticas
                  await cControll.getStadistAno(year);
                  print("Cargando estadísticas del año $year");
                },
                child: Center(
                  child: Text(
                    year.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
