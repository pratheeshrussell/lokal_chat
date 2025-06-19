import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';
import 'package:lokal_chat/app/types/db.types.dart';

class ModelPicker extends StatelessWidget {
  ModelPicker({super.key});
  final ChatHandler modelHandler = Get.find<ChatHandler>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: modelHandler.models.map((model) {
            return DropdownMenuItem(
              value: model,
              child: SizedBox(
                width: Get.size.width * 0.4,
                child: Text(model.name, 
                overflow: TextOverflow.ellipsis,),
              )
              
            );
          }).toList(),
          value: modelHandler.selectedModel,
          onChanged: (ModelEntity? value) {  
            if(value != null){
              modelHandler.setActiveModel(value);
              debugPrint("Model selected: ${value.name}");
            }
          },
        ),
      )),
    );
  }
}