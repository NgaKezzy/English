import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WebViewScreen extends StatefulWidget {
  late final int index;
  final List<String> listLanguage;
  final YoutubePlayerController controller;

  WebViewScreen(
      {Key? key,
      required this.index,
      required this.listLanguage,
      required this.controller})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;
  late bool _isLoadingPage;
  late int selectedIndex;

  String _languageSelect = "";
  String _urlWebView = "";

  String changeLanguage(String languageCode, String languageSelect) {
    String linkWebView = '';
    switch (languageCode) {
      case 'en':
        linkWebView = "https://tracau.vn/index.html?s=$languageSelect";
        break;
      case 'ru':
        linkWebView = "https://www.dictionary.com/browse/$languageSelect";
        break;
      case 'vi':
        linkWebView = "https://tracau.vn/index.html?s=$languageSelect";
        break;
      case 'es':
        linkWebView =
            "https://en.bab.la/dictionary/english-spanish/$languageSelect";
        break;
      case 'hi':
        linkWebView =
            "https://en.bab.la/dictionary/english-hindi/$languageSelect";
        break;
      case 'ja':
        linkWebView =
            "https://en.bab.la/dictionary/english-japanese/$languageSelect";
        break;
      case 'zh':
        linkWebView =
            "https://en.bab.la/dictionary/english-chinese/$languageSelect";
        break;
      case 'tr':
        linkWebView =
            "https://en.bab.la/dictionary/english-turkish/$languageSelect";
        break;
      case 'id':
        linkWebView =
            "https://en.bab.la/dictionary/english-indonesian/$languageSelect";
        break;
      case 'th':
        linkWebView =
            "https://en.bab.la/dictionary/english-thai/$languageSelect";
        break;
      case 'ar':
        linkWebView = "https://glosbe.com/en/az/$languageSelect";
        break;
      case 'fr':
        linkWebView =
            "https://en.bab.la/dictionary/english-french/$languageSelect";
        break;
      case 'it':
        linkWebView =
            "https://en.bab.la/dictionary/english-italian/$languageSelect";
        break;
      case 'ko':
        linkWebView =
            "https://en.bab.la/dictionary/english-korean/$languageSelect";
        break;
      case 'sk':
        linkWebView = "https://glosbe.com/en/sk/$languageSelect";
        break;
      case 'sl':
        linkWebView = "https://glosbe.com/en/sl/$languageSelect";
        break;
      default:
        linkWebView = "https://tracau.vn/index.html?s=$languageSelect";
    }

    return linkWebView;
  }

  @override
  void initState() {
    var localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    selectedIndex = widget.index;
    _languageSelect = widget.listLanguage[selectedIndex];
    _urlWebView =
        changeLanguage(localeProvider.locale!.languageCode, _languageSelect);
    _isLoadingPage = true;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.play();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildListLanguage(),
            SizedBox(
              height: 10,
            ),
            _buildWebView()
          ],
        ),
      ),
    );
  }

  Widget _buildListLanguage() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  S.of(context).dictionary,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 35,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          _buildListViewLanguage(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

//View list từ mới
  Widget _buildListViewLanguage() {
    return Container(
      height: 50,
      child: ListView.builder(
        itemCount: widget.listLanguage.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return itemListView(index);
        },
      ),
    );
  }

//view item của list từ
  Widget itemListView(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: GestureDetector(
        onTap: () {
          if (selectedIndex != index) {
            setState(() {
              selectedIndex = index;
              _languageSelect = widget.listLanguage[index];
              _onItemTapped();
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: selectedIndex == index ? Colors.green : Colors.white,
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Text(
                widget.listLanguage[index],
                style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.black,
                    fontSize: 18,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      ),
    );
  }

// View WebView

  Widget _buildWebView() {
    return Expanded(
      child: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: _urlWebView,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onPageFinished: (finish) {
              setState(() {
                _isLoadingPage = false;
              });
            },
          ),
          _isLoadingPage
              ? Scaffold(
                  body: Center(
                    // child: CircularProgressIndicator(
                    //   valueColor:
                    //       new AlwaysStoppedAnimation<Color>(Colors.white),
                    // ),
                    child: const PhoLoading(),
                  ),
                  backgroundColor: Colors.black.withOpacity(0.70),
                )
              : Stack()
        ],
      ),
    );
  }

//reload webView chọn một từ mới
  void _onItemTapped() {
    setState(() {
      _isLoadingPage = true;
      _webViewController.loadUrl(changeLanguage(
          Provider.of<LocaleProvider>(context, listen: false)
              .locale!
              .languageCode,
          _languageSelect));
    });
  }
}
