import 'dart:io';

import 'package:cactus/cactus.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/paths.dart';
import 'package:lokal_chat/app/types/service.types.dart';

class ModelHandler extends GetxService {
  //CactusContext? _cactusContext;
  DownloadProgressStatus downloadStatus = (
      statusMessage: ''.obs,
      downloadProgress: 0.0.obs,
      downloadComplete: false.obs
  );

  Future<DownloadProgressStatus?> downloadFileIfNeeded(
    String url) async {
    if(downloadStatus.downloadProgress.value > 0.0){
      return null;
    }
    String modelName = url.split('/').last;
    String filePath = await AppPaths.modelsPath;
    final file = File(filePath);
    if (!await file.exists()) {
      downloadStatus.statusMessage.value = 'Downloading model...';
      downloadStatus.downloadProgress.value = 0.0;
      await downloadModel(
        url,
        '$filePath/$modelName',
        onProgress: (progress, status) {
          downloadStatus.downloadProgress.value = progress ?? 0.0;
          downloadStatus.statusMessage.value = "Downloading model :$status";
          if(progress == 1.0){
            downloadStatus.downloadProgress.value = 0.0;
            downloadStatus.statusMessage.value = '';
            downloadStatus.downloadComplete.value = true;
          }
        },
      );
    } else {
      downloadStatus.statusMessage.value = 'model found locally.';
      downloadStatus.downloadComplete.value = true;
    }

    return downloadStatus;
  }
}