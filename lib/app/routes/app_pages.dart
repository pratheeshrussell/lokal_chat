import 'package:get/get.dart';
import 'package:lokal_chat/app/modules/chat/bindings/chat_binding.dart';
import 'package:lokal_chat/app/modules/chat/views/chat_view.dart';
import 'package:lokal_chat/app/modules/model_manager/bindings/model_manager_binding.dart';
import 'package:lokal_chat/app/modules/model_manager/views/model_manager_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.MODEL_MANAGER,
      page: () => const ModelManagerView(),
      binding: ModelManagerBinding(),
    ),
  ];
}
