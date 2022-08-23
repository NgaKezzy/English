import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/item_categories_search_result.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:provider/src/provider.dart';

class CategoriesSearchRedult extends StatefulWidget {
  final List<Category> listCategory;
  final List<Category> listCategoryIndex;
  CategoriesSearchRedult(
      {Key? key, required this.listCategory, required this.listCategoryIndex})
      : super(key: key);

  @override
  _CategoriesSearchRedult createState() => _CategoriesSearchRedult(
      listCategory: listCategory, listCategoryIndex: listCategoryIndex);
}

class _CategoriesSearchRedult extends State<CategoriesSearchRedult> {
  final List<Category> listCategory;
  final List<Category> listCategoryIndex;
  _CategoriesSearchRedult(
      {Key? key, required this.listCategory, required this.listCategoryIndex});
  var sizeList = 3;
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 5,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
          width: width,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(58, 60, 66, 1)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    Text(
                      S.of(context).Categories,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: ResponsiveWidget.isSmallScreen(context)
                            ? width / 18
                            : width / 45,
                      ),
                    ),
                    Text(
                      '(' + listCategory.length.toString() + ')',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: ResponsiveWidget.isSmallScreen(context)
                            ? width / 18
                            : width / 45,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                height: ResponsiveWidget.isSmallScreen(context)
                    ? height / 5
                    : height / 2,
                width: width,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var i = 0;
                        i <
                            (listCategory.length > 3
                                ? sizeList
                                : listCategory.length);
                        i++)
                      ItemCategorySearchResult(
                        category: listCategory[i],
                        categoryIndex: listCategoryIndex,
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              sizeList == 3 && listCategory.length > 3
                  ? MaterialButton(
                      onPressed: () => {
                        setState(() {
                          sizeList = listCategory.length;
                        })
                      },
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            S.of(context).SeeMore + ' ',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '(' + (listCategory.length - 3).toString() + ')',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}
