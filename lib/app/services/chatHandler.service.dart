import 'package:cactus/cactus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/types/db.types.dart';

class ChatHandler extends GetxService {
  CactusContext? _cactusContext;
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>([]);
  DbHandler dbHandler = Get.find<DbHandler>();

  RxBool isLoading = false.obs;
  RxBool isModelLoaded = false.obs;

  ModelEntity? selectedModel;
  RxList<ModelEntity> models = RxList<ModelEntity>([]);

  Future<ChatHandler> init() async {
    await initialize();
    return this;
  }
  Future<void> initialize() async {
    await loadAllModels();
    if(models.isNotEmpty){
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
    selectedModel = models.
      firstWhere((model) => model.isDefault,
      orElse: () => models.first);

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

  Future<String> demo(String message) async {
if (_cactusContext == null) {
      
      return 'CACTUS DEMO NOT INITIALIZED';
    }

    // FormatException: Missing extension byte
final result = await _cactusContext!.completion(
  CactusCompletionParams(
    messages: [
    ChatMessage(role: 'user', content: message),
    ],
    // stopSequences: ['<|end|>', '</s>'],
    //maxPredictedTokens: 100,
    temperature: 0.7,
    topK: 10,
    topP: 0.9,

    onNewToken: (token) {
         debugPrint("GEN Token: $token");
          return true; // Continue generation
        },
));

// _cactusContext!.free();
return result.text;


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

    String currentAssistantResponse = "";
    final userMessageContent = message;

    final userMessage = ChatMessage(role: 'user', content: userMessageContent);

    final List<ChatMessage> updatedMessages = List.from(chatMessages);
    updatedMessages.add(userMessage);

    updatedMessages.add(
      ChatMessage(role: 'assistant', content: currentAssistantResponse),
    );
    chatMessages.value = updatedMessages;

    try {
      List<ChatMessage> currentChatHistoryForCompletion = List.from(
        chatMessages,
      );
      if (currentChatHistoryForCompletion.isNotEmpty &&
          currentChatHistoryForCompletion.last.role == 'assistant' &&
          currentChatHistoryForCompletion.last.content.isEmpty) {
        currentChatHistoryForCompletion.removeLast();
      }

      final completionParams = CactusCompletionParams(
        messages: currentChatHistoryForCompletion,
        stopSequences: ['<|im_end|>', '<end_of_utterance>'],
        temperature: 0.7,
        topK: 10,
        topP: 0.9,
        onNewToken: (String token) {
          if (!isLoading.value) return false;

          if (token == '<|im_end|>') return false;

          if (token.isNotEmpty) {
            currentAssistantResponse += token;
            final List<ChatMessage> streamingMessages = List.from(chatMessages);
            if (streamingMessages.isNotEmpty &&
                streamingMessages.last.role == 'assistant') {
              streamingMessages[streamingMessages.length - 1] = ChatMessage(
                role: 'assistant',
                content: currentAssistantResponse,
              );
              chatMessages.value = streamingMessages;

              
            }
            
          }
          return true;
        },
      );

      final result = await _cactusContext!.completion(completionParams);
      String finalCleanText = result.text.trim();
debugPrint("init Clean Text: $finalCleanText");
      if (finalCleanText.isEmpty &&
          currentAssistantResponse.trim().isNotEmpty) {
        finalCleanText = currentAssistantResponse.trim();
      }

      debugPrint("Final Clean Text: $finalCleanText");

      final List<ChatMessage> finalMessages = List.from(chatMessages);
      if (finalMessages.isNotEmpty && finalMessages.last.role == 'assistant') {
        finalMessages[finalMessages.length - 1] = ChatMessage(
          role: 'assistant',
          content: finalCleanText.isNotEmpty
              ? finalCleanText
              : "(No further response)",
        );
        chatMessages.value = finalMessages;
      }
    } catch (e) {
      _addErrorMessageToChat(
        "An unexpected error occurred during completion: ${e.toString()}",
      );
      debugPrint("Generic Exception during completion: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
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
}
