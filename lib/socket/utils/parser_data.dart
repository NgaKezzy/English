import 'dart:convert';
import 'dart:developer';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/socket/models/convert_json_server.dart';
import 'package:app_learn_english/socket/models/invite_model.dart';
import 'package:app_learn_english/socket/models/list_point.dart';
import 'package:app_learn_english/socket/models/player.dart';
import 'package:app_learn_english/socket/models/player_message.dart';
import 'package:app_learn_english/socket/models/reconnect.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/utils/constant.dart';
import 'package:crypto/crypto.dart';

class ParseDataSocket {
  //Response
  static List<String> responseDataParserLogin(String responseData) {
    try {
      ConvertJsonToServer user =
          ConvertJsonToServer.fromJson(jsonDecode(responseData));
      print(user);
      if (user.r!.isNotEmpty) {
        var data = user.r![0].v;
        var dataStatusArray = data!.split('${Constants.seperatorN4}');
        var parseData =
            dataStatusArray[1].split('${Constants.seperatorElement}');
        return parseData;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static List<table.Table> responseDataParseJoinZone(
      String responseData, int messageId) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    print("responseData:$responseData");
    final List<table.Table> tables = [];

    try {
      ConvertJsonToServer user =
          ConvertJsonToServer.fromJson(jsonDecode(responseData));
      var listUser1 = user.r![0].v;
      var tempArray = listUser1!.split('\u0002');
      tempArray.removeAt(0);
      tempArray.removeLast();
      print("ListTemp:$tempArray");
      for (var item in tempArray) {
        final List<Player> player = [];
        var isFull = false;
        var tem = item.split('\u0001');
        print("fullFilterTempArray:${tem}");

        var listAllInfoUserTable = tem[tem.length - 1]
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        var numberUserInTable =
            '"typeHand"'.allMatches(listAllInfoUserTable).length;

        if (numberUserInTable >= 2) {
          isFull = true;
          var listInfoUser = listAllInfoUserTable.split('},{');
          for (var i = 0; i < listInfoUser.length; i++) {
            var item = '';
            var master = false;
            if ((i % 2) == 0) {
              item = listInfoUser[i] + '}';
            } else {
              item = '{' + listInfoUser[i];
              master = true;
            }
            var listTem =
                item.replaceAll(',"curentPosition":,"changedPosition":', '');
            final decodedMap = json.decode('$listTem');
            player.add(Player(
                isMaster: master,
                id: int.parse('${decodedMap['id']}'),
                avatar: decodedMap['avatarID'],
                name: decodedMap['username'],
                isReady: true));
          }
        } else {
          // var listTem = listAllInfoUserTable.replaceAll(
          //     ',"curentPosition":,"changedPosition":', '');
          var decodedMap = json.decode(tem[tem.length - 1])[0];
          // final decodedMap = json.decode(listTem);
          player.add(Player(
            isMaster: true,
            id: int.parse('${decodedMap['id']}'),
            avatar: decodedMap['avatarID'],
            name: decodedMap['username'],
            isReady: false,
          ));
        }
        var decodedMap = json.decode(tem[tem.length - 1])[0];

        tables.add(
          table.Table(
            matchId: int.parse(tem[3]),
            maxNumberPlayers: int.parse(tem[4]),
            name: tem[5],
            nextTurn: decodedMap['id'],
            players: player,
            isFull: isFull,
            idVideo: int.parse(tem[8]),
          ),
        );
      }
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tables;
  }

  // static List<FriendModel>getListUser(String responseData){
  //   var listUserOnline=[];
  //
  //   return listUserOnline;
  // }

  static dynamic responseDataParseCreateRoom(
      String responseData, int messageId) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tables;
    try {
      ConvertJsonToServer dataObj =
          ConvertJsonToServer.fromJson(jsonDecode(responseData));
      var tempFilterData = dataObj.r![0].v;
      var tempArray = tempFilterData!.split(Constants.seperatorN4);
      var codeArray = tempArray[0].split(Constants.seperatorElement);
      var dataArray = tempArray[1].split(Constants.seperatorElement);
      if (int.parse(codeArray[1]) == 1) {
        var user = DataCache().getUserData();
        tables = table.Table(
          matchId: int.parse(dataArray[0]),
          maxNumberPlayers: int.parse(dataArray[3]),
          nextTurn: user.uid,
          isPlaying: 0,
          players: [
            Player(
              isMaster: true,
              id: user.uid,
              name: user.fullname.isEmpty ? user.username : user.fullname,
              avatar: user.avatar,
              isReady: false,
            ),
          ],
          name: "",
          isFull: false,
        );
        return tables;
      } else {
        return dataArray[0];
      }
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }
    return tables;
  }

  static dynamic responseDataParseJoinRoom(
      String responseData, int messageId, List<table.Table> selectTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };

    table.Table? tableChange;
    try {
      ConvertJsonToServer dataObj =
          ConvertJsonToServer.fromJson(jsonDecode(responseData));
      var tempFilterData = dataObj.r![0].v;
      var tempArray = tempFilterData!.split(Constants.seperatorN4);
      var codeArray = tempArray[0].split(Constants.seperatorElement);

      if (int.parse(codeArray[1]) == 0) {
        var dataArray = tempArray[1].split(Constants.seperatorElement);
        return dataArray[0].split(Constants.seperatorDiffArray)[0];
      } else {
        var dataArray = tempArray[1].split(Constants.seperatorDiffArray);
        var dataInfoRoom = dataArray[0].split(Constants.seperatorElement);
        var dataArrayInfo = dataArray[1].split(Constants.seperatorArray);
        List<Player> players = [];
        dataArrayInfo.forEach((element) {
          var data = element.split(Constants.seperatorElement);
          players.add(
            Player(
              isMaster: players.isEmpty ? true : false,
              id: int.parse(data[0]),
              name: data[1],
              avatar: data[2],
            ),
          );
        });
        var filterTable = selectTable.firstWhere(
          (element) => element.matchId == int.parse(dataInfoRoom[0]),
        );
        tableChange = table.Table(
          matchId: filterTable.matchId,
          maxNumberPlayers: filterTable.maxNumberPlayers,
          nextTurn: players[0].id,
          players: players,
          isFull: true,
          idVideo: filterTable.idVideo,
          name: filterTable.name,
        );
        return tableChange;
      }
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tableChange;
  }

  static table.Table? responseDataParseNewJoin(String responseData,
      int messageId, List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempFilterData = responseData.split(',');
      var tempArray = tempFilterData[0].split('\\u0001');
      var fullFilterTempArray = [];
      tempArray.forEach((element) => element
          .split('\\u0004')
          .forEach((el) => fullFilterTempArray.add(el)));
      table.Table filterSelectTable =
          selectTable.firstWhere((element) => element.matchId == idTable);
      List<Player> players = [...filterSelectTable.players];
      players.add(
        Player(
          isMaster: false,
          id: int.parse(fullFilterTempArray[2]),
          name: fullFilterTempArray[3],
          avatar: fullFilterTempArray[4],
        ),
      );
      tableChange = table.Table(
        matchId: filterSelectTable.matchId,
        maxNumberPlayers: filterSelectTable.maxNumberPlayers,
        isPlaying: filterSelectTable.isPlaying,
        nextTurn: filterSelectTable.nextTurn,
        phongId: filterSelectTable.matchId,
        players: players,
        isFull: filterSelectTable.isFull,
        idVideo: filterSelectTable.idVideo,
        name: filterSelectTable.name,
      );
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tableChange;
  }

  static table.Table? responseDataParseReady(String responseData, int messageId,
      List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempFilterData = responseData.split(',');
      var tempArray;
      if (tempFilterData.length > 1) {
        tempArray = tempFilterData[1].split('\\u0001');
      } else {
        tempArray = tempFilterData[0].split('\\u0001');
      }
      var fullFilterTempArray = [];
      tempArray.forEach((element) => element.split('\\u0004').forEach((el) => el
          .split('"')
          .forEach((element) => fullFilterTempArray.add(element))));
      table.Table filterSelectTable =
          selectTable.firstWhere((element) => element.matchId == idTable);
      List<Player> players = [...filterSelectTable.players];
      int indexPlayer = players.indexWhere(
          (element) => element.id == int.parse('${fullFilterTempArray[7]}'));
      log('Đây là fullFil $fullFilterTempArray');
      var newPlayer = Player(
        id: players[indexPlayer].id,
        name: players[indexPlayer].name,
        avatar: players[indexPlayer].avatar,
        isMaster: players[indexPlayer].isMaster,
        isReady: int.parse('${fullFilterTempArray[8]}') == 1 ? true : false,
      );
      players[indexPlayer] = newPlayer;
      tableChange = table.Table(
        matchId: filterSelectTable.matchId,
        maxNumberPlayers: filterSelectTable.maxNumberPlayers,
        isPlaying: 0,
        nextTurn: int.parse(fullFilterTempArray[7]),
        oldTurn: filterSelectTable.oldTurn,
        phongId: filterSelectTable.matchId,
        players: players,
        name: filterSelectTable.name,
        idVideo: filterSelectTable.idVideo,
      );
    } catch (e) {
      message.addAll({'error': -1});
      print('Đây là lỗi ready: $e');
    }

    return tableChange;
  }

  static table.Table? responseDataParseCancel(String responseData,
      int messageId, List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempArray = responseData.split('\\u0001');
      var fullFilterTempArray = [];
      tempArray.forEach((element) => element.split('\\u0004').forEach((el) => el
          .split('"')
          .forEach((element) => fullFilterTempArray.add(element))));
      print('Đây là fullfil: $fullFilterTempArray');
      if (selectTable.isNotEmpty) {
        table.Table filterSelectTable =
            selectTable.firstWhere((element) => element.matchId == idTable);
        List<Player> players = [...filterSelectTable.players];
        if (int.parse('${fullFilterTempArray[9]}') == 0) {
          int indexOfPlayer = players.indexWhere(
            (element) => element.id == int.parse(fullFilterTempArray[7]),
          );
          if (indexOfPlayer != -1) {
            players.removeAt(indexOfPlayer);
            if (players.isNotEmpty) {
              var newPlayer = new Player(
                id: players[0].id,
                name: players[0].name,
                avatar: players[0].avatar,
                isMaster: true,
              );
              players[0] = newPlayer;
            }
          }
        }

        tableChange = table.Table(
          matchId: filterSelectTable.matchId,
          maxNumberPlayers: filterSelectTable.maxNumberPlayers,
          phongId: filterSelectTable.matchId,
          players: players,
          isPlaying: int.parse('${fullFilterTempArray[9]}') == 0 ? 0 : 1,
          nextTurn: int.parse('${fullFilterTempArray[9]}') == 0
              ? (players.isNotEmpty ? players[0].id : null)
              : filterSelectTable.nextTurn,
          messages: int.parse('${fullFilterTempArray[9]}') == 0
              ? []
              : filterSelectTable.messages,
          name: filterSelectTable.name,
          idVideo: filterSelectTable.idVideo,
          isStatusCancel: int.parse('${fullFilterTempArray[9]}'),
        );
      }
    } catch (e) {
      message.addAll({'error': -1});
      print('Đây là lỗi $e');
    }

    return tableChange;
  }

