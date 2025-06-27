class InitializeModelCommand {
  final String modelPath;
  final int contextSize;
  final int threads;

  InitializeModelCommand({
    required this.modelPath,
    required this.contextSize,
    required this.threads,
  });
}

class CompletionCommand {
  final String requestId;
  final List<Map<String, dynamic>> messages;
  final List<String> stopSequences;
  final double temperature;
  final int topK;
  final double topP;
  final int threads;

  CompletionCommand({
    required this.requestId,
    required this.messages,
    required this.stopSequences,
    required this.temperature,
    required this.topK,
    required this.topP,
    required this.threads,
  });
}