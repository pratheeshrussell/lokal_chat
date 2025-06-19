import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    debugPrint("HomeController initialized");
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint("HomeController ready");
    super.onReady();
  }

  @override
  void onClose() {
    debugPrint("HomeController closed");
    super.onClose();
  }

  void increment() => count.value++;
}
