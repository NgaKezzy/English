import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/render_categories_result.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCategorySearchResult extends StatefulWidget {
  final Category category;
  final List<Category> categoryIndex;
  const ItemCategorySearchResult(
      {Key? key, required this.category, required this.categoryIndex})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemCategorySearchResult(
        category: category, categoryIndex: categoryIndex);
  }
}

class _ItemCategorySearchResult extends State<ItemCategorySearchResult> {
  Category category;
  List<Category> categoryIndex;
  _ItemCategorySearchResult(
      {Key? key, required this.category, required this.categoryIndex});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    var checklist = category;
    for (var i = 0; i < categoryIndex.length; i++) {
      if (category.name == categoryIndex[i].name) checklist = categoryIndex[i];
    }
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return Container(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ScopedModel(
                            model: userData,
                            child: RenderCategoryResult(category: checklist));
                      },
                    ),
                  );
                },
                child: Text(
                  category.getNameByLanguage(provider.locale!.languageCode) +
                      '(' +
                      category.totalTalk.toString() +
                      ')',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: ResponsiveWidget.isSmallScreen(context)
                        ? width / 18
                        : width / 45,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
    });
  }
}
