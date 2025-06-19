import 'package:get/get.dart';
import 'package:lokal_chat/app/modules/model_manager/controllers/model_manager_controller.dart';

class ModelManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelManagerController>(
      () => ModelManagerController(),
    );
  }
}