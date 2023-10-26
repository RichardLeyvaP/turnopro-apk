// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:get/get.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final LoginController loginController = Get.find<LoginController>();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: loginController.pagina == 'nothing' ||
                loginController.pagina == '/Professional'
            ? const Color.fromARGB(255, 241, 130, 84)
            : const Color.fromARGB(255, 26, 50, 82),

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
                  Icons.qr_code_scanner_sharp,
                  size: 50,
                ),
                Text(
                  'Simplifies',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 43, 44, 49),
                fixedColor: const Color.fromARGB(255, 241, 130, 84),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: InkWell(
                        onTap: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return snapshot.data == true
                                ? Icon(
                                    Icons.flashlight_on,
                                    color:
                                        const Color.fromARGB(255, 241, 130, 84),
                                    size:
                                        MediaQuery.of(context).size.width * 0.1,
                                  )
                                : Icon(
                                    Icons.flashlight_off_sharp,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width *
                                        0.07,
                                  );
                          },
                        ),
                      ),
                      label: 'linterna'),
                  BottomNavigationBarItem(
                      icon: InkWell(
                        child: Icon(
                          MdiIcons.cameraIris,
                          size: MediaQuery.of(context).size.width * 0.14,
                        ),
                      ),
                      label: 'Escanear'),
                  BottomNavigationBarItem(
                    icon: InkWell(
                      onTap: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          return snapshot.data != null
                              ? describeEnum(snapshot.data!) == 'front'
                                  ? Icon(
                                      MdiIcons.orbitVariant,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width *
                                          0.08,
                                    )
                                  : Icon(
                                      MdiIcons.orbitVariant,
                                      color: const Color.fromARGB(
                                          255, 241, 130, 84),
                                      size: MediaQuery.of(context).size.width *
                                          0.1,
                                    )
                              : const Text('loading');
                        },
                      ),
                    ),
                    label: 'Rotar camara',
                  ),
                ])),
      ),
      backgroundColor: loginController.pagina == 'nothing' ||
              loginController.pagina == '/Professional'
          ? const Color.fromARGB(255, 241, 130, 84)
          : const Color.fromARGB(255, 26, 50, 82),
      body: Column(
        children: <Widget>[
          Expanded(flex: 8, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Resultado : ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 6, right: 6, top: 2, bottom: 3),
                      child: Text('Esperando resultado...',
                          style: TextStyle(
                            fontSize: 2,
                            fontWeight: FontWeight.w800,
                            color: loginController.pagina == 'nothing' ||
                                    loginController.pagina == '/Professional'
                                ? Colors.black
                                : Colors.white,
                          )),
                    ),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //children: <Widget>[
                  // Container(
                  //   margin: const EdgeInsets.all(8),
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         await controller?.toggleFlash();
                  //         setState(() {});
                  //       },
                  //       child: FutureBuilder(
                  //         future: controller?.getFlashStatus(),
                  //         builder: (context, snapshot) {
                  //           return Text('Flash: ${snapshot.data}');
                  //         },
                  //       )),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.all(3),
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         await controller?.flipCamera();
                  //         setState(() {});
                  //       },
                  //       child: FutureBuilder(
                  //         future: controller?.getCameraInfo(),
                  //         builder: (context, snapshot) {
                  //           if (snapshot.data != null) {
                  //             return Text(
                  //                 'Cámara ${describeEnum(snapshot.data!)}');
                  //           } else {
                  //             return const Text('loading');
                  //           }
                  //         },
                  //       )),
                  // )
                  // ],
                  //),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(3),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //         },
                  //         child: const Text('Pause',
                  //             style: TextStyle(fontSize: 15)),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(3),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //         child: const Text('Reanudar',
                  //             style: TextStyle(fontSize: 15)),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Get.offNamedUntil('/Professional', (route) => route.isFirst);
                  //   },
                  //   child: const Text('Atras'),
                  // ),
                  // const Icon(Icons.arrow_back),
                  // const Text('Atrás'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
