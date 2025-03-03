// ignore: unused_import
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privex/utils.dart';
import 'package:privex/services/navigation_services.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late final NavigationalServices _navigationServices;

  MyApp({super.key}) {
    _navigationServices = _getIt<NavigationalServices>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationServices.navigatorKey,
      title: 'Privex Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: "/login",
      routes: _navigationServices.routes,
    );
  }
}
