import 'package:flutter/material.dart';
import 'package:privex/const.dart';
import 'package:privex/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;

  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      onTap: () {
        onTap();
      },
      leading: CircleAvatar(backgroundImage: NetworkImage(PLACEHOLDER_PFP)),
      title: Text(userProfile.name!),
    );
  }
}
