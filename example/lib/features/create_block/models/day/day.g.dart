// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      name: $enumDecode(_$DaysEnumMap, json['name']),
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'name': _$DaysEnumMap[instance.name]!,
    };

const _$DaysEnumMap = {
  Days.monday: 'monday',
  Days.tuesday: 'tuesday',
  Days.wednesday: 'wednesday',
  Days.thursday: 'thursday',
  Days.friday: 'friday',
  Days.saturday: 'saturday',
  Days.sunday: 'sunday',
};
