import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/config.dart';
import 'package:lokal_chat/app/modules/model_manager/controllers/model_manager_controller.dart';
import 'package:lokal_chat/app/types/model.types.dart';
import 'package:lokal_chat/app/modules/model_manager/widgets/model_suggest_tile.dart';


class ModelSuggestView extends GetView<ModelManagerController> {
  const ModelSuggestView({super.key});

 
 List<Widget> modelSuggestionList(){
  List<Widget> modelList = [];
  for (MapEntry<String, DefaultModelDetails> model in llmModels.entries) {
    modelList.add(
      ModelSuggestTile(model)
    );
  }
  
  return modelList;
}



  @override
  Widget build(BuildContext context) {
    return  Column(
          children: [
            const Text("Hugging Face models"),
            ...modelSuggestionList()
          ],
      );
  }
}
