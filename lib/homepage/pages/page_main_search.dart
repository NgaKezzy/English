import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/pages/page_search_result_widget.dart';
import 'package:app_learn_english/homepage/pages/page_search_widget.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/DataSearchResultModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class PageMainSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageMainSearch();
  }
}

class _PageMainSearch extends State<PageMainSearch> {
  var dataSearch = null;
  bool? status;
  var inputCache = "";
  Timer timeDelaySearch = Timer(Duration(seconds: 2), () {});
  @override
  void initState() {
    timeDelaySearch.cancel();
    inputSearchController.text = inputCache;
    inputSearchController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: inputSearchController.text.length,
      ),
    );
    super.initState();
  }

  final inputSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var localeProvider = Provider.of<LocaleProvider>(context);

    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return ScopedModelDescendant<DataUser>(
          builder: (context, child, userData) {
            return Scaffold(
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(24, 26, 33, 1)
                  : Colors.white,
              body: SafeArea(
                child: Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: themeProvider.mode == ThemeMode.dark
                            ? Color.fromRGBO(24, 26, 33, 1)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset(
                              'assets/new_ui/more/Iconly-Arrow-Left.svg',
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              // onChanged: (input) {
                              //   timeDelaySearch.cancel();
                              //   timeDelaySearch = Timer(Duration(seconds: 1), () {
                              //     TalkAPIs()
                              //         .fetchDataSearch(inputSearch: input)
                              //         .then((value) {
                              //       timeDelaySearch.cancel();
                              //       printYellow(value.toString());
                              //       if (value['status'] == 0) {
                              //         setState(() {
                              //           status = false;
                              //         });
                              //       } else {
                              //         var data = DataSearchModel.fromJson(value);
                              //         setState(() {
                              //           inputCache = input.toString();
                              //           dataSearch = data;
                              //           status = true;
                              //         });
                              //       }
                              //     });
                              //   });
                              // },
                              onFieldSubmitted: (input) {
                                TalkAPIs()
                                    .fetchDataSearch(
                                        inputSearch: input, languageCode: lang)
                                    .then((value) {
                                  timeDelaySearch.cancel();
                                  printYellow(value.toString());
                                  if (value['status'] == 0) {
                                    setState(() {
                                      status = false;
                                      dataSearch = null;
                                    });
                                  } else {
                                    var data = DataSearchModel.fromJson(value);
                                    setState(() {
                                      inputCache = input.toString();
                                      dataSearch = data;
                                      status = true;
                                    });
                                  }
                                });
                              },
                              controller: inputSearchController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                prefixIcon: Icon(Icons.search,
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black),
                                fillColor: Colors.grey.withOpacity(0.2),
                                filled: true,
                                hintText: S.of(context).Search,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: dataSearch == null && status == null
                          ? ScopedModel(model: userData, child: PageSearch())
                          : (DataCache().getSearchIndex() != null
                              ? (status == true
                                  ? Card(
                                      elevation: 5,
                                      child: PageSearchResult(
                                        dataSearchIndex:
                                            DataCache().getSearchIndex(),
                                        dataSearchModel: dataSearch,
                                      ),
                                    )
                                  : Center(
                                      child: Text(S.of(context).NotFound),
                                    ))
                              : FutureBuilder(
                                  future: TalkAPIs().fetchDataSearchIndex(
                                    userData: userData,
                                  ),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          S.of(context).Anerrordata,
                                        ),
                                      );
                                    }
                                    return snapshot.hasData
                                        ? PageSearchResult(
                                            dataSearchIndex: snapshot.data,
                                            dataSearchModel: dataSearch)
                                        : Center(
                                            // child: Platform.isAndroid
                                            //     ? const CircularProgressIndicator()
                                            //     : const CupertinoActivityIndicator(),
                                            child: const PhoLoading(),
                                          );
                                  },
                                )),
                    )
                  ],
                )),
              ),
            );
          },
        );
      },
    );
  }
}
