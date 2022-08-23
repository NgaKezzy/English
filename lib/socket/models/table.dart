import 'package:app_learn_english/socket/models/list_point.dart';
import 'package:app_learn_english/socket/models/player.dart';
import 'package:app_learn_english/socket/models/player_message.dart';

class Table {
  final int? tableIndex;
  final int? tableSize;
  final int? firstCashBet;
  final int? matchId;
  final int? maxNumberPlayers;
  final String? name;
  final int? oldTurn;
  final int? nextTurn;
  final int isPlaying;
  final int? phongId;
  final List<Player> players;
  final List<PlayerMessage> messages;
  final bool? isFull;
  final int? idVideo;
  final List<ListPoint>? listPoint;
  final int? winner;
  final int? isStatusCancel;

  Table(
      {this.messages = const [],
      this.oldTurn,
      this.nextTurn,
      this.tableIndex,
      this.tableSize,
      this.firstCashBet,
      this.matchId,
      this.maxNumberPlayers,
      this.name,
      this.isPlaying = 0,
      this.phongId,
      this.players = const [],
      this.isFull = false,
      this.idVideo,
      this.listPoint,
      this.winner,
      this.isStatusCancel});

  Map<String, dynamic> toJson() => {
        'tableIndex': this.tableIndex,
        'tableSize': this.tableSize,
        'firstCashBet': this.firstCashBet,
        'matchId': this.matchId,
        'maxNumberPlayers': this.maxNumberPlayers,
        'name': this.name,
        'isPlaying': this.isPlaying,
        'phongId': this.phongId,
        'isFull': this.isFull
      };
}
