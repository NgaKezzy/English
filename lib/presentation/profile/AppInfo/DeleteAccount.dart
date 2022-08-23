import 'package:flutter/material.dart';
class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
        'Delete Account',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800,color: Colors.black),),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          elevation: 4,
          child: Container(
            padding:
            EdgeInsets.symmetric( vertical: 16),
            height:700,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tell us why you want to leave Cake.',
                          style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),),
                        Text('We are open to your opinion.',
                          style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
