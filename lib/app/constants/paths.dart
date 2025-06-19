import 'package:path_provider/path_provider.dart';

class AppPaths{
  static Future<String> get modelsPath async{
    return (await getDownloadsDirectory())!.path;
  }
  
  static Future<String> get dbPath async {
    // TODO: Check this later
    //await getLibraryDirectory();
    // await getDatabasesPath();
    return (await getDownloadsDirectory())!.path;
  }
  


}