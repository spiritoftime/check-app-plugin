import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_state.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAppRepository extends Mock implements AppRepository {
  @override
  Future<List<App>> getApp() async {
    return [
      const App(
          packageName: 'packageName',
          iconBase64String: 'iconBase64String',
          appName: 'appName')
    ];
  }
}

void main() {
  group(AppsBloc, () {
    late AppsBloc appBloc;

    setUp(() {
      AppRepository mockAppRepository = MockAppRepository();
      appBloc = AppsBloc(mockAppRepository);
    });
    test('initial state is empty', () {
      expect(appBloc.state, equals(const AppsLoaded()));
    });
    blocTest(
      'returns an app on load apps',
      build: () => appBloc,
      act: (bloc) => bloc.add(LoadApps()),
      expect: () => [
        AppsLoading(),
        const AppsLoaded(apps: [
          App(
              packageName: 'packageName',
              iconBase64String: 'iconBase64String',
              appName: 'appName')
        ])
      ],
    );
  });
}
