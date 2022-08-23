import 'package:app_learn_english/presentation/profile/AppInfo/FAQ.dart';
import 'package:flutter/material.dart';

class ScreenFAQ extends StatefulWidget {
  const ScreenFAQ({Key? key}) : super(key: key);

  @override
  _ScreenFAQState createState() => _ScreenFAQState();
}

class _ScreenFAQState extends State<ScreenFAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'FAQ',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 16),
            child: Row(children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ]),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            height: 60,
            width: 400,
            color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'Pho English FAQ',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FAQ(),
        ])));
  }
}
