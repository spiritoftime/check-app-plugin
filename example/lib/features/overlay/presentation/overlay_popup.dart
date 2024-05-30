
import 'package:flutter/material.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';


class OverlayWidget extends StatelessWidget {
  const OverlayWidget({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: StreamBuilder(
                stream: OverlayPopUp.dataListener,
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    snapshot.data?['mssg'] ?? '',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.red[900],
              elevation: 12,
              onPressed: () async => await OverlayPopUp.closeOverlay(),
              child: const Text('X',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
