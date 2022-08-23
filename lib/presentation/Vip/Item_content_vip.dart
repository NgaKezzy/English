import 'package:flutter/material.dart';

class ItemContentVipWidget extends StatelessWidget {
  final List<String> mainContent;
  ItemContentVipWidget({
    Key? key,
    required this.mainContent,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Center(
              child: Image.asset(
                mainContent[1],
                height: 30,
                width: 30,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              mainContent[0],
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  String checkSVG(name) {
    switch (name) {
      case 'Không giới hạn thả tim':
        return 'assets/icons-svg/icon_noad.svg';
      case 'Vô hiệu quảng cáo':
        return 'assets/icons-svg/icon_levelup.svg';
      case 'Không giới hạn số lượng mẫu câu ôn tập':
        return 'assets/icons-svg/icon_book.svg';
      case 'Xem tất cả video VIP':
        return 'assets/icons-svg/icon_noad.svg';
      default:
        break;
    }
    return 'assets/icons-svg/icon_noad.svg';
  }
}
