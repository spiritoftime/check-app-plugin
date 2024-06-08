import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<Location?> {
  LocationCubit()
      : super(null);
  void updateLocation({Location? location}) {
    if (location == null){

      emit(null);
    }
    else {
      emit(location.copyWith(
          longitude: location.longitude,
          location: location.location,
          latitude: location.latitude));
    }
  }
}
