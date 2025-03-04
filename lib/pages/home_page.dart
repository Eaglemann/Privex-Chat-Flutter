import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:privex/services/auth_service.dart';
import 'package:privex/services/navigation_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late NavigationalServices _navigationServices;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _navigationServices = _getIt.get<NavigationalServices>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _navigationServices.pushReplacementNamed("/login");
              }
            },
            color: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
