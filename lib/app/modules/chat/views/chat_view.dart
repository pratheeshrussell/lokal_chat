import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/strings.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';
import 'package:lokal_chat/app/widgets/sidebar/chatsidebar.dart';

import '../controllers/chat_controller.dart';

// ignore: must_be_immutable
class ChatView extends GetView<ChatController> {
  ChatView({super.key});

  ChatHandler modelHandler = Get.find<ChatHandler>();

  RxString demoResponse = "".obs;
  void afterInit(){
    modelHandler.isModelLoaded.listen((isLoaded){
      debugPrint("CHATVIEW: Model loaded: $isLoaded");
      
    });

    
  }
  void callDemo(){
if(modelHandler.isModelLoaded.value){
      modelHandler.demo("Hello how are you").then((value) {
        debugPrint("CHATVIEW: Demo: $value");
        demoResponse.value = value;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    afterInit();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
      ),
      drawer: ChatDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
        child: Text(
          'Click demo to get response!',
          style: TextStyle(fontSize: 20),
        ),
      ),
      Obx(() => Text(demoResponse.value)),
      ElevatedButton(onPressed: (){
        callDemo();
      }, child: Text("Demo"))
        ],
      ),
       
    );
  }
}
