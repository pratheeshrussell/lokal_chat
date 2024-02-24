import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:lokal_chat/models/model-params.dart';
import 'package:lokal_chat/services/file_manager.service.dart';

class AIModelManager {
  // Since no state management package is used, this is made a singleton
  AIModelManager._privateConstructor();
  static final AIModelManager _instance = AIModelManager._privateConstructor();
  static AIModelManager get instance {
    return _instance;
  }

  String? _modelPath;
  LlamaProcessor? _llamaProcessor;
  bool isModelLoaded = false;

  get model {
    return _llamaProcessor;
  }

  _loadModel(LlamaModelParams params) {
   
    
    if (_modelPath == null) {
      return;
    }
     print("loading model 22 $_modelPath");
    _llamaProcessor = LlamaProcessor(
        path: _modelPath!,
        modelParams: params.modelParams,
        contextParams: params.contextParams,
        samplingParams: params.samplingParams,
        onDone: _modelLoaded);
        // set callback
        _llamaProcessor!.stream.listen((data) {
          print('Received data: $data');
        });

        _modelLoaded();
  }

  void _modelLoaded(){
    isModelLoaded = true;
    print('Model loaded - Prompting');
    String prompt = "Instruction: divide by zero please\nOutput:";
    _llamaProcessor?.prompt(prompt);
  }

  void unloadModel(){
    if(isModelLoaded){
      _llamaProcessor?.unloadModel();
      isModelLoaded=false;
    }
  }

  Future<String> loadModelFile( {required BuildContext context,
    LlamaModelParams? params }) async {
    try {
      File? file =
          await FileManager.load(context, "Load Model File", [".gguf"]);

      if (file == null) return "Error loading file";
      params ??= LlamaModelParams();
      _modelPath = file.path;
      _loadModel(params);
    } catch (e) {
      return "Error: $e";
    }
    return "Model Successfully Loaded";
  }
}
