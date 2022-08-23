// import 'package:app_learn_english/Providers/theme_provider.dart';
// import 'package:app_learn_english/generated/l10n.dart';
// import 'package:app_learn_english/presentation/profile/widgets/text_field_icon.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/src/provider.dart';

// class Lecturers extends StatefulWidget {
//   const Lecturers({Key? key}) : super(key: key);

//   @override
//   State<Lecturers> createState() => _LecturersState();
// }

// class _LecturersState extends State<Lecturers> {
//   String _value = 'Male';

//   Widget ShowControl() {
//     return AlertDialog(
//       title: Text("Upload photos with ?"),
//       actions: [
//         FlatButton(
//           onPressed: () {},
//           child: Text('a'),
//         ),
//         FlatButton(
//           onPressed: () {},
//           child: Text('a'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var themeProvider = context.watch<ThemeProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: themeProvider.mode == ThemeMode.dark
//             ? Color.fromRGBO(45, 48, 57, 1)
//             : Colors.white,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: SvgPicture.asset(
//             'assets/new_ui/more/Iconly-Arrow-Left.svg',
//             color: themeProvider.mode == ThemeMode.dark
//                 ? Colors.white
//                 : Colors.black,
//           ),
//         ),
//         leadingWidth: 50,
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 child: Text(
//                   "Đăng ký giảng viên Pho English",
//                   style: TextStyle(
//                     color: themeProvider.mode == ThemeMode.dark
//                         ? Colors.white
//                         : Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(children: [
//         Divider(
//             thickness: 1,
//             color: themeProvider.mode == ThemeMode.dark
//                 ? Colors.grey.shade700
//                 : Color(0xFFE4E4E4),
//             height: 1),
//         Expanded(
//           child: Scaffold(
//             backgroundColor: themeProvider.mode == ThemeMode.dark
//                 ? const Color.fromRGBO(24, 26, 33, 1)
//                 : const Color.fromRGBO(255, 255, 255, 1),
//             body: Container(
//               padding: const EdgeInsets.only(
//                   top: 20, bottom: 0, left: 15, right: 15),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 200,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: themeProvider.mode == ThemeMode.dark
//                                   ? Colors.grey.shade800
//                                   : Colors.white),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: "Surname *",
//                               hintStyle: TextStyle(
//                                   color: themeProvider.mode == ThemeMode.dark
//                                       ? Colors.white
//                                       : Colors.grey.shade700),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: themeProvider.mode == ThemeMode.dark
//                                     ? Colors.grey.shade800
//                                     : Colors.white),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Name *',
//                                 hintStyle: TextStyle(
//                                     color: themeProvider.mode == ThemeMode.dark
//                                         ? Colors.white
//                                         : Colors.grey.shade700),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       height: 50,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: themeProvider.mode == ThemeMode.dark
//                               ? Colors.grey.shade800
//                               : Colors.white),
//                       child: TextField(
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Email *',
//                           hintStyle: TextStyle(
//                               color: themeProvider.mode == ThemeMode.dark
//                                   ? Colors.white
//                                   : Colors.grey.shade700),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       height: 50,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: themeProvider.mode == ThemeMode.dark
//                               ? Colors.grey.shade800
//                               : Colors.white),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Phone *',
//                           hintStyle: TextStyle(
//                               color: themeProvider.mode == ThemeMode.dark
//                                   ? Colors.white
//                                   : Colors.grey.shade700),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Radio(
//                             value: 'Male',
//                             groupValue: _value,
//                             onChanged: (value) {
//                               setState(() {
//                                 _value = value = 'Male';
//                               });
//                             }),
//                         Text(
//                           "Male",
//                           style: TextStyle(
//                               color: themeProvider.mode == ThemeMode.dark
//                                   ? Colors.white
//                                   : Colors.grey.shade700),
//                         ),
//                         const SizedBox(width: 20),
//                         Radio(
//                             value: 'Female',
//                             groupValue: _value,
//                             onChanged: (value) {
//                               setState(() {
//                                 _value = value = 'Female';
//                               });
//                             }),
//                         Text(
//                           "Female",
//                           style: TextStyle(
//                               color: themeProvider.mode == ThemeMode.dark
//                                   ? Colors.white
//                                   : Colors.grey.shade700),
//                         ),
//                       ],
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() => ShowControl());
//                       },
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           side: BorderSide(
//                               color: Colors.grey.shade500, width: 1)),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 50,
//                         // padding: EdgeInsets.all(10),
//                         // decoration: BoxDecoration(
//                         //   color: themeProvider.mode == ThemeMode.dark
//                         //       ? Colors.grey.shade800
//                         //       : Colors.white,
//                         //   borderRadius: BorderRadius.circular(5),
//                         //   border: Border.all(color: Colors.grey.shade500),
//                         // ),
//                         child: Row(
//                           children: [
//                             SvgPicture.asset(
//                                 'assets/new_ui/more/Iconly-Light-Image.svg'),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Upload your certificate",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     color: themeProvider.mode == ThemeMode.dark
//                                         ? Colors.grey.shade700
//                                         : Colors.grey.shade700),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: themeProvider.mode == ThemeMode.dark
//                                     ? Colors.grey.shade800
//                                     : Colors.white),
//                             child: TextField(
//                               maxLength: 100,
//                               maxLines: 5,
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Introduce yourself 0/100 *',
//                                 hintStyle: TextStyle(
//                                     color: themeProvider.mode == ThemeMode.dark
//                                         ? Colors.white
//                                         : Colors.grey.shade700),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 45,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
