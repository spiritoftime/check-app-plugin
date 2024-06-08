import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';

class AppRepository { // business logic code
  Future<List<App>> getApp() async {
    final _checkAppPlugin = CheckappPlugin();
    List<Map<String,dynamic>> apps = await _checkAppPlugin.getLaunchableApplications();
    return apps.map((e) => App.fromJson(e)).toList();
  }
}
