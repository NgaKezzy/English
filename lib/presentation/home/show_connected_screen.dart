import 'package:app_learn_english/Providers/check_login.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ShowConnectedScreen extends StatefulWidget {
  const ShowConnectedScreen({Key? key}) : super(key: key);

  @override
  State<ShowConnectedScreen> createState() => _ShowConnectedScreenState();
}

class _ShowConnectedScreenState extends State<ShowConnectedScreen> {
  bool hasInternet = false;
  void getInternet(BuildContext context) {
    Provider.of<CheckLogin>(context, listen: false)
        .setCheckInternet(hasInternet);
  }

  @override
  void initState() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      bool checkInternet = status == InternetConnectionStatus.connected;
      setState(() {
        hasInternet = checkInternet;
      });

      getInternet(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sorry! \nThe network connection has been lost. \n\nPlease check the network connection again and try again.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
