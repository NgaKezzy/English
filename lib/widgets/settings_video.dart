import 'package:flutter/material.dart';

class SettingsVideo extends StatelessWidget {
  const SettingsVideo({Key? key}) : super(key: key);

  Widget buildElementSetting(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              child: Switch(
                onChanged: (valueBoolean) {},
                value: true,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cài Đặt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.close_rounded,
                    size: 40,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phụ đề',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 'all',
                          groupValue: 'all',
                          onChanged: (value) {},
                        ),
                        Text(
                          'ALL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'vi',
                          groupValue: 'all',
                          onChanged: (value) {},
                        ),
                        Text(
                          'VI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'en',
                          groupValue: 'all',
                          onChanged: (value) {},
                        ),
                        Text(
                          'EN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
          ),
          buildElementSetting(context, 'Tự động phát'),
          buildElementSetting(context, 'Tự động lặp lại'),
          buildElementSetting(context, 'Lặp lại mẫu câu chính'),
        ],
      ),
    );
  }
}
