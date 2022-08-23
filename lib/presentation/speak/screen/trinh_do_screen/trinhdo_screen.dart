import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/utils/course_utils.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../widgets/loading_circle.dart';
import '../../provider/all_list_talk_course.dart';
import '../../screen/detail_course_speak_screen.dart';

class TrinhDoScreen extends StatefulWidget {
  final bool isLoadingCourse;
  final List<dynamic> listCourse;

  const TrinhDoScreen({
    Key? key,
    required this.isLoadingCourse,
    required this.listCourse,
  }) : super(key: key);

  @override
  State<TrinhDoScreen> createState() => _TrinhDoScreenState();
}

class _TrinhDoScreenState extends State<TrinhDoScreen> {
  ScrollController _controller = ScrollController();
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<AllListTalkCourse>(context, listen: true)
        .getAllTalkByCategory(context, 1);
    Provider.of<AllListTalkCourse>(context).listCourseTalks();
  }

  int page = 2;
  bool _isLoad = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print('Có vào đây nhé nhé');
      print(_controller.position.pixels.toString() + 'position');
      print(_controller.position.maxScrollExtent.toString() + 'max');
      if (_isLoad) {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 100) {
          print('Có vào đây nhé');
          setState(() {
            _isLoad = false;
          });
          context
              .read<AllListTalkCourse>()
              .getAllTalkByCategory(context, page)
              .then((value) {
            print('Có vào đây');
            setState(() {
              _isLoad = true;
              page++;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var data = ScopedModel.of<DataUser>(context);
    String checkLanguge(String name) {
      switch (name) {
        case "Nhập môn":
          return S.of(context).Introduction;

        case "Sơ cấp":
          return S.of(context).Primary;

        case "Trung cấp":
          return S.of(context).Intermediate;

        case "Cao cấp":
          return S.of(context).HighClass;

        default:
          return '';
      }
    }

    List<Widget> addItemColumn() {
      var localProvider = context.watch<LocaleProvider>();
      final List<Widget> listCourseWidgetSpeak = [];
      for (var i = 0; i < widget.listCourse.length; i++) {
        listCourseWidgetSpeak.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Provider.of<VideoProvider>(context, listen: false)
                      .setdataTalk(null);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return DetailCourseSpeakScreen(
                          idCourse: widget.listCourse[i].id,
                          dataUser: data,
                          imageUrl: widget.listCourse[i].picLink,
                        );
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    Card(
                      color: themeProvider.mode == ThemeMode.dark
                          ? const Color.fromRGBO(24, 26, 33, 1)
                          : Colors.white,
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Hero(
                                      tag: ValueKey(
                                          widget.listCourse[i].picLink),
                                      child: FadeInImage.memoryNetwork(
                                        width: 85,
                                        height: 88,
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                        image: (widget.listCourse[i].picLink300
                                                .toString()
                                                .isNotEmpty)
                                            ? widget.listCourse[i].picLink300
                                            : widget.listCourse[i].picLink,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 90,
                                margin: const EdgeInsets.only(left: 20, top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: Text(
                                        Utils.changeLanguageLuyenDoc(
                                            localProvider.locale!.languageCode,
                                            widget.listCourse[i]),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${checkLanguge(UtilsCourse.convertLevelToString(widget.listCourse[i].start))} - ${widget.listCourse[i].listTalk.length} ${S.of(context).Lesson}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 9,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return listCourseWidgetSpeak;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '${S.of(context).Course} (${widget.listCourse.length})',
                style: TextStyle(
                  fontSize: 20,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              child: !widget.isLoadingCourse
                  ? ((widget.listCourse.length == 0
                      ? const Center(
                          child: Text('No Course Available'),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshProducts(context),
                          child: Container(
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              controller: _controller,
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 0,
                              ),
                              children: [...addItemColumn()],
                            ),
                          ),
                        )))
                  : const Center(child: PhoLoading()),
            ),
          ),
        ],
      ),
    );
  }
}
