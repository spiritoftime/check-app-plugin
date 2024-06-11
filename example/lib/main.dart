import 'package:checkapp_plugin_example/firebase_options.dart';
import 'package:checkapp_plugin_example/repository/auth_repository/authentication_repository.dart';
import 'package:checkapp_plugin_example/repository/background_repository/background_repository.dart';
import 'package:checkapp_plugin_example/features/basic/presentation/basic_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';
import 'package:checkapp_plugin_example/features/overlay/presentation/overlay_popup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
); 
 await AuthenticationRepository().signInGetUserId();
  // overlayPopUp();
  // await initializeService();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(
      RepositoryProvider(
        create: (context) => AppRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: true,
              child: const CreateBlockPage(
                extra: {},
              ),
              create: (context) =>
                  AppsBloc(RepositoryProvider.of<AppRepository>(context))
                    ..add(
                      LoadApps(),
                    ),
            ),
          ],
          child:
              const MyApp(), // TODO: currently set to myapp to make it run initially. however, this still blocks the UI. Consider an isolate.
        ),
      ),
    ),
  );
}

// /
// / the name is required to be `overlayPopUp` and has `@pragma("vm:entry-point")`
// /
// needs to be at main.dart for some reason
@pragma("vm:entry-point")
void overlayPopUp() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}
