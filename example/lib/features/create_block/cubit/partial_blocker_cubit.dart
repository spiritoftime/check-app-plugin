import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartialBlockerCubit extends Cubit<List<PartialBlocker>> {
  PartialBlockerCubit({List<PartialBlocker>? initialPartialBlocker})
      : super(initialPartialBlocker ?? []);
  void updatePartialBlockerCubit(
      {required List<PartialBlocker> partialBlockers}) {
    emit(partialBlockers);
  }
}