  static InviteModel? responseDataParseInvite(String responseData) {
    InviteModel? inviteModel;
    try {
      var listTem = [];
      var tempFilterData = responseData.split('\\u0001');
      tempFilterData.map((item) {
        listTem.add(item);
      }).toList();
      var listTem1 = listTem[10].toString().split('"');
      var vId = listTem1[0];

      inviteModel = InviteModel(listTem[4], listTem[2], vId);
    } catch (e) {}
    return inviteModel;
  }

  static table.Table? responseDataParseStart(String responseData, int messageId,
      List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempFilterData = responseData.split(',');
      var tempArray = tempFilterData[0].split('\\u0001');
      var fullFilterTempArray = [];
      tempArray.forEach((element) => element.split('\\u0004').forEach((el) => el
          .split('"')
          .forEach((element) => fullFilterTempArray.add(element))));
      table.Table filterSelectTable =
          selectTable.firstWhere((element) => element.matchId == idTable);

      tableChange = table.Table(
        matchId: filterSelectTable.matchId,
        maxNumberPlayers: filterSelectTable.maxNumberPlayers,
        phongId: filterSelectTable.matchId,
        players: filterSelectTable.players,
        isPlaying: 1,
        tableSize: filterSelectTable.tableSize,
        oldTurn: filterSelectTable.oldTurn,
        nextTurn: filterSelectTable.nextTurn,
        messages: filterSelectTable.messages,
        idVideo: filterSelectTable.idVideo,
        name: filterSelectTable.name,
      );
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tableChange;
  }

