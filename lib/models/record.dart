import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class TeaRecord extends HiveObject {
  @HiveField(0)
  final String employeeName;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final DateTime timestamp;

  TeaRecord({
    required this.employeeName,
    required this.weight,
    required this.timestamp,
  });
}
