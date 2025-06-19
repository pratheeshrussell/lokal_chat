import 'dart:async';

import 'package:cactus/cactus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/types/db.types.dart';
import 'package:queue/queue.dart';

class ChatHandler extends GetxService {
  CactusContext? _cactusContext;
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>([]);
  DbHandler dbHandler = Get.find<DbHandler>();

  RxBool isChatLoading = false.obs;
  RxBool isModelLoaded = false.obs;

  ModelEntity? selectedModel;
  RxList<ModelEntity> models = RxList<ModelEntity>([]);

  Future<ChatHandler> init() async {
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
    _cactusContext?.free();
    await loadCactus();
    debugPrint("Selected Model: ${selectedModel?.modelFile}");
  }

  Future<void> loadCactus() async {
    if (selectedModel != null) {
      isModelLoaded.value = false;
      final params = CactusInitParams(
        modelPath: selectedModel!.localPath,
        contextSize: 2048,
        threads: 4,
      );

      _cactusContext = await CactusContext.init(params);
      isModelLoaded.value = true;
      debugPrint("Model loaded");
    }
  }

  final tokenQueue = Queue(delay: Duration(milliseconds: 10));

  Future<void> sendResponse(String currentresp) async {
    await Future.delayed(Duration.zero);
    debugPrint("CHATVIEW: Sending response: $currentresp");
    chatMessages.removeLast();
    chatMessages.add(ChatMessage(role: 'assistant', content: currentresp));
    chatMessages.refresh();
  }

  Future<void> chat(String message) async {
    if (_cactusContext == null) {
      chatMessages.add(
        ChatMessage(
          role: 'system',
          content: 'Error: CactusContext not initialized.',
        ),
      );
      return;
    }

    final userMessage = ChatMessage(role: 'user', content: message);

    chatMessages.add(userMessage);
    await Future.delayed(Duration.zero);
    // add a dummy message for assistant as well
    chatMessages.add(ChatMessage(role: 'assistant', content: ''));
    await Future.delayed(Duration(milliseconds: 50));

    String currentAssistantResponse = "";
    List<String> stopSeq = ['<|im_end|>', '<end_of_utterance>'];
    try {
      isChatLoading.value = true;

      final completionParams = CactusCompletionParams(
        messages: chatMessages,
        stopSequences: stopSeq,
        temperature: 0.7,
        topK: 10,
        topP: 0.9,
        threads: 4,
        onNewToken: (String token) {
          if (!isChatLoading.value) return false;

          if (stopSeq.contains(token)) return false;

          if (token.isNotEmpty) {
            currentAssistantResponse += token;

            if (chatMessages.isNotEmpty &&
                chatMessages.last.role == 'assistant') {
              final responseSnapshot = currentAssistantResponse.toString();
              tokenQueue.add(() => sendResponse(responseSnapshot));
              
            }

            debugPrint("Assistant Stream Response: $token");
          }
          return true;
        },
      );

      _cactusContext!
          .completionSmart(completionParams)
          .then((value) {
            debugPrint("Assistant Final Response: ${value.text}");
          })
          .whenComplete(() {
            isChatLoading.value = false;
          });
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

  @override
  void onClose() {
    _cactusContext?.free();
    tokenQueue.dispose();
    super.onClose();
  }
}
