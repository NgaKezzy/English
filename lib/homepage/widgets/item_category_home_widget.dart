import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/homepage/widgets/item_talk_widget.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCategoryHomeWidget extends StatefulWidget {
  final Category category;
  const ItemCategoryHomeWidget({Key? key, required this.category})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemCategoryHome(category: category);
  }
}

class _ItemCategoryHome extends State<ItemCategoryHomeWidget> {
  Category category;
  _ItemCategoryHome({Key? key, required this.category});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(
      builder: (context, child, userData) {
        return Consumer<LocaleProvider>(
          builder: (context, provider, snapshot) {
            return Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: themeProvider.mode == ThemeMode.dark
                    ? const Color.fromRGBO(42, 44, 50, 1)
                    : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      category.getNameByLanguage(
                                  provider.locale!.languageCode) ==
                              'null'
                          ? category.name
                          : category
                              .getNameByLanguage(provider.locale!.languageCode),
                      maxLines: 2,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return ScopedModel(
                                    model: userData,
                                    child: ChannelDetail(
                                      category: category,
                                      showSetting: () {},
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(
                                'assets/new_ui/first_screen_app/ic_arrow.svg',
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(42, 44, 50, 1)
                              : Colors.white,
                          margin: const EdgeInsets.only(left: 8),
                          height: (MediaQuery.of(context).size.width / 0.9375) *
                              0.82,
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  MediaQuery.of(context).size.height / 0.1,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: category.listTalk.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext ctx, index) {
                              return ItemTalkWidget(
                                talkData: category.listTalk[index],
                                type: category.type,
                                userData: userData,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
