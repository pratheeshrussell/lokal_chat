import 'dart:async';

import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class LlamaModelParams {
  ModelParams modelParams = ModelParams();
  ContextParams contextParams = ContextParams();
  SamplingParams samplingParams = SamplingParams();
  void Function(String?) callback = (String? data) {};

  LlamaModelParams();
}