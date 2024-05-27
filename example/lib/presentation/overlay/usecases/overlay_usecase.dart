import 'dart:async';

import 'package:overlay_pop_up/overlay_pop_up.dart';

class OverlayUsecase {
  Future<bool> openOverlayPopUp() async {

      final isOverlayActive = await OverlayPopUp.isActive();
      if (!isOverlayActive) {
        await OverlayPopUp.showOverlay(
          screenOrientation: ScreenOrientation.portrait,
          closeWhenTapBackButton: true,
          isDraggable: true,
        );
      }
      return true;

  }
}