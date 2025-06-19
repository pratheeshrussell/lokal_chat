import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModelManagerController extends GetxController {
  final inititalTab = 0.obs;
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
}
