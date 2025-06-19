import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/strings.dart';
import 'package:lokal_chat/app/modules/global/bindings/initial_binding.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize bindings first -Get doesnt wait for bindings to load
  // TODO - move to splash screen
  final initialBinding = InitialBinding();
  await initialBinding.dependencies();
  
  runApp(
    GetMaterialApp(
      title: AppStrings.appName,
      initialRoute: AppPages.INITIAL,
      // initialBinding: initialBinding,
      getPages: AppPages.routes,
    ),
  );
}
