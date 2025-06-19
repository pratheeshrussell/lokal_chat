import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lokal_chat/app/constants/colors.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';
import 'package:lokal_chat/app/widgets/chatInput.dart';
import 'package:lokal_chat/app/widgets/modelPicker.dart';
import 'package:lokal_chat/app/widgets/sidebar/chatsidebar.dart';

import '../controllers/chat_controller.dart';

// ignore: must_be_immutable
class ChatView extends GetView<ChatController> {
  ChatView({super.key});

  ChatHandler modelHandler = Get.find<ChatHandler>();

  RxString demoResponse = "".obs;
  void afterInit() {
    // modelHandler.isModelLoaded.listen((isLoaded) {
    //   debugPrint("CHATVIEW: Model loaded: $isLoaded");
    // });

    modelHandler.chatMessages.listen((messages) {
      debugPrint("CHATVIEW: Messages update: $messages");
    });
  }

  @override
  Widget build(BuildContext context) {
    afterInit();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ModelPicker(),
        ),
        centerTitle: true,
      ),
      drawer: ChatDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() {
              final messages = modelHandler.chatMessages;

              return ListView.builder(
                padding: EdgeInsets.all(8),
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final message = messages[index];

                  if (message.role == 'assistant' && message.content == '') {
                    debugPrint("BUILDING TILE");

                    return SizedBox(
                      height: 100,
                      width: 100,
                      child: 
                      Center(
                      child: SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: AppColors.indicatorColors,
                        strokeWidth: 4,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: null,
                        pause: false,
                      )
                    )));
                  }
                  return ListTile(
                    // key: ValueKey(
                    //   message.content.length.toString()+index.toString()),
                    title: Text(message.content),
                    subtitle: Text(message.role),
                  );
                },
              );
            }),
          ),

          ChatInput(),
        ],
      ),
    );
  }
}
