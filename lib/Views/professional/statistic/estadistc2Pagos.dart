import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:turnopro_apk/Views/professional/statistic/product_list_page.dart';
import 'package:turnopro_apk/get_connect/repository/paymentRequests.repository.dart';
import 'package:turnopro_apk/get_connect/repository/productProfessional.repository.dart';

import '../../../Models/productRequest_model.dart';
import '../../../Models/request_model.dart';
import 'package:intl/intl.dart';

class Estadistc2Pagos extends StatefulWidget {
  const Estadistc2Pagos({super.key});

  @override
  State<Estadistc2Pagos> createState() => _Estadistc2PagosState();
}

class _Estadistc2PagosState extends State<Estadistc2Pagos> with SingleTickerProviderStateMixin {
  int totalNet = 0;
  int professionalEarnings = 0;
  int availableCash = 0;
  int totalProduct =0;
  int solicitado =0;
  int totalProductPrev =0;

  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.currencyUsd;
  final colorIcon = const Color(0xFF4470F3);

  int maxAdelanto = 0;
  static const int disponible = 335000;

  String title = 'Solicitudes y Pagos';
  String subTitle = 'Adelantos y Productos';

  late PaymentRequestsRepository paymentRequestsRepository;
  late ProductProfessionalRepository productProfessionalRepository;

  List<RequestModel> requests = [];
  List<ProductRequestModel> productRequests = [];
  bool isLoadingProducts = true;

  late TabController _tabController;
  bool isLoading = true;

  // Control para animar lista
  final GlobalKey<AnimatedListState> _listKeyRequests = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKeyProducts = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    paymentRequestsRepository = PaymentRequestsRepository();
    productProfessionalRepository = ProductProfessionalRepository();

    fetchRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30,10,10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(IconnsBack, color: const Color.fromARGB(200, 0, 0, 0)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colorIcon.withOpacity(0.2),
                          child: Icon(IconnsP, color: colorIcon),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                              Text(subTitle, style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B7EFF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () => _showSolicitarAdelantoModal(context),
                            child: const Text('ADELANTO', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C853),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListPage(
                                    repository: productProfessionalRepository, // reemplaza con tu URL real
                                  ),
                                ),
                              );
                            },
                            child: const Text('PRODUCTOS', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2, // 👉 siempre 2 cards por fila
                      shrinkWrap: true, // necesario para que no ocupe scroll infinito
                      physics: const NeverScrollableScrollPhysics(), // evita conflicto de scroll
                      crossAxisSpacing: 8, // espacio horizontal
                      mainAxisSpacing: 8,  // espacio vertical
                      childAspectRatio: 2, // relación ancho/alto (ajusta según tu diseño)
                      children: [
                        _SummaryCard(
                          title: 'Pendiente de Pago',
                          value: NumberFormat.currency(locale: 'es_CL', symbol: '', decimalDigits: 0).format(totalNet),
                          color: Colors.orange.shade600,
                        ),
                        _SummaryCard(
                          title: 'Pagado en el mes',
                          value: NumberFormat.currency(locale: 'es_CL', symbol: '', decimalDigits: 0).format(professionalEarnings),
                          color: Colors.green.shade600,
                        ),
                        _SummaryCard(
                          title: 'Gasto mes actual',
                          value: NumberFormat.currency(locale: 'es_CL', symbol: '', decimalDigits: 0).format(totalProduct),
                          color: Colors.red.shade600,
                        ),
                        _SummaryCard(
                          title: 'Gasto mes anterior',
                          value: NumberFormat.currency(locale: 'es_CL', symbol: '', decimalDigits: 0).format(totalProductPrev),
                          color: Colors.red.shade600,
                        ),
                      ],
                    ),


                    const SizedBox(height: 12),

          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
                            labelColor: Colors.black,
                            indicatorColor: Colors.blue,
                            tabs: const [
                              Tab(text: 'Solicitud de Adelantos'),
                              Tab(text: 'Solicitud de Productos'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 400, // ajusta este valor si tus listas son más grandes
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                RequestsTab(
                                  requests: requests, // ✅ nombre actualizado
                                  listKeyRequests: _listKeyRequests,
                                ),
                                ProductsTab(
                                  products: productRequests,
                                  listKeyProducts: _listKeyProducts,
                                ),
                              ],
                            ),  ),
                        ],
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchRequests() async {
    try {
      setState(() {
        isLoading = true;
        requests.clear();
        productRequests.clear();
        solicitado = 0;
      });

      final result = await paymentRequestsRepository.getCombinedRequests(
        startDate: "2025-05-05",
        endDate: "2025-06-30",
      );


      // Animar la lista de requests
      int totalPendienteTemp = 0; // variable temporal para acumular

      Future ft = Future(() {});
      for (int i = 0; i < result.requests.length; i++) {
        final req = result.requests[i];

        // Acumular si está pendiente
        if (req.status == "Pendiente") {
          totalPendienteTemp += req.amount ?? 0;
        }

        // Animación de la inserción
        ft = ft.then((_) {
          requests.add(req);
          _listKeyRequests.currentState?.insertItem(requests.length - 1);
          return Future.delayed(const Duration(milliseconds: 100));
        });
      }

// Cuando termine la animación, guardamos el total en el estado
      ft.then((_) {
        setState(() {
          solicitado = totalPendienteTemp;
        });
      });


      // Animar la lista de productRequests
      Future fut = Future(() {});
      for (int i = 0; i < result.productRequests.length; i++) {
        fut = fut.then((_) {
          productRequests.add(result.productRequests[i]);
          _listKeyProducts.currentState?.insertItem(productRequests.length - 1);
          return Future.delayed(const Duration(milliseconds: 100));
        });
      }

      // Esperar ambas animaciones antes de actualizar los totales y el estado
      await Future.wait([ft, fut]);

      setState(() {
        totalNet = result.totalNeto - solicitado;
        availableCash = result.availableCash;
        professionalEarnings = result.professionalEarnings;
        totalProduct=result.totals.totalProduct;
        totalProductPrev=result.totals.totalProductPrev;
        print("Toltales: $result.totals");
        maxAdelanto = totalNet < 0 ? 0 : totalNet;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error al obtener solicitudes combinadas: $e");
    }
  }

  Future<void> solicitarAdelanto({
    required int amount,
  }) async {
    try {
      final response = await paymentRequestsRepository.createAdvanceRequest(
        amount: amount,
      );

      print("Respuesta del Servidor: $response");
      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitud por \$${amount.toString()} enviada con éxito')),
        );
        fetchRequests(); // Actualiza la lista de solicitudes
      } else {
      //  throw Exception("Solo se permite un adelanto por quincena.");
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Solo se permite un adelanto por quincena.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al solicitar adelanto: $e')),
      );
    }
  }

  void _showSolicitarAdelantoModal(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    String? error;

    final bool isAdelantoDisponible = maxAdelanto > 0;

    String formatNumber(String s) {
      s = s.replaceAll('.', '');
      return s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    }

    _controller.addListener(() {
      final text = _controller.text.replaceAll('.', '');
      if (text.isEmpty) return;
      final newText = formatNumber(text);
      if (_controller.text != newText) {
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Solicitud de Adelanto',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 26),
                  const Align(alignment: Alignment.centerLeft, child: Text('Valor a solicitar:')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    enabled: isAdelantoDisponible,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      errorText: error,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Disponible en caja: ${formatNumber(availableCash.toString())}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                  if (!isAdelantoDisponible)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'No tienes disponible para solicitar adelanto',
                        style: TextStyle(color: Colors.red[700], fontSize: 13),
                      ),
                    ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: error == null
                              ? () {
                            final rawText = _controller.text.replaceAll('.', '');
                            if (rawText.isEmpty) {
                              setState(() => error = 'Ingresa un monto');
                              return;
                            }
                            final value = int.tryParse(rawText) ?? 0;
                            if (value <= 0) {
                              setState(() => error = 'Ingresa un monto válido');
                              return;
                            }
                           if (value > maxAdelanto) {
                              setState(() => error = 'No puedes solicitar más que el máximo disponible');
                              return;
                            }
                            setState(() => error = null);
                            solicitarAdelanto(amount: value);
                            Navigator.pop(context);
                          }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey.shade400; // color cuando está deshabilitado
                                }
                                return const Color(0xFF5B7EFF); // color normal
                              },
                            ),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          child: const Text('Solicitar Adelanto'),
                        )


                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}




