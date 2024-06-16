import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WifiCubit extends Cubit<List<Wifi>> {
  WifiCubit({List<Wifi>? initialWifi}) : super(initialWifi ?? []);

  void updateWifi({required List<Wifi> wifi}) {
    emit(wifi);
  }
}
