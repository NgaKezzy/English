// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class AddSubScreen extends StatefulWidget {
//   // final DataTalk dataTalk;
//   AddSubScreen({
//     Key? key,
//     // required this.dataTalk,
//   }) : super(key: key);

//   @override
//   _AddSubScreenState createState() => _AddSubScreenState();
// }

// class _AddSubScreenState extends State<AddSubScreen> {
//   int numIndex = 0;
//   int numIndexVi = 0;
//   int numIndexJp = 0;
//   int numIndexRu = 0;

//   late YoutubePlayerController _controller;
//   String locationContent = 'en';

//   Widget buildClearBtn(int index, List<TextEditingController> controllers) {
//     return Column(
//       key: ValueKey(index),
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: 80,
//               height: 40,
//               child: TextField(
//                 controller: controllers[0],
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                       width: 1.0,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                       width: 1.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: SizedBox(
//                 height: 40,
//                 child: TextField(
//                   controller: controllers[1],
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(
//                         color: Colors.green,
//                         width: 1.0,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(
//                         color: Colors.green,
//                         width: 1.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   if (locationContent == 'vi' &&
//                       listSubWidgetVi.length - 1 == index) {
//                     listSubWidgetVi.removeAt(index);
//                     listSubControllerVi.removeAt(index);
//                     numIndexVi--;
//                   } else if (locationContent == 'ja' &&
//                       listSubWidgetJp.length - 1 == index) {
//                     listSubWidgetJp.removeAt(index);
//                     listSubControllerJp.removeAt(index);

//                     numIndexJp--;
//                   } else if (locationContent == 'ru' &&
//                       listSubWidgetRu.length - 1 == index) {
//                     listSubWidgetRu.removeAt(index);
//                     listSubControllerRu.removeAt(index);

//                     numIndexRu--;
//                   } else if (locationContent == 'en' &&
//                       listSubWidget.length - 1 == index) {
//                     listSubWidget.removeAt(index);
//                     listSubController.removeAt(index);
//                     numIndex--;
//                   } else {
//                     toast(
//                       'Xoá subtitile ở vị trí cuối cùng',
//                       context: context,
//                     );
//                   }
//                 });
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 elevation: 5,
//                 color: Colors.redAccent,
//                 child: Padding(
//                   padding: EdgeInsets.all(5),
//                   child: Icon(
//                     Icons.clear,
//                     color: Colors.white,
//                     size: 25,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }

//   List<Widget> listSubWidget = [];
//   List<Widget> listSubWidgetVi = [];
//   List<Widget> listSubWidgetJp = [];
//   List<Widget> listSubWidgetRu = [];

//   List<List<TextEditingController>> listSubControllerVi = [];
//   List<List<TextEditingController>> listSubControllerJp = [];
//   List<List<TextEditingController>> listSubControllerRu = [];
//   List<List<TextEditingController>> listSubController = [];
//   TextEditingController timeEdingController = TextEditingController();

//   bool _isPlayerReady = false;

//   @override
//   void initState() {
//     listSubController.add([TextEditingController(), TextEditingController()]);
//     listSubWidget.add(buildClearBtn(numIndex, listSubController[numIndex]));
//     numIndex++;
//     _controller = YoutubePlayerController(
//       initialVideoId: 'IpFJPQDmEHY',
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//       ),
//     )..addListener(() {
//         if (_isPlayerReady) {
//           setState(() {
//             timeEdingController.text =
//                 _controller.value.position.inMilliseconds.toString();
//           });
//         }
//       });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _controller,
//         onReady: () {
//           _isPlayerReady = true;
//         },
//       ),
//       builder: (context, player) => Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new_outlined,
//             ),
//           ),
//           title: Text('Tên video cần sub'),
//         ),
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           color: Colors.grey[200],
//           child: Column(
//             children: [
//               player,
//               Expanded(
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.white,
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Thời gian hiện tại: ',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 140,
//                                       child: TextField(
//                                         controller: timeEdingController,
//                                         decoration: InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(
//                                             horizontal: 15,
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.white,
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             borderSide: BorderSide(
//                                               color: Colors.green,
//                                               width: 1.0,
//                                             ),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             borderSide: BorderSide(
//                                               color: Colors.green,
//                                               width: 1.0,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue[600],
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                         child: IconButton(
//                                           onPressed: () async {
//                                             await FlutterClipboard.copy(
//                                               timeEdingController.text,
//                                             );
//                                           },
//                                           icon: Icon(
//                                             Icons.content_copy_outlined,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         'Edit Subtitles',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     DropdownButton<String>(
//                                       borderRadius: BorderRadius.circular(10),
//                                       value: locationContent,
//                                       icon: const Icon(
//                                         Icons.arrow_drop_down_outlined,
//                                       ),
//                                       elevation: 16,
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           if (listSubWidgetVi.length == 0 &&
//                                               newValue == 'vi') {
//                                             listSubControllerVi.add([
//                                               TextEditingController(),
//                                               TextEditingController()
//                                             ]);
//                                             listSubWidgetVi.add(
//                                               buildClearBtn(
//                                                 numIndexVi,
//                                                 listSubControllerVi[numIndexVi],
//                                               ),
//                                             );
//                                             numIndexVi++;
//                                           } else if (listSubWidgetJp.length ==
//                                                   0 &&
//                                               newValue == 'ja') {
//                                             listSubControllerJp.add([
//                                               TextEditingController(),
//                                               TextEditingController()
//                                             ]);
//                                             listSubWidgetJp.add(
//                                               buildClearBtn(
//                                                 numIndexJp,
//                                                 listSubControllerJp[numIndexJp],
//                                               ),
//                                             );
//                                             numIndexJp++;
//                                           } else if (listSubWidgetRu.length ==
//                                                   0 &&
//                                               newValue == 'ru') {
//                                             listSubControllerRu.add([
//                                               TextEditingController(),
//                                               TextEditingController()
//                                             ]);
//                                             listSubWidgetRu.add(
//                                               buildClearBtn(
//                                                 numIndexRu,
//                                                 listSubControllerRu[numIndexRu],
//                                               ),
//                                             );
//                                             numIndexRu++;
//                                           }

//                                           locationContent = newValue!;
//                                         });
//                                       },
//                                       items: <String>['vi', 'en', 'ja', 'ru']
//                                           .map<DropdownMenuItem<String>>(
//                                               (String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               value,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 80,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           'Thời gian',
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Expanded(
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           'Subtitle',
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 if (locationContent == 'en')
//                                   Column(
//                                     children: [...listSubWidget],
//                                   )
//                                 else if (locationContent == 'vi')
//                                   Column(
//                                     children: [...listSubWidgetVi],
//                                   )
//                                 else if (locationContent == 'ru')
//                                   Column(
//                                     children: [...listSubWidgetRu],
//                                   )
//                                 else
//                                   Column(
//                                     children: [...listSubWidgetJp],
//                                   ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       if (locationContent == 'en' &&
//                                           listSubController[
//                                                   listSubController.length -
//                                                       1][0]
//                                               .text
//                                               .isNotEmpty &&
//                                           listSubController[
//                                                   listSubController.length -
//                                                       1][1]
//                                               .text
//                                               .isNotEmpty) {
//                                         listSubController.add([
//                                           TextEditingController(),
//                                           TextEditingController()
//                                         ]);
//                                         listSubWidget.add(
//                                           buildClearBtn(
//                                             numIndex,
//                                             listSubController[numIndex],
//                                           ),
//                                         );
//                                         numIndex++;
//                                       } else if (locationContent == 'vi' &&
//                                           listSubControllerVi[
//                                                   listSubControllerVi.length -
//                                                       1][0]
//                                               .text
//                                               .isNotEmpty &&
//                                           listSubControllerVi[
//                                                   listSubControllerVi.length -
//                                                       1][1]
//                                               .text
//                                               .isNotEmpty) {
//                                         listSubControllerVi.add([
//                                           TextEditingController(),
//                                           TextEditingController()
//                                         ]);
//                                         listSubWidgetVi.add(
//                                           buildClearBtn(
//                                             numIndexVi,
//                                             listSubControllerVi[numIndexVi],
//                                           ),
//                                         );
//                                         numIndexVi++;
//                                       } else if (locationContent == 'ja' &&
//                                           listSubControllerJp[
//                                                   listSubControllerJp.length -
//                                                       1][0]
//                                               .text
//                                               .isNotEmpty &&
//                                           listSubControllerJp[
//                                                   listSubControllerJp.length -
//                                                       1][1]
//                                               .text
//                                               .isNotEmpty) {
//                                         listSubControllerJp.add([
//                                           TextEditingController(),
//                                           TextEditingController()
//                                         ]);
//                                         listSubWidgetJp.add(
//                                           buildClearBtn(
//                                             numIndexJp,
//                                             listSubControllerJp[numIndexJp],
//                                           ),
//                                         );
//                                         numIndexJp++;
//                                       } else if (locationContent == 'ru' &&
//                                           listSubControllerRu[
//                                                   listSubControllerRu.length -
//                                                       1][0]
//                                               .text
//                                               .isNotEmpty &&
//                                           listSubControllerRu[
//                                                   listSubControllerRu.length -
//                                                       1][1]
//                                               .text
//                                               .isNotEmpty) {
//                                         listSubControllerRu.add([
//                                           TextEditingController(),
//                                           TextEditingController()
//                                         ]);
//                                         listSubWidgetRu.add(
//                                           buildClearBtn(
//                                             numIndexRu,
//                                             listSubControllerRu[numIndexRu],
//                                           ),
//                                         );
//                                         numIndexRu++;
//                                       } else {
//                                         toast(
//                                           'Trước khi thêm subtitile mới, bạn cần phải thêm đủ thông tin đoạn subtitile trước đó',
//                                         );
//                                       }
//                                     });
//                                   },
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: Card(
//                                       elevation: 0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(50),
//                                       ),
//                                       color: Colors.blue,
//                                       child: Padding(
//                                         padding: EdgeInsets.all(5),
//                                         child: Icon(
//                                           Icons.add,
//                                           size: 25,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.blueAccent.withOpacity(0.8),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             'Upload Subtitle',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
