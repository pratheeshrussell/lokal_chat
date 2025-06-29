import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/widgets/sidebar/chatTile.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  final DbHandler dbHandler = Get.find<DbHandler>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: Get.mediaQuery.size.height * 0.5,
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Obx(() {
            final chats = dbHandler.chatList;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              reverse: false,
              itemCount: chats.length,

              itemBuilder: (_, index) {
                return ChatTile(
                  chat: chats[index],
                );
              },
            );
          }),
        ),
      ],
    ));
  }
}
