// import 'package:app_learn_english/homepage/widgets/create_video.dart';
// import 'package:app_learn_english/models/data_video_youtube.dart';
// import 'package:app_learn_english/networks/TalkAPIs.dart';
// import 'package:flutter/material.dart';

// class SearchVideo extends StatefulWidget {
//   const SearchVideo({Key? key}) : super(key: key);

//   @override
//   _SearchVideoState createState() => _SearchVideoState();
// }

// class _SearchVideoState extends State<SearchVideo> {
//   List<DataVideoYoutube>? listVideoSearch = [];

//   submitSearch(String keyword) async {
//     TalkAPIs().search(keyword).then((value) => setState(() {
//           listVideoSearch = value;
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.blue.shade700,
//                   Colors.tealAccent.shade400,
//                 ],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 70,
//                         margin: EdgeInsets.only(
//                           top: MediaQuery.of(context).padding.top + 10,
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30),
//                           child: TextField(
//                             textInputAction: TextInputAction.search,
//                             onSubmitted: submitSearch,
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: BorderSide(
//                                   color: Colors.green,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: BorderSide(
//                                   color: Colors.green,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               prefixIcon: Icon(
//                                 Icons.search,
//                                 color: Colors.black,
//                               ),
//                               hintText: "Tìm Kiếm video",
//                               hintStyle: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           child: ListView.builder(
//                             itemBuilder: (ctx, index) => InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CreateVideo(
//                                       dataVideo: listVideoSearch![index],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     color: index % 2 == 0
//                                         ? Colors.grey.withOpacity(0.3)
//                                         : Colors.white.withOpacity(0.1),
//                                     width: MediaQuery.of(context).size.width,
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 20),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           child: Image.network(
//                                             listVideoSearch![index].thumb,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(top: 10),
//                                             child: Text(
//                                               listVideoSearch![index].title,
//                                               textAlign: TextAlign.left,
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             itemCount: listVideoSearch!.length,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
