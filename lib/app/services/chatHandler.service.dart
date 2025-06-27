import 'dart:async';

import 'package:cactus/cactus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/isolates/chat.isolate.dart';

import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/types/chatIsolate.types.dart';
import 'package:lokal_chat/app/types/db.types.dart';

class ChatHandler extends GetxService {
  
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>([]);
  DbHandler dbHandler = Get.find<DbHandler>();

  RxBool isChatLoading = false.obs;
  RxBool isModelLoaded = false.obs;

  ModelEntity? selectedModel;
  RxList<ModelEntity> models = RxList<ModelEntity>([]);

  // ChatIsolate
  ChatIsolate chatIsolate = ChatIsolate();

  Future<ChatHandler> init() async {
    await chatIsolate.startWorkerIsolate(_handleIsolateResponse);
    await initialize();
    return this;
  }

  Future<void> initialize() async {
    await loadAllModels();
    if (models.isNotEmpty) {
      await setDefaultModel();
      await loadCactus();
    }
  }

  Future<void> loadAllModels() async {
    List<Map<String, Object?>> dbmodels = await dbHandler.db.query('models');
    for (var model in dbmodels) {
      ModelEntity modelEntity = ModelEntity.fromMap(model);
      models.add(modelEntity);
    }
  }

  Future<void> setDefaultModel() async {
    selectedModel = models.firstWhere(
      (model) => model.isDefault,
      orElse: () => models.first,
    );

    debugPrint("Selected Model: ${selectedModel?.modelFile}");
  }

  Future<void> setActiveModel(ModelEntity model) async {
    selectedModel = model;
    await loadCactus();
    debugPrint("Selected Model: ${selectedModel?.modelFile}");
  }

  Future<void> loadCactus() async {
    if (selectedModel != null) {
      isModelLoaded.value = false;
      // model handling to be done in isolate
      chatIsolate.workerSendPort?.send(InitializeModelCommand(
        modelPath: selectedModel!.localPath,
        contextSize: 2048,
        threads: 4,
      ));
    }
  }

  Future<void> sendResponse(String currentresp) async {
    // await Future.delayed(Duration.zero);
    debugPrint("CHATVIEW: Sending response: $currentresp");
    chatMessages.removeLast();
    chatMessages.add(ChatMessage(role: 'assistant', content: currentresp));
    chatMessages.refresh();
  }
  String currentAssistantResponse = "";
  Future<void> chat(String message) async {
    final userMessage = ChatMessage(role: 'user', content: message);

    chatMessages.add(userMessage);
    await Future.delayed(Duration.zero);
    // add a dummy message for assistant as well
    chatMessages.add(ChatMessage(role: 'assistant', content: ''));
    await Future.delayed(Duration(milliseconds: 50));

    
    List<String> stopSeq = ['</s>', '<end_of_utterance>'];
    try {
      isChatLoading.value = true;

      List<Map<String, dynamic>> messagesHistory = chatMessages.map((message){
        return {
          'role': message.role,
          'content': message.content,
        };
      }).toList();
      currentAssistantResponse = "";

      chatIsolate.workerSendPort?.send(CompletionCommand(
        requestId: DateTime.now().millisecondsSinceEpoch.toString(),
        messages: messagesHistory,
        stopSequences: stopSeq,
        temperature: 0.7,
        topK: 10,
        topP: 0.9,
        threads: 4,
      ));


    } catch (e) {
      isChatLoading.value = false;
      _addErrorMessageToChat(
        "An unexpected error occurred during completion: ${e.toString()}",
      );
      debugPrint("Generic Exception during completion: ${e.toString()}");
    } finally {}
  }

  void _addErrorMessageToChat(String errorMessage) {
    final List<ChatMessage> errorMessages = List.from(chatMessages);
    if (errorMessages.isNotEmpty && errorMessages.last.role == 'assistant') {
      errorMessages[errorMessages.length - 1] = ChatMessage(
        role: 'assistant',
        content: errorMessage,
      );
    } else {
      errorMessages.add(ChatMessage(role: 'system', content: errorMessage));
    }
    chatMessages.value = errorMessages;
  }

  void handleNewToken(String token){
    if (token.isNotEmpty) {
      currentAssistantResponse += token;

      if (chatMessages.isNotEmpty &&
        chatMessages.last.role == 'assistant') {
        final responseSnapshot = currentAssistantResponse.toString();
        sendResponse(responseSnapshot);
      }

      debugPrint("Assistant Stream Response: $token");
    }
  }


  void _handleIsolateResponse(Map<String, dynamic> response) {
    
    final type = response['type'];
    // final requestId = response['requestId'];

    switch (type) {
      case 'isolate_ready':
        debugPrint("Isolate ready");
        break;
      case 'model_ready':
        isModelLoaded.value = true;
        debugPrint("Model loaded");
        break;
      case 'token':
        // Handle token updates
        handleNewToken(response['token']);
        break;
      case 'completion':
        // Handle chat completion
        isChatLoading.value = false;
        break;
      case 'error':
        // Handle errors
        isChatLoading.value = false;
        break;
    }
  }

  @override
  void onClose() {
    chatIsolate.dispose();
    super.onClose();
  }
}
