import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/pages/more_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemMoreSubView extends StatelessWidget {
  DataUser userData;
  List<Category> listCategory;
  final Function showSetting;

  ItemMoreSubView(
      {Key? key,
      required this.userData,
      required this.listCategory,
      required this.showSetting});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScaleTap(
      onPressed: () {
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
      child: Column(
        children: [
          Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(70))),
              child: Center(
                child: SvgPicture.asset(
                  'assets/new_ui/more/btn_taophong.svg',
                  height: 30,
                  width: 30,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 75,
            child: Text(
              S.of(context).Subscribe,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color.fromRGBO(128, 128, 128, 1),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
