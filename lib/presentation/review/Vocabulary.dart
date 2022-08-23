import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/NewWord.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';

import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/presentation/review/itemVocabulary.dart';

import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VocabularyScreen();
  }
}

class _VocabularyScreen extends State<VocabularyScreen> {
  late DataTextReview dataTextReview;
  List<DataNewWord> listVocab = [];
  bool checkLoading = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (checkLoading) {
      listVocab = await DataCache().getDataVocab();
    }
    setState(() {
      checkLoading = false;
    });
  }

  List<Widget> renderItemVocab() {
    List<Widget> items = [];
    listVocab.forEach((data) {
      data.listNewWord.forEach((element) {
        items.add(ItemVocabulary(
          newWords: element,
        ));
      });
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      height: height / 1.1,
      width: width / 1.1,
      child: Card(
        elevation: 3,
        child: Container(
          height: height / 1.3,
          padding: EdgeInsets.all(16),
          width: width / 1.1,
          child: checkLoading
              ? PhoLoading()
              : (listVocab.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Image.asset(
                        //   'assets/new_ui/more/poor.png',
                        //   height: 90,
                        // ),
                        const PhoLoading(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          S.of(context).Nostudydatayet,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [...renderItemVocab()],
                      //
                    )),
        ),
      ),
    );
  }
}
