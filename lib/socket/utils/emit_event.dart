import 'package:app_learn_english/socket/utils/constant.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';

class EmitEvent {
  static String emitJoinZone() {
    Map<String, dynamic> data = {'zoneId': ConfigSocket.zoneId};
    String command = ParseDataSocket.requestDataParse(
      ConstantsCodeSocket.joinZone,
      data,
    );
    return command;
  }

  static String emitTurn({
    required int idTable,
    required int zoneId,
    required double score,
    required int subId,
    required int vid,
    required String voiceConvert,
  }) {
    Map<String, dynamic> data = {
      'idTable': idTable,
      'zoneId': zoneId,
      'score': score,
      'subId': subId,
      'vid': vid,
      'voiceConvert': voiceConvert,
    };
    String command =
        ParseDataSocket.requestDataParse(ConstantsCodeSocket.turn, data);
    return command;
  }

  static String emitCancel({required int idTable}) {
    Map<String, dynamic> data = {
      'idTable': idTable,
    };
    String command =
        ParseDataSocket.requestDataParse(ConstantsCodeSocket.cancel, data);
    return command;
  }

  static String emitStart({required int idTable}) {
    Map<String, dynamic> data = {
      'idTable': idTable,
    };

    String command =
        ParseDataSocket.requestDataParse(ConstantsCodeSocket.start, data);
    return command;
  }

  static String emitReady({required int idTable, required int isReady}) {
    Map<String, dynamic> data = {'idTable': idTable, 'ready': isReady};
    String command =
        ParseDataSocket.requestDataParse(ConstantsCodeSocket.ready, data);
    return command;
  }
}
