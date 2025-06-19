import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/paths.dart';
import 'package:lokal_chat/app/modules/model_manager/controllers/model_manager_controller.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';
import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/services/modelHandler.service.dart';
import 'package:lokal_chat/app/types/model.types.dart';

//ignore: must_be_immutable
class ModelSuggestTile extends GetView<ModelManagerController> {
  final MapEntry<String, DefaultModelDetails> model;
  ModelSuggestTile(this.model, {super.key});

  final ModelHandler modelHandler = Get.find<ModelHandler>();
  final ChatHandler chatHandler = Get.find<ChatHandler>();
  DbHandler dbHandler = Get.find<DbHandler>();
  RxBool downloading = false.obs;
  RxBool downloaded = false.obs;

  void initialize() {  
    // check if model is already downloaded  
    dbHandler.db.query('models', 
      where: 'model_file = ?', 
      whereArgs: [model.value.modelName]).then((value) {
      if(value.isNotEmpty){
        downloaded.value = true;
      }
    });

    // listen to download status
    modelHandler.downloadStatus.downloadComplete.listen((status) {
      if (status == true) {
        downloaded.value = true;
        downloading.value = false;
        addDBEntry();
      }
    });
  }

  Widget modelDetails() {
    return ListTile(
      title: Text(model.key),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.value.modelName),
          const SizedBox(height: 5),
          Row(
            children: [
              ...model.value.features.map((feature) {
                return Chip(
                  label: Text(feature, style: const TextStyle(fontSize: 10)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 0,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }),
            ],
          ),
        ],
      ),
      trailing: (downloaded.value)
          ? const Icon(Icons.check)
          : (downloading.value)
          ? SizedBox(
          height: 10, width: 10)
          : IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                downloadModel();
              },
            ),
    );
  }

  void downloadModel() {
    downloading.value = true;
    modelHandler.downloadFileIfNeeded(model.value.url);
  }

  Future<void> addDBEntry() async {
    String modelName = model.value.url.split('/').last;
    String filePath = await AppPaths.modelsPath;
    debugPrint("Adding model to db");
    await dbHandler.db.insert(
      'models',
      {
        'name': model.value.modelName,
        'model_file': model.value.modelName,
        'local_path': '$filePath/$modelName',
        'is_default': false
      },
    );

    await chatHandler.loadAllModels();
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: Column(
        children: [
          Obx(() => modelDetails()),

          Obx(() {
            if (!downloading.value) {
              return Container();
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Obx(
                () => Column(
                  children: [
                    LinearProgressIndicator(
                      value: modelHandler.downloadStatus.downloadProgress.value,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    Text(modelHandler.downloadStatus.statusMessage.value),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
