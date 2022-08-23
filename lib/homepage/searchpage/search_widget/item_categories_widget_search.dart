import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/render_categories_result.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCategorySearchWidget extends StatefulWidget {
  final Category category;
  const ItemCategorySearchWidget({Key? key, required this.category})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemCategorySearchWidget(category: category);
  }
}

class _ItemCategorySearchWidget extends State<ItemCategorySearchWidget> {
  Category category;
  _ItemCategorySearchWidget({Key? key, required this.category});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(
      builder: (context, child, userData) {
        return Consumer<LocaleProvider>(
          builder: (context, provider, snapshot) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ChannelDetail(
                          category: category,
                          showSetting: () {},
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      category.getNameByLanguage(provider.locale!.languageCode),
                      maxLines: 1,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
