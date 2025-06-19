import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lokal_chat/app/modules/model_manager/controllers/model_manager_controller.dart';
import './model_suggest.dart';


class ModelAddView extends GetView<ModelManagerController> {
  const ModelAddView({super.key});




  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
            children: [
              
              ModelSuggestView()
            ],
        ),
    );
  }
}
