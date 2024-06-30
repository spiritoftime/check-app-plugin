import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule_details/schedule_details.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_event.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_state.dart';
import 'package:checkapp_plugin_example/repository/database_repository/database_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

final mockSchedule = Schedule(
  wifi: [const Wifi(wifiName: "wifiname")],
  location: [
    const Location(longitude: 123, location: "location name", latitude: 100)
  ],
  scheduleDetails: ScheduleDetails(
      isActive: false, scheduleName: "original schedule", iconName: "icon"),
  block: Block(partialBlockers: [
    const PartialBlocker(
        packageName: "package",
        appName: "app",
        feature: "feature",
        imagePath: "imgpath")
  ], apps: [
    const App(packageName: "app", iconBase64String: "icon", appName: "appname")
  ], websites: [
    Website(url: "website url")
  ], keywords: [
    Keyword(keyword: "keyword")
  ]),
  time: Time(days: [], timings: []),
);

class MockDbRepository extends Mock implements DatabaseRepository {
  @override
  Future<void> updateSchedule({required Schedule s}) async {}

  @override
  Future<List<Schedule>> schedules() async {
    return Future.value([mockSchedule]);
  }

  @override
  Future<void> insertSchedule(Schedule schedule) async {}

  @override
  Future<void> deleteSchedule({required int scheduleId}) async {}
}

void main() {
  group(
    'SchedulesBloc',
    () {
      late SchedulesBloc schedulesBloc;
      late MockDbRepository mockDbRepository;

      setUp(() {
        mockDbRepository = MockDbRepository();
        schedulesBloc = SchedulesBloc(mockDbRepository);
      });

      test('initial state is empty', () {
        expect(schedulesBloc.state, equals(const SchedulesLoaded()));
      });

      blocTest(
        'emits [SchedulesLoading, SchedulesLoaded] when LoadSchedules is added',
        build: () => schedulesBloc,
        act: (bloc) => bloc.add(LoadSchedules()),
        expect: () => [
          SchedulesLoading(),
          SchedulesLoaded(schedules: [mockSchedule])
        ],
      );
    },
  );
}
