// import 'package:app_learn_english/presentation/profile/Login/LoginGoogle.dart';
// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:provider/provider.dart';
//
// class SendEmail extends StatefulWidget {
//   const SendEmail({Key? key}) : super(key: key);
//
//   @override
//   _SendEmailState createState() => _SendEmailState();
// }
//
// class _SendEmailState extends State<SendEmail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
//     Future sendEmail() async{
//       final userData = await  Provider.of<LoginGoogle>(context, listen: false)
//           .allowUserToLogin();
//       if(userData == null) return;
//
//       final auth = await userData.authentication;
//       final email = userData.email;
//       final  token = '';
//
//       final smtpServer = gmailSaslXoauth2(email, token);
//       final message = Message()
//         ..from = Address(email,'Turtle English')
//         ..recipients = ['syblue2408@gmail.com']
//         ..subject ='Turtle English'
//         ..text = 'báo cáo lỗi!';
//       try {
//         await send(message,smtpServer);
//         showSnackBar('Sent email succesfully!');
//       }on MailerException catch (e) {
//         print(e);
//       }
//     }
//
//     void showSnackBar(String text) {
//       final snackBar = SnackBar(content: Text(text,style: TextStyle(fontSize: 18),),
//         backgroundColor: Colors.green,
//       );
//
//       ScaffoldMessenger.of(context)
//         ..removeCurrentSnackBar()
//         ..showSnackBar(snackBar);
//   }
// }
