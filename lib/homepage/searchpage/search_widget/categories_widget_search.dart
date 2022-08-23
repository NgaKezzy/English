import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_categories_widget_search.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CategoriesSearch extends StatelessWidget {
  final List<Category> listCategory;
  CategoriesSearch({Key? key, required this.listCategory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
          height: 130,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
              color: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(59, 61, 66, 1)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).Channel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 70,
                width: width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var category in listCategory)
                      ItemCategorySearchWidget(category: category)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
