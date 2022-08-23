import 'package:app_learn_english/socket/provider/socket_provider.dart';

import 'package:app_learn_english/socket/utils/parser_data.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTableScreen extends StatefulWidget {
  const ListTableScreen({Key? key}) : super(key: key);

  @override
  State<ListTableScreen> createState() => _ListTableScreenState();
}

class _ListTableScreenState extends State<ListTableScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text('Danh sách bàn thử thách'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (contextList, index) => GestureDetector(
                onTap: () {
                  var data = {
                    'idTable':
                        socketProvider.listTable[index].matchId.toString(),
                  };
                  var command = ParseDataSocket.requestDataParse(1105, data);
                  context
                      .read<SocketProvider>()
                      .socketChannel!
                      .sink
                      .add(command);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (contx) => InsideTableScreen(
                  //       idTable: socketProvider.listTable[index].matchId!,
                  //     ),
                  //   ),
                  // );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                  ),
                  title: Text('Bàn ${index + 1}'),
                  subtitle: Text(
                    'Số người tối đa: ${socketProvider.listTable[index].maxNumberPlayers}',
                  ),
                  trailing: Text(
                    'ID: ${socketProvider.listTable[index].matchId}',
                  ),
                ),
              ),
              childCount: socketProvider.listTable.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // SocketServices().socketChannel.sink.add(
          //       ParseDataSocket.convertSendDataParseCreateRoom(
          //         tableIndex: 1,
          //         roomId: 0,
          //         moneyBet: 50,
          //       ),
          //     );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
