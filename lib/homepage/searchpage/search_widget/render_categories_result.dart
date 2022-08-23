import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_channel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class RenderCategoryResult extends StatelessWidget {
  final Category category;
  RenderCategoryResult({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      var themeProvider = context.watch<ThemeProvider>();
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return Container(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: themeProvider.mode == ThemeMode.dark
                      ? Colors.black
                      : Colors.white,
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => {
                            Navigator.pop(context),
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            category.getNameByLanguage(
                                provider.locale!.languageCode),
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage('assets/images/background.png'),
                        //   fit: BoxFit.fill,
                        // ),
                        color:themeProvider.mode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          category.listChannel.length > 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? height / 1.1
                                          : height / 1.1,
                                  width: width,
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      for (var channel in category.listChannel)
                                        ScopedModel(
                                            model: userData,
                                            child: ItemChannelView(
                                              channel: channel,
                                              showSetting: () {},
                                            )),
                                    ],
                                  ),
                                )
                              : Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 200,),
                                    Lottie.asset(
                                      'assets/new_ui/animation_lottie/quiz_dung_1.json',
                                      height: 100,
                                    ),
                                    Text(
                                        S.of(context)
                                            .Therearenochannelsinthiscategory,
                                        style: TextStyle(
                                            fontSize: 20, color: themeProvider.mode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black)),
                                  ],
                                ),
                              )
                        ],
                      ),
                    )
                  ],
                )));
      });
    });
  }
}
