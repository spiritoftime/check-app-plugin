import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<Location> {
  LocationCubit()
      : super(Location(longitude: 0.0, location: '', latitude: 0.0));
  void updateLocation({Location? location}) {
    emit(state.copyWith(
        longitude: location?.longitude,
        location: location?.location,
        latitude: location?.latitude));
  }
}
