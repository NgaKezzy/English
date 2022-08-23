import 'package:app_learn_english/socket/models/table.dart';

class Room {
  final int? roomLevel;
  final int? minCash;
  final int? phongId;
  final bool? canAccess;
  final int? levelAccess;
  final int? online;
  final List<Table>? tables;

  Room({
    this.roomLevel,
    this.minCash,
    this.phongId,
    this.canAccess,
    this.levelAccess,
    this.online,
    this.tables,
  });

  Map<String, dynamic> toJson() => {
        'roomLevel': this.roomLevel,
        'minCash': this.minCash,
        'phongId': this.phongId,
        'canAccess': this.canAccess,
        'levelAccess': this.levelAccess,
        'online': this.online,
        'tables': this.tables,
      };
}
