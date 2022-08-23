import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';

class ListRoomScreen extends StatelessWidget {
  const ListRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Phòng học',
            style: TextStyle(
              fontSize: 22,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 6,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Color.fromRGBO(42, 44, 50, 1)
                            : Color.fromRGBO(230, 230, 230, 1),
                      ),
                      child: Center(
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 20,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(0.9),
                height: 0,
                thickness: 0.5,
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Join Learning Table',
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Color.fromRGBO(42, 44, 50, 1)
                          : Color.fromRGBO(230, 230, 230, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/new_ui/more/ic_taophong.svg',
                        height: 90,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(.8),
              ),
              _buildRoom(context),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(.8),
              ),
              _buildRoom(context),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(.8),
              ),
              _buildRoom(context),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(.8),
              ),
              _buildRoom(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoom(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/new_ui/home/ic_user.svg',
                    height: 55,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SvgPicture.asset(
                    'assets/new_ui/home/ic_user.svg',
                    height: 55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 80,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Tiếng anh công sở',
                    style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                primary: const Color.fromRGBO(237, 112, 107, 1),
                elevation: 0,
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Full',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
