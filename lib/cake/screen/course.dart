import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/cake/widgets/item_course.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/cake_model.dart';
import 'package:app_learn_english/models/course_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Course extends StatefulWidget {
  const Course({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CakeItem item;

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  int index = 0;
  List<bool> onClicked = [true, true];
  bool _isLoading = true;
  List<CourseItem> courseChild = [];
  late bool _isLike;

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      courseChild = await TalkAPIs().getCourseChild(widget.item.id!);

      _isLike = await TalkAPIs()
          .checkLike(widget.item.id!, DataCache().getUserData().uid);
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${widget.item.name_vi}';
        break;
      case 'ru':
        title = '${widget.item.name_ru}';
        break;
      case 'es':
        title = '${widget.item.name_es}';
        break;
      case 'zh':
        title = '${widget.item.name_zh}';
        break;
      case 'ja':
        title = '${widget.item.name_ja}';
        break;
      case 'hi':
        title = '${widget.item.name_hi}';
        break;
      case 'tr':
        title = '${widget.item.name_tr}';
        break;
      case 'pt':
        title = '${widget.item.name_pt}';
        break;
      case 'id':
        title = '${widget.item.name_id}';
        break;
      case 'th':
        title = '${widget.item.name_th}';
        break;
      case 'ms':
        title = '${widget.item.name_ms}';
        break;
      case 'ar':
        title = '${widget.item.name_ar}';
        break;
      case 'fr':
        title = '${widget.item.name_fr}';
        break;
      case 'it':
        title = '${widget.item.name_it}';
        break;
      case 'de':
        title = '${widget.item.name_de}';
        break;
      case 'ko':
        title = '${widget.item.name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${widget.item.name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${widget.item.name_sk}';
        break;
      case 'sl':
        title = '${widget.item.name_sl}';
        break;
      default:
        title = '${widget.item.name}';
        break;
    }
    return title;
  }
  String desLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${widget.item.description_vi}';
        break;
      case 'ru':
        title = '${widget.item.description_ru}';
        break;
      case 'es':
        title = '${widget.item.description_es}';
        break;
      case 'zh':
        title = '${widget.item.description_zh}';
        break;
      case 'ja':
        title = '${widget.item.description_ja}';
        break;
      case 'hi':
        title = '${widget.item.description_hi}';
        break;
      case 'tr':
        title = '${widget.item.description_tr}';
        break;
      case 'pt':
        title = '${widget.item.description_pt}';
        break;
      case 'id':
        title = '${widget.item.description_id}';
        break;
      case 'th':
        title = '${widget.item.description_th}';
        break;
      case 'ms':
        title = '${widget.item.description_ms}';
        break;
      case 'ar':
        title = '${widget.item.description_ar}';
        break;
      case 'fr':
        title = '${widget.item.description_fr}';
        break;
      case 'it':
        title = '${widget.item.description_it}';
        break;
      case 'de':
        title = '${widget.item.description_de}';
        break;
      case 'ko':
        title = '${widget.item.description_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${widget.item.description_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${widget.item.description_sk}';
        break;
      case 'sl':
        title = '${widget.item.description_sl}';
        break;
      default:
        title = '${widget.item.description}';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
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
            actions: [
              if (!_isLoading)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isLike = !_isLike;
                      });
                    },
                    icon: _isLike
                        ? SvgPicture.asset(
                            'assets/new_ui/more/ic_heart.svg',
                            height: 25,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            size: 30,
                          ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  AppBar().preferredSize.height,
              child: Column(
                children: [
                  Divider(
                      thickness: 1,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.grey.shade700
                          : const Color(0xFFE4E4E4),
                      height: 1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titleLanguage(lang) == 'null'
                                    ? titleLanguage('en')
                                    : titleLanguage(lang),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 10,),

                              Container(
                                margin:
                                const EdgeInsets
                                    .only(
                                    right:
                                    8),
                                child: Text(
                                  desLanguage(lang) ==
                                      'null'
                                      ? desLanguage(
                                      'en')
                                      : desLanguage(
                                      lang),
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeProvider
                                        .mode ==
                                        ThemeMode
                                            .dark
                                        ? Colors
                                        .white
                                        : Colors
                                        .black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              (widget.item.picLink != null)
                                  ? widget.item.picLink!
                                  : 'https://admin.phoenglish.com/images/cat_avatars/${widget.item.picture}',
                              width: MediaQuery.of(context).size.width,
                              errorBuilder: (context, object, stackTrace) {
                                return Text('No image');
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  _isLoading
                      ? Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              // child: CircularProgressIndicator(),
                              child: const Center(child: PhoLoading()),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            color: const Color.fromRGBO(79, 178, 215, 1),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    S.of(context).Total +
                                        ' ${courseChild.length} ' +
                                        S.of(context).Lesson,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    children: [
                                      for (var item in courseChild)
                                        ItemCourseMyFeel(courseItem: item),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
