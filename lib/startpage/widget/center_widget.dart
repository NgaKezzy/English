import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class CenterWidget extends StatelessWidget {
  final String title;
  final int index;

  const CenterWidget({
    Key? key,
    required this.title, required this.index,
  });

 String getImageCenter(int index){
   String image='';
   switch(index){
     case 1:
       image = 'assets/new_ui/first_screen_app/first_list_language.png';
       break;
     case 2:
       image = 'assets/new_ui/first_screen_app/list_learn.png';
       break;
     case 3:
       image ='assets/new_ui/first_screen_app/list_muc_tieu.png';
       break;
     default:
   }
   return image;
 }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.only(bottom: 8, right: 10),
      alignment: Alignment.topCenter,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getImageCenter(index)),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 20,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),

          ],
        // ),
      ),
    ));
  }
}
