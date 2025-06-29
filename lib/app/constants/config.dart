import 'package:lokal_chat/app/types/model.types.dart';

Map<String, DefaultModelDetails> llmModels = {
  "smollm2-360m":(
    modelName: "smollm2-360m-instruct-q8_0.gguf",
    url: "https://huggingface.co/HuggingFaceTB/SmolLM2-360M-Instruct-GGUF/resolve/main/smollm2-360m-instruct-q8_0.gguf",
    features: ["chat"]
  ),
  "gemma-3-1b":(
    modelName: "gemma-3-1b-it-Q4_K_M.gguf",
    url: "https://huggingface.co/Cactus-Compute/Gemma3-1B-Instruct-GGUF/resolve/main/gemma-3-1b-it-Q4_K_M.gguf",
    features: ["chat"]
  ),
  "Phi-3-3.8b":(
    modelName: "Phi-3-mini-4k-instruct-q4.gguf",
    url: "https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf",
    features: ["chat"]
  )

};
