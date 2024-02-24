import 'package:flutter/material.dart';
import 'package:lokal_chat/constants/constants.app.dart';
import 'package:lokal_chat/models/model-params.dart';
import 'package:lokal_chat/services/ai_model_manager.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LlamaModelParams params = LlamaModelParams();
  AIModelManager modelsManager = AIModelManager.instance;
  
  loadModel(){
    modelsManager.loadModelFile(context:context, params: params);
  }

  unloadModel(){
    modelsManager.unloadModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: Column(
        children: [
          Text("Home Page"),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () { loadModel(); },
            child: const Text('Load Model'),
          ),

          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () { unloadModel(); },
            child: const Text('UnLoad Model'),
          )
        ]),
      
      )
    );
  }
}