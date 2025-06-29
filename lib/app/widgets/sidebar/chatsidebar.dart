import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/widgets/sidebar/chatsidebarheader.dart';

import 'chatList.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  void gotoRoute(String route) {
    Get.back();
    Get.offNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ChatSidebarHeader(),

          ChatList()
          
        ],
      ),
    );
  }
}