class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // tamaño fijo del título
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 0),
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // 👈 tamaño fijo del número
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pendiente':
      return Colors.orange;
    case 'aprobado':
      return Colors.green;
    case 'rechazado':
      return Colors.red;
    case 'pagado':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}


class _RequestCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String date;
  final String time;
  final String name;
  final String amount;

  const _RequestCard({
    required this.status,
    required this.statusColor,
    required this.date,
    required this.time,
    required this.name,
    required this.amount,

  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'aprobado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      case 'pagado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(status);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Solicitud de Adelanto', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Fecha : $date'),
            Text('Hora  : $time'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(name)),
                Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsTab extends StatefulWidget {
  final List<ProductRequestModel> products;
  final GlobalKey<AnimatedListState> listKeyProducts;

  const ProductsTab({
    Key? key,
    required this.products,
    required this.listKeyProducts,
  }) : super(key: key);

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedList(
      key: widget.listKeyProducts,
      initialItemCount: widget.products.length,
      itemBuilder: (context, index, animation) {
        final product = widget.products[index];
        return SizeTransition(
          sizeFactor: animation,
          child: _ProductCard(
            name: product.productName,
            quantity: product.quantity,
            date: product.data,
            status: product.status,
            time: product.time,
            imageUrl: product.imageURL,
          ),
        );
      },
    );
  }
}



class RequestsTab extends StatefulWidget {
  final List<RequestModel> requests;
  final GlobalKey<AnimatedListState> listKeyRequests;

  const RequestsTab({
    Key? key,
    required this.requests,
    required this.listKeyRequests,
  }) : super(key: key);

  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedList(
      key: widget.listKeyRequests,
      initialItemCount: widget.requests.length,
      itemBuilder: (context, index, animation) {
        final req = widget.requests[index];
        return SizeTransition(
          sizeFactor: animation,
          child: _RequestCard(
            status: req.status,
            statusColor: _getStatusColor(req.status),
            date: req.date,
            time: req.time,
            name: req.name,
            amount: req.amount.toString(),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final int quantity;
  final String date;
  final String status;
  final String time;
  final String imageUrl; // ← Agregado

  const _ProductCard({
    required this.name,
    required this.quantity,
    required this.date,
    required this.status,
    required this.time,
    required this.imageUrl, // ← Agregado
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pendiente':
        statusColor = Colors.orange;
        break;
      case 'aprobado':
        statusColor = Colors.green;
        break;
      case 'rechazado':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Avatar con imagen
            Image.network(
              '${dotenv.env['API_ENDPOINT']}/images/${this.imageUrl}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),

            // Info del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Fecha: $date'),
                  Text('Hora: $time'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
