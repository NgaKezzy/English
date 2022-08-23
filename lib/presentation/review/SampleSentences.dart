import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/review/itemSentenceReview.dart';
import 'package:app_learn_english/presentation/review/modal/modal_accept_delete_sentence.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class SampleSentences extends StatefulWidget {
  bool isChange = false;

  SampleSentences({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SampleSentences();
  }
}

class _SampleSentences extends State<SampleSentences> {
  void update() {
    setState(() {
      widget.isChange = !widget.isChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return DataCache().getListTextReview() != null
          ? FutureBuilder(
              future: DataCache().getListTextReview(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(child: _buildLoadNoData()),
                  );
                }
                return snapshot.hasData
                    ? ScopedModel(
                        model: userData,
                        child: SampleSentencesWidget(
                          dataTextReview: snapshot.data,
                          func: update,
                        ))
                    : _buildLoadNoData();
              })
          : FutureBuilder(
              future: TalkAPIs().fetchReviewTextData(userData: userData),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(child: _buildLoadNoData()),
                  );
                }
                return snapshot.hasData
                    ? ScopedModel(
                        model: userData,
                        child: SampleSentencesWidget(
                          dataTextReview:
                              DataTextReview.fromJson(snapshot.data),
                          func: update,
                        ),
                      )
                    : _buildLoadNoData();
              });
    });
  }

  // Screens No data
  Widget _buildLoadNoData() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            // Image.asset(
            //   'assets/new_ui/more/poor.png',
            //   height: 90,
            // ),
            const PhoLoading(),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).Nostudydatayet,
              overflow: TextOverflow.visible,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

class SampleSentencesWidget extends StatefulWidget {
  DataTextReview dataTextReview;
  Function func;

  SampleSentencesWidget(
      {Key? key, required this.dataTextReview, required this.func})
      : super(key: key);

  @override
  State<SampleSentencesWidget> createState() => _SampleSentencesWidgetState();
}

class _SampleSentencesWidgetState extends State<SampleSentencesWidget> {
  bool accept = false;
  late List<TextReview> listTextReview;
  @override
  void initState() {
    listTextReview = widget.dataTextReview.textReview;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Scaffold(
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(24, 26, 33, 1)
            : const Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          title: Text(
            S.of(context).mySentencePattern,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                decoration: TextDecoration.none),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/new_ui/more/Iconly-Arrow-Left.svg',
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        body: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                Divider(
                    thickness: 1,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.grey.shade700
                        : const Color(0xFFE4E4E4),
                    height: 1),
                // HeaderApp(margin: 5),
                Expanded(
                  key: UniqueKey(),
                  child: listTextReview.length > 0
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => Slidable(
                            key: UniqueKey(),
                            child: ItemCentenceReview(
                              key: UniqueKey(),
                              textReview: listTextReview[index],
                              callReload: widget.func,
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () async {
                                  DataTextReview? lisTextReview =
                                      await showModalBottomSheet(
                                    context: context,
                                    builder: (contextAcceptModal) =>
                                        ModalAcceptDeleteSentence(
                                      key: UniqueKey(),
                                      textReview: widget
                                          .dataTextReview.textReview[index],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                    ),
                                  );
                                  if (lisTextReview != null) {
                                    setState(() {
                                      listTextReview = lisTextReview.textReview;
                                    });
                                  }
                                },
                                closeOnCancel: true,
                              ),

                              // All actions are defined in the children parameter.
                              children: const [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                          ),
                          itemCount: listTextReview.length,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              // Image.asset(
                              //   'assets/linh_vat/linhvat2.png',
                              //   height: 90,
                              // ),
                              const PhoLoading(),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                S.of(context).Nostudydatayet,
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            )),
      );
    });
  }
}
