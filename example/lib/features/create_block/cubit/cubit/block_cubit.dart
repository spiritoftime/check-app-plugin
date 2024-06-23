import 'package:bloc/bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';

class BlockCubit extends Cubit<Block> {
  BlockCubit({Block? initialBlock})
      : super(initialBlock ??
            Block(apps: [], websites: [], keywords: [], partialBlockers: []));

  void updateBlock(
      {List<App>? apps,
      List<Website>? websites,
      List<Keyword>? keywords,
      List<PartialBlocker>? partialBlockers}) {
    emit(state.copyWith(
        apps: apps,
        websites: websites,
        keywords: keywords,
        partialBlockers: partialBlockers));
  }
}
