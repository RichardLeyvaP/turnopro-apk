// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopro_apk/app_initializer.dart';
import 'package:turnopro_apk/dependency_injection.dart';
import 'package:turnopro_apk/myApp.dart';
import 'package:turnopro_apk/providers.dart';

void main() async {
  DependencyInjection.registerDependencies();
  await AppInitializer.initializeApp();
  runApp(
    MultiProvider(
      providers:
          providers, //esto es para la autenticacion por la huella dactilar
      child: Myapp(),
    ),
  );
}
