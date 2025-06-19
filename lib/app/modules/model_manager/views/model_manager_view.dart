import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lokal_chat/app/modules/model_manager/widgets/model_add.dart';

import '../controllers/model_manager_controller.dart';

class ModelManagerView extends GetView<ModelManagerController> {
  const ModelManagerView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Model Manager'), centerTitle: true),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Add Model'),
                Tab(text: 'Manage Models'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child:ModelAddView()),
                  Center(child: Text('Manage model tab')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