  static table.Table? responseDataParseReject(String responseData,
      int messageId, List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempFilterData = responseData.split(',');
      var tempArray = tempFilterData[0].split('\\u0001');
      var fullFilterTempArray = [];
      tempArray.forEach((element) => element.split('\\u0004').forEach((el) => el
          .split('"')
          .forEach((element) => fullFilterTempArray.add(element))));
      table.Table filterSelectTable = selectTable.firstWhere((element) =>
          element.matchId == int.parse('${fullFilterTempArray[10]}'));
      var players = [...filterSelectTable.players];
      var indexPlayer = players.indexWhere(
        (element) => element.id == int.parse('${fullFilterTempArray[7]}'),
      );
      players.removeAt(indexPlayer);

      tableChange = table.Table(
        matchId: filterSelectTable.matchId,
        maxNumberPlayers: filterSelectTable.maxNumberPlayers,
        phongId: filterSelectTable.matchId,
        players: players,
        isPlaying: 0,
        tableSize: filterSelectTable.tableSize,
        oldTurn: filterSelectTable.oldTurn,
        nextTurn: players.isNotEmpty ? players[0].id : null,
        messages: filterSelectTable.messages,
        idVideo: filterSelectTable.idVideo,
        name: filterSelectTable.name,
      );
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tableChange;
  }

