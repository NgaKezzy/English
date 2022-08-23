import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/presentation/speak/widgets/bottom_modal_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:record/record.dart';

class ButtonItemRecord extends StatefulWidget {
  final Function changeStateRecorder;
  final Function setPath;
  final Function stopAuto;
  final Function stopTalking;
  final String titleContent;
  final String titleSub;
  const ButtonItemRecord({
    Key? key,
    required this.changeStateRecorder,
    required this.setPath,
    required this.stopAuto,
    required this.stopTalking, required this.titleContent, required this.titleSub,
  }) : super(key: key);

  @override
  State<ButtonItemRecord> createState() => _ButtonItemRecordState();
}

class _ButtonItemRecordState extends State<ButtonItemRecord> {
  Record recorder = Record();
  void showModal() async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      elevation: 10,
      context: context,
      builder: (context) => BottomModalRecord(
        pathSave: widget.setPath,
        changeStateRecoder: widget.changeStateRecorder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var dialogProvider = context.read<DialogProvider>();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () async {
      var checkPermission = await recorder.hasPermission();
      if (checkPermission) {
        dialogProvider.setClickItem(true);
        widget.stopAuto();
        widget.stopTalking();
        // showModal();
        dialogProvider.setWidgetRecorder(
          BottomModalRecord(
            pathSave: widget.setPath,
            changeStateRecoder: widget.changeStateRecorder,
          ),
        );
        dialogProvider.setTitleContentAndSub(widget.titleContent, widget.titleSub);
      }
        },
        child: Container(
                height: 45,
                width: 45,
                child: Card(
                  elevation: 10,
                  child: SvgPicture.asset(
                    'assets/new_ui/more/voice_11.svg',
                    height: 30,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fit: BoxFit.scaleDown,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
