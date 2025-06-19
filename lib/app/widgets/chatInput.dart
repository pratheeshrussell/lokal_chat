import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';

class ChatInput extends StatelessWidget {
  ChatInput({super.key});

  final ChatHandler modelHandler = Get.find<ChatHandler>();

  final TextEditingController chatInputController = TextEditingController();

  void sendMessage(){
    if(modelHandler.isChatLoading.value 
        || !modelHandler.isModelLoaded.value 
        || modelHandler.selectedModel == null){
                return;
    }
    if(chatInputController.text.isNotEmpty){
      debugPrint("Sending message: ${chatInputController.text}");
      modelHandler.chat(chatInputController.text);
      chatInputController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Obx(() => 
          Expanded(
            child: TextField(
              controller: chatInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your message...',
              ),
              onSubmitted: (value) {
                sendMessage();
              },
              minLines: 1,
              maxLines: 3,
              enabled: (!modelHandler.isChatLoading.value 
              && modelHandler.isModelLoaded.value 
              && modelHandler.selectedModel != null),
            ),
          )),
          const SizedBox(width: 8),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}