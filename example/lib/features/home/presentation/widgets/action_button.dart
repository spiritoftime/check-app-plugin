import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_location/cubit/location_cubit.dart';
import 'package:checkapp_plugin_example/features/create_schedule/cubit/schedule_cubit.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/cubit/cubit/wifi_cubit.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_event.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({super.key, required this.s});
  final Schedule s;
  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_vert,
          size: 40,
          color: Colors.grey,
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...MenuItems.secondItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem, widget.s);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.redAccent,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [edit];
  static const List<MenuItem> secondItems = [delete];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit);
  // static const toggleActive = MenuItem(text: 'Toggle Active', icon: Icons.toggle_off);
  // static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item, Schedule s) {
    switch (item) {
      case MenuItems.edit:
        context.goNamed('confirm-schedule', extra: {
          'blockCubit': BlockCubit(initialBlock: s.block),
          'timeCubit': TimeCubit(initialTime: s.time),
          'locationCubit': LocationCubit(initialLocation: s.location),
          'wifiCubit': WifiCubit(initialWifi: s.wifi),
          'scheduleCubit': ScheduleCubit(initialSchedule: s),
        });
        //Do something
        break;

      case MenuItems.delete:
        if (s.id != null) {
          context.read<SchedulesBloc>().add(DeleteSchedule(s.id!));
        }
        context.read<SchedulesBloc>().add(LoadSchedules());
        break;
    }
  }
}
