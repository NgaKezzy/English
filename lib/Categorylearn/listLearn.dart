import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dataLearn.dart';

class DataList extends StatelessWidget {
  final List<DataLearn> data;

  DataList({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.cyan,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(data[index].name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                new Text(
                  'Ten: ${data[index].description}',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          onTap: () {},
        );
      },
      itemCount: data.length,
    );
  }
}

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListScreen();
  }
}

class _ListScreen extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Api"),
      ),
      body: FutureBuilder(
          future: fetchData(http.Client()),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('404');
            }
            return snapshot.hasData
                ? DataList(data: snapshot.data)
                : Center(
                    // child: Platform.isAndroid
                    //     ? CircularProgressIndicator()
                    //     : CupertinoActivityIndicator());
                    child: const PhoLoading(),
                  );
          }),
    );
  }
}
