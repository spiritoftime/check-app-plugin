import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<List<Location>> {
  LocationCubit({List<Location>? initialLocation})
      : super(initialLocation?? []);
  void updateLocation({required List<Location> location}) {

    
      emit(location);
    
  }
}
