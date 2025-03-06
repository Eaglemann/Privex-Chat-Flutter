import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:privex/models/user_profile.dart';
import 'package:privex/pages/chat_page.dart';
import 'package:privex/services/alert_services.dart';
import 'package:privex/services/auth_service.dart';
import 'package:privex/services/database_services.dart';
import 'package:privex/services/navigation_services.dart';
import 'package:privex/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late NavigationalServices _navigationServices;
  late AuthService _authService;
  late AlertServices _alertServices;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _navigationServices = _getIt.get<NavigationalServices>();
    _authService = _getIt.get<AuthService>();
    _alertServices = _getIt.get<AlertServices>();
    _databaseService = _getIt.get<DatabaseService>();
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
                _alertServices.showToast(
                  text: "Logged out successfully",
                  icon: Icons.check,
                );
                _navigationServices.pushReplacementNamed("/login");
              }
            },
            color: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: _chatLists(),
      ),
    );
  }

  Widget _chatLists() {
    return StreamBuilder(
      stream: _databaseService.getUserPRofiles(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Unable to load data!"));
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ChatTile(
                  userProfile: user,
                  onTap: () async {
                    final checkExists = await _databaseService.checkChatExists(
                      _authService.user!.uid,
                      user.uid!,
                    );

                    if (!checkExists) {
                      await _databaseService.createNewChat(
                        _authService.user!.uid,
                        user.uid!,
                      );
                    }
                    _navigationServices.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(chatUser: user);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
