import 'package:app_learn_english/homepage/pages/more_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemMoreSubViewNoData extends StatelessWidget {
  DataUser userData;
  List<Category> listCategory;
  final Function showSetting;
  ItemMoreSubViewNoData(
      {Key? key,
      required this.userData,
      required this.listCategory,
      required this.showSetting});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScopedModel<DataUser>(
                  model: userData,
                  child: MoreChannel(
                    listCategory: listCategory,
                    showSetting: showSetting,
                  ))),
        );
      },
      child: Container(
        height: 45,
        width: 45,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/sub_chanel/more_cat.svg',
                    height: 45,
                    width: 45,
                    color: Colors.blue[200],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
