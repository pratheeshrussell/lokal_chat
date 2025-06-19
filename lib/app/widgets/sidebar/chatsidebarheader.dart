import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/strings.dart';

class ChatSidebarHeader extends StatelessWidget {
  const ChatSidebarHeader({super.key});

  Widget headerContent(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.appName),
        OutlinedButton(
          onPressed: (){
            Get.toNamed('/modelmanager');
        }, child: Text('Model Manager')),
      ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      padding: const EdgeInsets.all(10.0),
      child: SafeArea(child: headerContent()),
    );
  }
}