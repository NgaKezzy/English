import 'package:flutter/material.dart';

class FromLanguage extends StatefulWidget {
  FromLanguage({Key? key}) : super(key: key);

  @override
  _FromLanguageState createState() => _FromLanguageState();
}

@override
class _FromLanguageState extends State<FromLanguage>
    with SingleTickerProviderStateMixin {
  bool isActiveBtn1 = false;
  bool isActiveBtn2 = false;
  bool isActiveBtn3 = false;
  bool isActiveBtn4 = false;
  bool isActiveBtn5 = false;
  bool isActiveBtn6 = false;
  bool isActiveBtn7 = false;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 670,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: Colors.white54.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn1 = !isActiveBtn1;
                  if (isActiveBtn1) {
                    isActiveBtn2 = false;
                    isActiveBtn3 = false;
                    isActiveBtn4 = false;
                    isActiveBtn5 = false;
                    isActiveBtn6 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Ấn Độ',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn2 = !isActiveBtn2;
                  if (isActiveBtn2) {
                    isActiveBtn1 = false;
                    isActiveBtn3 = false;
                    isActiveBtn4 = false;
                    isActiveBtn5 = false;
                    isActiveBtn6 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Việt',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn3 = !isActiveBtn3;
                  if (isActiveBtn3) {
                    isActiveBtn1 = false;
                    isActiveBtn2 = false;
                    isActiveBtn4 = false;
                    isActiveBtn5 = false;
                    isActiveBtn6 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Anh'
                '',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn4 = !isActiveBtn4;
                  if (isActiveBtn4) {
                    isActiveBtn1 = false;
                    isActiveBtn2 = false;
                    isActiveBtn3 = false;
                    isActiveBtn5 = false;
                    isActiveBtn6 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Nga',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn5 = !isActiveBtn5;
                  if (isActiveBtn5) {
                    isActiveBtn1 = false;
                    isActiveBtn2 = false;
                    isActiveBtn3 = false;
                    isActiveBtn4 = false;
                    isActiveBtn6 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Trung Quốc',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn6 = !isActiveBtn6;
                  if (isActiveBtn6) {
                    isActiveBtn1 = false;
                    isActiveBtn2 = false;
                    isActiveBtn3 = false;
                    isActiveBtn4 = false;
                    isActiveBtn5 = false;
                    isActiveBtn7 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Tây Ban Nha',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Container(
            height: 70,
            width: 330,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isActiveBtn7 = !isActiveBtn7;
                  if (isActiveBtn7) {
                    isActiveBtn1 = false;
                    isActiveBtn2 = false;
                    isActiveBtn3 = false;
                    isActiveBtn4 = false;
                    isActiveBtn5 = false;
                    isActiveBtn6 = false;
                  }
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfirmLanguage()));
              },
              child: Text(
                'Tiếng Nhật Bản',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmLanguage extends StatefulWidget {
  @override
  _ConfirmLanguageState createState() => _ConfirmLanguageState();
}

class _ConfirmLanguageState extends State<ConfirmLanguage> {
  @override
  Widget build(BuildContext context) {
    Future<bool> showEditPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Bạn chắc chắn muốn chọn ngôn ngữ này'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      )),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Override Back Button"),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: Text("Override Back Button"),
        ),
      ),
      onWillPop: showEditPopup,
    );
  }
}
