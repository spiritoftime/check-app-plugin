import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app.dart';

class AppRepository {
  Future<List<App>> getApp() async {
    final _checkAppPlugin = CheckappPlugin();
    List<dynamic> apps = await _checkAppPlugin.getLaunchableApplications();
    return apps.map((e) => App.fromJson(e)).toList();
  }
}
