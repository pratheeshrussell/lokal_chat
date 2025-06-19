import 'package:get/get.dart';

typedef DownloadProgressStatus = ({
  RxString statusMessage,
  RxDouble downloadProgress,
  RxBool downloadComplete
});