import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class DetailSeeMore extends StatefulWidget {
  final String? name;
  final String? description;
  const DetailSeeMore({
    Key? key,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<DetailSeeMore> createState() => _DetailSeeMoreState();
}

class _DetailSeeMoreState extends State<DetailSeeMore> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Colors.grey.withOpacity(.2),
        )),
        color: Colors.grey.withOpacity(0.0),
      ),
      child: Column(
        children: <Widget>[
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: ConstrainedBox(
              constraints: isExpanded
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 30.0),
              child: Text(
                (widget.description == null || widget.description == '')
                    ? 'Khóa học lovepho'
                    : widget.description!,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          (widget.description == null || widget.description == '')
              ? Container()
              : SizedBox(
                  height: 20,
                ),
          (widget.description == null || widget.description == '')
              ? Container()
              : (isExpanded
                  ? Align(
                      child: InkWell(
                        onTap: () => setState(() {
                          isExpanded = false;
                        }),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            S.of(context).HideAway,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Color.fromRGBO(24, 26, 33, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    )
                  : Align(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = true;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            S.of(context).SeeMore,
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Color.fromRGBO(24, 26, 33, 1),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            color: Colors.grey.withOpacity(0.0),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    )),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
