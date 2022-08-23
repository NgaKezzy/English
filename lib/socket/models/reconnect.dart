import 'package:app_learn_english/socket/models/player.dart';

class Reconnect {
  final int minMoney;
  final int tableIndex;
  final bool isPlaying;
  final int tableId;
  final bool isNewRound;
  final int videoId;

  final String lastTurnedCardList;
  final List<Player> listPlayers;
  Reconnect({
    required this.minMoney,
    required this.tableIndex,
    required this.isPlaying,
    required this.tableId,
    required this.isNewRound,
    required this.lastTurnedCardList,
    required this.listPlayers,
    required this.videoId,
  });
}
