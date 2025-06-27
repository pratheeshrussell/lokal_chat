import 'dart:async';
import 'dart:isolate';

import 'package:cactus/cactus.dart';
import 'package:lokal_chat/app/types/chatIsolate.types.dart';

class ChatIsolate {
  Isolate? _workerIsolate;
  SendPort? workerSendPort;
  ReceivePort receivePort = ReceivePort();
  Completer<void> isolateReadyCompleter = Completer<void>();
  late Function(Map<String, dynamic> response)? callback;


  ChatIsolate(){
    receivePort.listen((message) {
      if (message is SendPort) {
        workerSendPort = message;
        _handleWorkerResponse({'type': 'isolate_ready'});
        isolateReadyCompleter.complete();
      } else if (message is Map<String, dynamic>) {
        // Handle responses from the worker
        _handleWorkerResponse(message);
      }
    });
  }
  Future<void> startWorkerIsolate(Function(Map<String, dynamic> response)? callback) async {
    this.callback = callback;
    _workerIsolate = await Isolate.spawn(_workerMain, receivePort.sendPort);
    return isolateReadyCompleter.future;
  }

  // if this is not set as a static method, it will throw error
  // because of Closure Capture of 'this'
  static void _workerMain(SendPort mainSendPort) {
    final workerReceivePort = ReceivePort();
    CactusContext? cactusContext;
    String? currentModelPath;

    mainSendPort.send(workerReceivePort.sendPort);

    workerReceivePort.listen((message) async {
      if (message is InitializeModelCommand) {
        // Initialize or reinitialize model
        if (cactusContext != null && currentModelPath != message.modelPath) {
          cactusContext?.free();
          cactusContext = null;
        }

        if (cactusContext == null) {
          final params = CactusInitParams(
            modelPath: message.modelPath,
            contextSize: message.contextSize,
            threads: message.threads,
          );
          cactusContext = await CactusContext.init(params);
          currentModelPath = message.modelPath;
          mainSendPort.send({'type': 'model_ready'});
        }
      } else if (message is CompletionCommand) {
        // Handle chat completion

        if (cactusContext == null) {
          mainSendPort.send({'type': 'error', 'error': 'CactusContext not initialized'});
          return;
        }
        final stopSequences = message.stopSequences;

        final completionParams = CactusCompletionParams(
          messages: message.messages
              .map((m){
                ChatMessage chatMessage = ChatMessage(
                  content: m['content'], role: m['role']);
                return chatMessage;
              })
              .toList(),
          stopSequences: stopSequences,
          temperature: message.temperature,
          topK: message.topK,
          topP: message.topP,
          threads: message.threads,
          onNewToken: (String token) {
            if (!stopSequences.contains(token)) {
              mainSendPort.send({
                'type': 'token',
                'token': token,
                'requestId': message.requestId,
              });
              return true;
            }
            return false;
          },
        );

        try {
          final result = await cactusContext!.completionSmart(completionParams);
          mainSendPort.send({
            'type': 'completion',
            'text': result.text,
            'requestId': message.requestId,
          });
        } catch (e) {
          mainSendPort.send({
            'type': 'error',
            'error': e.toString(),
            'requestId': message.requestId,
          });
        }
      }
    });
  }

  void _handleWorkerResponse(Map<String, dynamic> response) {
    // handling this in chat Handler
    callback?.call(response);
  }

  void dispose(){
    _workerIsolate?.kill();
  }
}
