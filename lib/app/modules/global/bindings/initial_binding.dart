import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/services/dbHandler.service.dart';
import 'package:lokal_chat/app/services/chatHandler.service.dart';
import 'package:lokal_chat/app/services/modelHandler.service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<DbHandler>(() => DbHandler().init(), permanent: true);
    debugPrint("DbHandler initialized");
    await Get.putAsync<ChatHandler>(() => ChatHandler().init(), permanent: true);
    debugPrint("chat Handler initialized");
    // NOTE TO SELF: This will create a new instance every time it is called
    Get.create<ModelHandler>(() => ModelHandler());
  }
}
