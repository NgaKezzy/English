import 'package:flutter/material.dart';

class TitleConfigVideo extends StatelessWidget {
  final String title;
  final Function showSetting;
  const TitleConfigVideo(
      {Key? key, required this.title, required this.showSetting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => showSetting(context),
              child: Container(
                child: Card(
                  color: Colors.blue,
                  child: Icon(
                    Icons.more_horiz_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
