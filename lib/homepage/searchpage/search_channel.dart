import 'package:app_learn_english/homepage/searchpage/search_widget/search_channel_top.dart';
import 'package:flutter/material.dart';

class SearchChannel extends StatefulWidget {
  @override
  _SearchChannel createState() => _SearchChannel();
}

class _SearchChannel extends State<SearchChannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage('assets/images/background.png'),
                    //     fit: BoxFit.fill),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade700,
                        Colors.tealAccent.shade400,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      TopSearchChannel(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
