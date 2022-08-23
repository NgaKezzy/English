import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/detail_course_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/utils/course_utils.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../provider/all_list_talk_course.dart';

import 'package:transparent_image/transparent_image.dart';

class ChuyenMucScreen extends StatefulWidget {
  final bool isLoadingCourse;
  final List<dynamic> listCourse;
  final bool check;

  ChuyenMucScreen({
    Key? key,
    required this.isLoadingCourse,
    required this.listCourse,
    required this.check,
  }) : super(key: key);

  @override
  State<ChuyenMucScreen> createState() => _ChuyenMucScreenState();
}

class _ChuyenMucScreenState extends State<ChuyenMucScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<AllListTalkCourse>(context, listen: true)
        .getAllTalkByCategory(context, 1);
  }

  ScrollController _controller = ScrollController();

  int page = 2;
  bool _isLoad = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print(_controller.position.pixels.toString() + 'position');
      print(_controller.position.maxScrollExtent.toString() + 'max');
      if (_isLoad) {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 100) {
          setState(() {
            _isLoad = false;
          });
          context
              .read<AllListTalkCourse>()
              .getAllTalkByCategory(context, page)
              .then((value) {
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

    return widget.isLoadingCourse
        ? const PhoLoading()
        : RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      child: widget.listCourse.length == 0
                          ? Center(
                              child: Text(S.of(context).NoCourseAvailable),
                            )
                          : ListView.separated(
                              controller: _controller,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, int) => const Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Provider.of<VideoProvider>(context,
                                            listen: false)
                                        .setdataTalk(null);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return DetailCourseSpeakScreen(
                                            idCourse: widget.check
                                                ? widget.listCourse[index].id
                                                : int.parse(
                                                    '${widget.listCourse[index]['id']}'),
                                            dataUser: data,
                                            imageUrl: widget
                                                .listCourse[index].picLink,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Stack(
                                                children: <Widget>[
                                                  const Center(
                                                    // child: Platform.isAndroid
                                                    //     ? const CircularProgressIndicator()
                                                    //     : const CupertinoActivityIndicator(),
                                                    child: PhoLoading(),
                                                  ),
                                                  Center(
                                                      child: FadeInImage
                                                          .memoryNetwork(
                                                    width: 85,
                                                    height: 88,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: widget.check
                                                        ? widget
                                                            .listCourse[index]
                                                            .picLink
                                                        : Session()
                                                                .BASE_IMAGES +
                                                            'images/cat_avatars/${widget.listCourse[index]["picture"]}',
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 90,
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.8,
                                                      child: Text(
                                                        widget.check
                                                            ? widget
                                                                .listCourse[
                                                                    index]
                                                                .name
                                                            : widget.listCourse[
                                                                index]['name'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '${checkLanguge(UtilsCourse.convertLevelToString(int.parse(widget.check ? '${widget.listCourse[index].start}' : '${widget.listCourse[index]["start"]}')))} - ${widget.check ? '${widget.listCourse[index].listTalk.length}' : widget.listCourse[index]["listTalk"].length} ${S.of(context).Lesson}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: widget.listCourse.length,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
