// import 'package:app_learn_english/models/data_video_youtube.dart';
// import 'package:app_learn_english/screens/add_sub_screen.dart';
// import 'package:flutter/material.dart';

// class CreateVideo extends StatefulWidget {
//   final DataVideoYoutube dataVideo;
//   const CreateVideo({Key? key, required this.dataVideo}) : super(key: key);

//   @override
//   _CreateVideoState createState() => _CreateVideoState();
// }

// class _CreateVideoState extends State<CreateVideo> {
//   List<String> categoryCode = [
//     'Trang chủ',
//     'Khóa học',
//     'Luyện đọc',
//     'Ôn tập',
//   ];
//   String category = 'Trang chủ';
//   TextEditingController titleController = TextEditingController();
//   TextEditingController linkController = TextEditingController();

//   @override
//   void initState() {
//     linkController.text = widget.dataVideo.linkOrigin;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.blue.shade700,
//                 Colors.tealAccent.shade400,
//               ],
//             ),
//           ),
//           child: Container(
//             padding: EdgeInsets.fromLTRB(12, 42, 12, 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.blueAccent,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Icon(
//                           Icons.navigate_before,
//                           size: 28,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.3,
//                       margin: EdgeInsets.only(top: 20),
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Tiêu đề',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                             ),
//                           ),
//                           Text(
//                             'Link',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                             ),
//                           ),
//                           Text(
//                             'Danh mục',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         margin: EdgeInsets.only(top: 20),
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextFormField(
//                               controller: titleController,
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.white38.withOpacity(0.6),
//                                 hintText: 'Nhập tiêu đề của video',
//                                 hintStyle: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       BorderSide(width: 1, color: Colors.white),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     width: 1,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TextFormField(
//                               enabled: false,
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                               controller: linkController,
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.grey.withOpacity(0.6),
//                                 hintText: 'Nhập link của video',
//                                 hintStyle: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       BorderSide(width: 1, color: Colors.white),
//                                 ),
//                                 disabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     width: 1,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       BorderSide(width: 1, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: 56,
//                               width: MediaQuery.of(context).size.width,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(width: 1, color: Colors.white),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: DropdownButton(
//                                 dropdownColor: Colors.blue,
//                                 iconEnabledColor: Colors.white,
//                                 value: category,
//                                 items: categoryCode
//                                     .map<DropdownMenuItem<String>>(
//                                         (String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 }).toList(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     category = newValue!;
//                                   });
//                                 },
//                                 underline: Container(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   child: ElevatedButton(
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Hoàn thành',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddSubScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
