import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Get.offAllNamed(
        '/loginNewPage',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Pulse(
            duration: const Duration(seconds: 2),
            child: const Image(
              image: AssetImage(
                'assets/images/ico.png',
              ),
              width: 90,
              height: 90,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceInRight(
                duration: const Duration(seconds: 4),
                delay: const Duration(seconds: 1),
                child: const Visibility(
                  visible: true,
                  child: Text(
                    'Simplifies',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              FadeIn(
                duration: const Duration(seconds: 2),
                delay: const Duration(seconds: 2),
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 241, 130, 84),
                )),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
