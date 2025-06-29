import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/types/db.types.dart';

class ChatTile extends StatelessWidget {
  final ChatEntity chat;
  final DbHandler dbHandler = Get.find<DbHandler>();
  ChatTile({required this.chat, super.key});

  RxBool editMode = false.obs;
  TextEditingController textControl = TextEditingController();

  Widget chatText() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              selectChat();
            },
            child: Text(
              chat.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(value: 'edit', child: Text('Rename')),
            PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (val) {
            if (val == 'edit') {
              editMode.value = true;
            } else if (val == 'delete') {
              deleteChat();
            }
          },
        ),
      ],
    );
  }

  Widget chatEditText() {
    textControl = TextEditingController(text: chat.title);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Please enter a title',
              border: UnderlineInputBorder(),
            ),
            controller: textControl,
            maxLength: 20,
          ),
        ),
        IconButton(
          onPressed: () {
            editChatTitle();
          },
          padding: EdgeInsets.symmetric(horizontal: 1),
          icon: const Icon(Icons.check),
        ),

        IconButton(
          onPressed: () {
            editMode.value = false;
          },
          padding: EdgeInsets.symmetric(horizontal: 1),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Future<void> editChatTitle() async {
    if (textControl.text.isNotEmpty) {
      await dbHandler.updateChatTitle(chat.id!, textControl.text);
    }
    debugPrint('update title ${textControl.text}');
    editMode.value = false;
  }

  Future<void> deleteChat() async {
    debugPrint('Delete chat called');
    await dbHandler.deleteChat(chat.id!);
  }

  void selectChat() {
    debugPrint('chat selected ${chat.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Obx(() {
        if (editMode.value) {
          return chatEditText();
        }
        return chatText();
      }),
    );
  }
}
