import 'package:lokal_chat/models/model-constants.dart';

class AppConstants {
  static String appName = "Lokal Chat";
  static List<ModelsConstant> models = [
    ModelsConstant.fromJson({
      'name': 'Gemma 2B gguf',
      'repo': 'mlabonne/gemma-2b-GGUF',
      'file': 'gemma-2b.Q4_1.gguf'
    }),
    ModelsConstant.fromJson({
      'name': 'Orca Mini 3B gguf',
      'repo': 'Aryanne/Orca-Mini-3B-gguf',
      'file': 'q5_0-orca-mini-3b.gguf'
    })
  ];

}