  static table.Table? responseDataParseTurn(String responseData, int messageId,
      List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    table.Table? tableChange;
    try {
      var tempFilterData = responseData.split('\\u0001');
      var fullFilterTempArray = [];
      tempFilterData.forEach((element) => element.split('\\u0004').forEach(
          (el) => el
              .split('"')
              .forEach((element) => fullFilterTempArray.add(element))));
      table.Table filterSelectTable =
          selectTable.firstWhere((element) => element.matchId == idTable);
      List<Player> players = [...filterSelectTable.players];
      List<PlayerMessage> messages = [...filterSelectTable.messages];
      PlayerMessage newMessage = PlayerMessage(
        message: fullFilterTempArray[11],
        subId: int.parse(fullFilterTempArray[10]),
        vid: int.parse(fullFilterTempArray[9]),
        point: double.parse(fullFilterTempArray[12]),
      );
      messages.add(newMessage);

      tableChange = table.Table(
        matchId: filterSelectTable.matchId,
        maxNumberPlayers: filterSelectTable.maxNumberPlayers,
        phongId: filterSelectTable.matchId,
        players: players,
        nextTurn: int.parse(fullFilterTempArray[8]),
        oldTurn: int.parse(fullFilterTempArray[7]),
        isPlaying: filterSelectTable.isPlaying,
        messages: messages,
        idVideo: filterSelectTable.idVideo,
        name: filterSelectTable.name,
      );
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return tableChange;
  }

  static table.Table? responseDataParseEnd(String responseData, int messageId,
      List<table.Table> selectTable, int idTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    print("responseData:$responseData");
    List<ListPoint> listPoints = [];
    table.Table? newTable;

    try {
      String responseDataCheck = '';
      if ('1114'.allMatches(responseData).length == 1) {
        var clearTrash = responseData.split('{');
        clearTrash.removeAt(0);
        responseDataCheck = '';
        clearTrash.forEach((word) => responseDataCheck += '{$word');
      } else {
        responseDataCheck = responseData;
      }

      ConvertJsonToServer user =
          ConvertJsonToServer.fromJson(jsonDecode(responseDataCheck));
      if (user.r != null) {
        String? listUser1;
        if (user.r!.length > 1) {
          listUser1 = user.r![1].v;
        } else {
          listUser1 = user.r![0].v;
        }

        var tempArray = listUser1!.split('\u0003');
        tempArray.removeAt(0);
        var listInfoUserString = tempArray[0].split('\u0002');

        for (var i = 0; i < listInfoUserString.length; i++) {
          print('Đây là listInfo: ' + listInfoUserString[i]);
          var separateInfoUser = listInfoUserString[i].split('\u0001');
          Map mapPoint = json.decode(separateInfoUser[6]);
          int count = 0;
          Map<String, double> parseMap = {};
          mapPoint.forEach((key, value) {
            parseMap[key.toString()] = double.parse('$value');
          });
          ListPoint parserPoint =
              ListPoint(int.parse('${separateInfoUser[0]}'), parseMap);
          listPoints.add(parserPoint);
        }

        table.Table filterSelectTable =
            selectTable.firstWhere((element) => element.matchId == idTable);
        List<Player> player = [];
        filterSelectTable.players.forEach((element) {
          player.add(Player(
            id: element.id,
            name: element.name,
            avatar: element.avatar,
            isMaster: element.isMaster,
            isReady: false,
          ));
        });

        newTable = table.Table(
          matchId: filterSelectTable.matchId,
          maxNumberPlayers: filterSelectTable.maxNumberPlayers,
          phongId: filterSelectTable.matchId,
          players: player,
          nextTurn: filterSelectTable.players[0].id,
          oldTurn: filterSelectTable.oldTurn,
          isPlaying: 0,
          messages: filterSelectTable.messages,
          idVideo: filterSelectTable.idVideo,
          listPoint: listPoints,
          name: filterSelectTable.name,
        );
      }
    } catch (e) {
      message.addAll({'error': -1});
      print('Đây là lỗi này $e');
    }

    return newTable;
  }

  //Request
  static String convertSendDataParserLogin(
      {required String username,
      required String password,
      required int version,
      required String device,
      required String deviceId}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        "1000${Constants.seperatorN4}$username${Constants.seperatorElement}$password${Constants.seperatorElement}$version${Constants.seperatorElement}$device${Constants.seperatorElement}$deviceId";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  //request login fb
  static String convertSendDataParserLoginFb(
      {required String socialId,
      required int version,
      required String device,
      required String token,
      required String deviceID}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    printRed("DataChuyenComan:$socialId");
    String dataConvert =
        "100001${Constants.seperatorN4}$socialId${Constants.seperatorElement}$version${Constants.seperatorElement}$device${Constants.seperatorElement}$token${Constants.seperatorElement}$deviceID";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static Reconnect? parseReconnect(
      String responseData, int messageId, List<table.Table> selectTable) {
    Map<String, dynamic> message = {
      'messageId': messageId,
    };
    print("responseData: ${responseData}");
    Reconnect? dataReconnect;
    try {
      ConvertJsonToServer user =
          ConvertJsonToServer.fromJson(jsonDecode(responseData));
      var value = user.r![0].v!.split(Constants.seperatorN4);
      var listData = value[1].split(Constants.seperatorDiffArray);
      var listPlayer = listData[1].split(Constants.seperatorArray);
      var gameInfo = listData[0].split(Constants.seperatorElement);

      int minMoney = int.parse(gameInfo[0]);
      int tableIndex = int.parse(gameInfo[1]);
      bool isPlaying = gameInfo[3] == "true";
      int tableId = int.parse(gameInfo[2]);
      bool isNewRound = true;
      int videoId = int.parse(gameInfo[7]);
      // if (gameInfo[6] == 0) {
      //   isNewRound = true;
      // } else {
      //   isNewRound = false;
      // }

      List<Player> listPlayers = [];
      for (var i = 0; i < listPlayer.length; i++) {
        var p = listPlayer[i].split(Constants.seperatorElement);
        listPlayers.add(Player(
          isMaster: i % 2 == 0 ? true : false,
          id: int.parse(p[0]),
          name: p[1],
          avatar: p[2],
          isReady: true,
        ));
      }
      dataReconnect = Reconnect(
        minMoney: minMoney,
        tableIndex: tableIndex,
        isPlaying: isPlaying,
        tableId: tableId,
        isNewRound: isNewRound,
        lastTurnedCardList: "",
        listPlayers: listPlayers,
        videoId: videoId,
      );
      print("dataReconnect: ${dataReconnect}");
    } catch (e) {
      message.addAll({'error': -1});
      print(e);
    }

    return dataReconnect;
  }

  static String convertSendDataParseJoinZone(
      {required int zoneId, int cacheVersion = 1}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        "110701${Constants.seperatorN4}$zoneId${Constants.seperatorElement}$cacheVersion";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseCreateRoom({
    required int tableIndex,
    required int roomId,
    required int moneyBet,
    required int idVideo,
    required String nameVideo,
  }) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        "1100${Constants.seperatorN4}$tableIndex${Constants.seperatorElement}$roomId${Constants.seperatorElement}$moneyBet${Constants.seperatorElement}0${Constants.seperatorElement}0${Constants.seperatorElement}$nameVideo${Constants.seperatorElement}$idVideo";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseInvite({
    required int roomID,
    required int destUid,
  }) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        "1101${Constants.seperatorN4}$roomID${Constants.seperatorElement}$destUid";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseAcceptJoin({required String idTable}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert = "1105${Constants.seperatorN4}$idTable";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseReady(
      {required int idTable, required int ready}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        "1110${Constants.seperatorN4}$idTable${Constants.seperatorElement}$ready";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseStart({required int idTable}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert = "1108${Constants.seperatorN4}$idTable";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseGetListFriend({required int countFriend}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert = "1212${Constants.seperatorN4}$countFriend";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseTurn(
      {required int idTable,
      required int zoneId,
      required int vid,
      required int subId,
      required String voiceConvert,
      required double score,
      String mediaLink = ''}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert =
        '1104${Constants.seperatorN4}$zoneId${Constants.seperatorElement}$idTable${Constants.seperatorElement}$vid${Constants.seperatorElement}$subId${Constants.seperatorElement}$voiceConvert${Constants.seperatorElement}$score${Constants.seperatorElement}${Session().BASE_URL}';
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String convertSendDataParseCancel({required int idTable}) {
    Map<String, List> arraySend = {};
    final List<Map<String, String>> sendData = [];
    String dataConvert = "1103${Constants.seperatorN4}$idTable";
    sendData.add({
      "v": dataConvert,
    });
    arraySend = {
      "r": sendData,
    };
    return json.encode(arraySend);
  }

  static String requestDataParse(int codeSocket, Map<String, dynamic> data) {
    String command;
    switch (codeSocket) {
      case ConstantsCodeSocket.login:
        command = convertSendDataParserLogin(
          username: data['username'],
          password: data['password'],
          version: data['version'],
          device: data['device'],
          deviceId: data['deviceId'],
        );
        break;

      case ConstantsCodeSocket.loginSocial:
        command = convertSendDataParserLoginFb(
          socialId: data['socialId'],
          token: data['token'],
          version: data['version'],
          device: data['device'],
          deviceID: data['deviceId'],
        );
        break;

      case ConstantsCodeSocket.joinZone:
        command = convertSendDataParseJoinZone(zoneId: data['zoneId']);
        break;
      case ConstantsCodeSocket.createRoom:
        command = convertSendDataParseCreateRoom(
          tableIndex: data['tableIndex'],
          roomId: data['roomId'],
          moneyBet: data['moneyBet'],
          idVideo: data['idVideo'],
          nameVideo: data['nameVideo'],
        );
        break;
      case ConstantsCodeSocket.acceptJoin:
        command = convertSendDataParseAcceptJoin(idTable: data['idTable']);
        break;
      case ConstantsCodeSocket.ready:
        command = convertSendDataParseReady(
            idTable: data['idTable'], ready: data['ready']);
        break;
      case ConstantsCodeSocket.start:
        command = convertSendDataParseStart(idTable: data['idTable']);
        break;
      case ConstantsCodeSocket.turn:
        command = convertSendDataParseTurn(
          idTable: data['idTable'],
          zoneId: data['zoneId'],
          score: double.parse('${data['score']}'),
          subId: data['subId'],
          vid: data['vid'],
          voiceConvert: data['voiceConvert'],
        );
        break;
      case ConstantsCodeSocket.cancel:
        command = convertSendDataParseCancel(idTable: data['idTable']);
        break;

      case ConstantsCodeSocket.getListFrient:
        command =
            convertSendDataParseGetListFriend(countFriend: data['countFriend']);
        break;
      default:
        command = 'Lỗi rồi';
        break;
    }
    return command;
  }

  // Utils
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static int responseDataParseCode(String responseData) {
    var list = responseData.split('\\u0001');
    int code = 0;
    RegExp _regExp = RegExp(r'^[0-9]+$');
    var filterList = list[0].split('"');
    filterList.forEach((element) {
      if (_regExp.hasMatch(element)) {
        code = int.parse(element);
      }
    });
    return code;
  }

  Future<DataTalk?> getDataVideoInvite(String vId) async {
    DataTalk? dataTalk = await TalkAPIs().detailVideo(id: vId);
    printBlue("DataLink:${dataTalk!.link_origin},link:${dataTalk.picLink}");
    return dataTalk;
  }
}
