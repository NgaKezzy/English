import 'dart:async';

import 'dart:io';

import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/home_provider.dart';
import 'package:app_learn_english/Providers/quiz_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/TargetView/TargetScreen.dart';
import 'package:app_learn_english/extentions/FunctionService.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/homepage/pages/page_flash_view.dart';
import 'package:app_learn_english/homepage/provider/channel_provider.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/TargetOffline.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/models/TalkModel.dart';

import 'package:app_learn_english/models/UserModel.dart';

import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/networks/location_services_api.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Ads/AdsBanner.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';

import 'package:app_learn_english/presentation/notification/api/notification_api.dart';
import 'package:app_learn_english/presentation/notification/push_notification.dart';
import 'package:app_learn_english/presentation/notification/screen/notification_screen.dart';
import 'package:app_learn_english/presentation/notification/service/notification_service.dart';
import 'package:app_learn_english/presentation/speak/provider/miniplay_provider.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/end_game.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';

import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';

import 'package:app_learn_english/socket/view/inside_table_screen.dart';
import 'package:app_learn_english/startpage/page_language.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './networks/DataOffline.dart';
import './presentation/home/home.dart';
import './presentation/profile/changeName.dart';
import './presentation/profile/changePassword.dart';
import './presentation/profile/confirmEmail.dart';
import './presentation/profile/profile.dart';
import './presentation/profile/widgets/LocaleProvider.dart';
import './presentation/speak/provider/all_list_talk_course.dart';
import './presentation/speak/provider/text_talk.dart';

import './screens/forgot_password_screen.dart';
import './screens/login_account_screen.dart';
import './screens/register_account_screen.dart';
import 'Providers/dialog_provider.dart';
import 'generated/l10n.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('vào đây nè');
}

bool _initialUriIsHandled = false;

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  NotificationService notificationService = NotificationService();
  await notificationService.initNotificationLocal();
  await notificationService.requestIOSPermissions();
  AdmobHelper.initialization();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  PlyrVideoPlayer createState() => PlyrVideoPlayer();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class PlyrVideoPlayer extends State<MyApp> {
  TargetProvider? targetProvider;
  bool isTouch = false;
  double size = 250 * 0.3;
  bool hasInternet = false;
  int count = 0;
  bool isCallback = false;
  bool isInitTarget = false;
  bool isFirtOpen = true;
  bool isInternet = true;
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  AdmobHelper admobHelper = AdmobHelper();
  late CountHeartProvider countHeartProvider;
  late SharedPreferences prefs;
  late int countHeart;
  late Future getFirstuse;
  late Future getFutureData;
  bool _isLoadingHeart = true;

  bool checkClose = true;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setHeart(int number) {
    setState(() {
      countHeart += number;
    });
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User được gán quyền');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}',
        );

        PushNotification notification = PushNotification(
          body: message.notification?.body,
          title: message.notification?.title,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        print('Tổng số thông báo $_totalNotifications');

        if (_notificationInfo != null) {
          NotificationApi.showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            payload: message.data['type'] == null
                ? 'video.${message.data['id']}'
                : '${message.data['type']}.${message.data['id']}.${message.data['vid']}',
          );
        }
      });
    } else {
      print('User không được gán quyền ');
    }
  }

  void checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
      print('Tổng số thông báo $_totalNotifications');
    }
  }

  void initAdsBanner(BannerAd? bannerAd) async {
    if (bannerAd != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          navigator.currentState!.context,
          MaterialPageRoute(
            builder: (context) => AdsBanner(
              bannerAd: bannerAd,
            ),
          ),
        );
      });
    }
  }

  void initTargetProvider() async {
    printYellow("START INIT");
    if (navigator.currentState != null) {
      printYellow("CONTEXT OK -  INIT");
      targetProvider = Provider.of<TargetProvider>(
          navigator.currentState!.context,
          listen: false);
      FunctionService().setProvider(targetProvider!);
      if (targetProvider != null) {
        Timer(Duration(seconds: 0), () async {
          DataCache().getUserTargetLogModel() != null &&
                  DataCache().getUserTargetLogModel().targetData != null
              ? targetProvider!
                  .setItemTarget(DataCache().getUserTargetLogModel().targetData)
              : targetProvider!.setItemTarget(TargetOffline().geTargetByKey(1));
          final prefs = await SharedPreferences.getInstance();
          var countLocal = prefs.getInt("count-target");
          var dayTarget = prefs.getInt("day-target");
          DateTime now = DateTime.now();
          printRed('Hôm nay là: ' + now.toString());
          print('Đếm $countLocal');
          print('Mục tiêu ngày $dayTarget');
          String formattedDate = DateFormat('yyyyMMdd').format(now);
          print('Đây là format now $formattedDate');

          if (countLocal != null && dayTarget != null) {
            if (int.parse(formattedDate) > dayTarget) {
              targetProvider!.setCount(0);
              prefs.setInt("count-target", 0);
              prefs.setInt("day-target", int.parse(formattedDate));
            } else {
              targetProvider!.setCount(countLocal);
            }
          } else {
            printRed("KHONG LOAD COUNT TU LOCAL");
            targetProvider!.setCount(0);
            prefs.setInt("day-target", int.parse(formattedDate));
          }
          if (!prefs.containsKey('today')) {
            prefs.setInt('today', now.millisecondsSinceEpoch);
          }
          DateTime dateCheck =
              DateTime.fromMillisecondsSinceEpoch(prefs.getInt('today')!);

          if (!prefs.containsKey('checkShowCongrats')) {
            prefs.setBool('checkShowCongrats', false);
          }
          bool checkShowCongrats = prefs.getBool('checkShowCongrats')!;

          Timer.periodic(Duration(seconds: 1), (Timer timer) {
            if (RoutersManager().routeFAB == "") {
              FunctionService().isImpl = false;
              timer.cancel();
              (context as Element).markNeedsBuild();
            } else {
              // printYellow("Test Provider: ");
              targetProvider!.updateCount().then(
                    (value) => {
                      // printRed("DONE"),
                      count = targetProvider!.count!
                    },
                  );
              if (targetProvider!.count ==
                  (targetProvider!.itemTarget!.timeM * 60)) {
                if (now.year >= dateCheck.year &&
                    now.day >= dateCheck.day &&
                    now.month >= dateCheck.month &&
                    checkShowCongrats == false) {
                  prefs.setBool('checkShowCongrats', true);
                  prefs.setInt('today', now.millisecondsSinceEpoch);
                  // Navigator.push(
                  //   navigator.currentState!.context,
                  //   MaterialPageRoute(
                  //     builder: (context) => GetRewarded(),
                  //   ),
                  // );
                }
              }
            }
          });
        });
      }
    } else {
      printYellow("Context NULL");
    }
  }

  @override
  void didChangeDependencies() async {
    var prefs = await SharedPreferences.getInstance();
    DataCache().setTempPassWord(prefs.getString('passwordUser') ?? '');
    if (_isLoadingHeart) {
      var lang = await getModelLangDefault();
      await DataOffline()
          .getDataSetting(keyData: "MainSetting", countryModel: lang)
          .then((value) => {
                if (value.toString() != '') {DataCache().setSettingData(value)}
              });
      String? token = await _messaging.getToken();
      print('Đây là token đấy: ' + token!);
      String langApi = await LocationServicesApi().getLanguageByIP();
      await UserAPIs().saveTokenFCM(token: token, lang: langApi);
      setState(() {
        _isLoadingHeart = false;
      });
    }

    super.didChangeDependencies();
  }

  Future<void> getFirstUseFnc(BuildContext context) async {
    int isFirstUse = await DataOffline().getDataFirtUse("isFirtUse");
    Provider.of<CheckLogin>(context, listen: false).setIsFirstUse(isFirstUse);
  }

  Future getFutureDataFnc(BuildContext context) async {
    final dataUser = await DataOffline().getDataLocal(keyData: "userData");
    Provider.of<CheckLogin>(context, listen: false).setUserData(dataUser);
  }

//start by zep process notification video detail
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    print('Có nhảy vào đấy 1');
    if (message.data['type'] == 'video') {
      DataTalk? dataTalk =
          await TalkAPIs().detailVideo(id: message.data['id']!);
      if (dataTalk != null) {
        navigator.currentState!.push(
          MaterialPageRoute(
            builder: (context) => NewPlayVideoScreenNormal(
              false,
              dataTalk: dataTalk,
              percent: 1,
              ytId: '',
              enablePop: true,
            ),
          ),
        );
      }
    } else if (message.data['type'] == 'flash') {
      DataTalk? dataTalk =
          await TalkAPIs().detailVideo(id: message.data['id']!);
      if (dataTalk != null) {
        navigator.currentState!.push(
          MaterialPageRoute(
            builder: (context) => PageFlashView(data: [dataTalk], idx: 1),
          ),
        );
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('videoId', int.parse('${message.data['vid']}'));
      prefs.setInt('videoOffline', int.parse('${message.data['id']}'));
    }
  }

  //end by zep process notification video detail

  CountryModel getDefaultLang(
      CountryData countryData, String languageShortName) {
    CountryModel countryDefault = countryData.listCountry.firstWhere(
        (element) => element.sortname == languageShortName.toLowerCase());
    if (countryDefault.sortname == languageShortName.toLowerCase()) {
      countryDefault.sortname = languageShortName;
    }
    return countryDefault;
  }

  late CountryData countryData;

  Future<CountryModel?> getModelLangDefault() async {
    var lang = await LocationServicesApi().getLanguageByIP();
    CountryModel defaultLang;
    if (DataCache().getCountryData() != null) {
      countryData = DataCache().getCountryData();
      defaultLang = getDefaultLang(
        countryData,
        lang,
      );
    } else {
      countryData = await TalkAPIs().fetchGetDataCountry();
      defaultLang = getDefaultLang(
        countryData,
        lang,
      );
    }
    return defaultLang;
  }

  void _handleOnesignal() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notificationư
      event.complete(event.notification);
      NotificationApi.showNotification(
          body: event.notification.body,
          title: event.notification.title,
          payload: event.notification.additionalData!['type'] == null
              ? 'video.${event.notification.additionalData!['id']}'
              : '${event.notification.additionalData!['type']}.${event.notification.additionalData!['id']}');
      printRed('Đù má sài gòn');
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.
      if (result.notification.additionalData!['type'] == 'video') {
        DataTalk? dataTalk = await TalkAPIs()
            .detailVideo(id: result.notification.additionalData!['id']);
        if (dataTalk != null) {
          navigator.currentState!.push(
            MaterialPageRoute(
              builder: (context) => NewPlayVideoScreenNormal(
                false,
                dataTalk: dataTalk,
                percent: 1,
                ytId: '',
                enablePop: true,
              ),
            ),
          );
        }
      } else if (result.notification.additionalData!['type'] == 'flash') {
        DataTalk? dataTalk = await TalkAPIs()
            .detailVideo(id: result.notification.additionalData!['id']);
        if (dataTalk != null) {
          navigator.currentState!.push(
            MaterialPageRoute(
              builder: (context) => PageFlashView(data: [dataTalk], idx: 1),
            ),
          );
        }
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('videoOffline',
            int.parse('${result.notification.additionalData!['id']}'));
        prefs.setInt('videoId',
            int.parse('${result.notification.additionalData!['vid']}'));
      }
      printRed('Đù má sài gòn mở');
    });

    // OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    //   // Will be called whenever the permission changes
    //   // (ie. user taps Allow on the permission prompt in iOS)
    // });

    // OneSignal.shared
    //     .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    //   // Will be called whenever the subscription changes
    //   // (ie. user gets registered with OneSignal and gets a user ID)
    // });

    // OneSignal.shared.setEmailSubscriptionObserver(
    //     (OSEmailSubscriptionStateChanges emailChanges) {
    //   // Will be called whenever then user's email subscription changes
    //   // (ie. OneSignal.setEmail(email) is called and the user gets registered
    // });
  }

  @override
  void initState() {
    // _showInternetConnectionWid = showNoInternet();
    // _handleInitialUri();
    // OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);

    OneSignal.shared.setAppId("978778f4-13ba-46d4-93b9-0a7277905497");
    _handleOnesignal();

    listenNotifications();

    FunctionService().setInitProviderFunction(initTargetProvider);
    NotificationApi.init(initScheduled: true);

    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();
    LocaleProvider().getDataSaveOffline();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Nhảy vào onmessage app');
      if (message.data['type'] == 'flash') {
      } else {
        DataTalk? dataTalk =
            await TalkAPIs().detailVideo(id: message.data['id']);
        if (dataTalk != null) {
          navigator.currentState!.push(
            MaterialPageRoute(
              builder: (context) => NewPlayVideoScreenNormal(
                false,
                dataTalk: dataTalk,
                percent: 1,
                ytId: '',
                enablePop: true,
              ),
            ),
          );
        }
      }
    });

    DataCache().getDataConfig();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final checkInternet = status == InternetConnectionStatus.connected;
      setState(() {
        hasInternet = checkInternet;
      });
    });

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();

    super.initState();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  Future onClickedNotification(String? payload) async {
    printBlue("PlayList:$payload");
    var payloadList = payload!.split('.');
    printBlue("PlayList:$payloadList");
    print('Có nhảy vào đấy 2');

    if (payloadList[0] == 'video') {
      DataTalk? dataTalk = await TalkAPIs().detailVideo(id: payloadList[1]);
      print('nhảy vào onclick');
      if (dataTalk != null) {
        navigator.currentState!.push(
          MaterialPageRoute(
            builder: (context) => NewPlayVideoScreenNormal(
              false,
              dataTalk: dataTalk,
              percent: 1,
              ytId: '',
              enablePop: true,
            ),
          ),
        );
      } else {
        int idTalk = await DataOffline().getIDDataTalk("uidDataTalk");
        DataTalk? dataTalk =
            await TalkAPIs().detailVideo(id: idTalk.toString());
        if (dataTalk != null) {
          navigator.currentState!.push(
            MaterialPageRoute(
              builder: (context) => NewPlayVideoScreenNormal(
                false,
                dataTalk: dataTalk,
                percent: 1,
                ytId: '',
                enablePop: true,
              ),
            ),
          );
        }
      }
    } else if (payloadList[0] == 'flash') {
      DataTalk? dataTalk = await TalkAPIs().detailVideo(id: payloadList[1]);
      if (dataTalk != null) {
        navigator.currentState!.push(
          MaterialPageRoute(
            builder: (context) => PageFlashView(data: [dataTalk], idx: 1),
          ),
        );
      }
    } else if (payloadList[0] == 'videoOnline') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('videoOffline', int.parse('${payloadList[1]}'));
      prefs.setInt('videoId', int.parse('${payloadList[2]}'));
    }
  }

  Widget showNoInternet() {
    Widget a = Container(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sorry! \nThe network connection has been lost. \n\nPlease check the network connection again and try again.',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isInternet = false;
                    });
                    Future.delayed(Duration(milliseconds: 5000), () {
                      setState(() {
                        isInternet = true;
                      });
                    });
                  },
                  child: const Center(
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return a;
  }

  @override
  void dispose() {
    // _sub?.cancel();

    super.dispose();
  }

  int convertId(String url) {
    List<String> uriArr = url.toString().trim().split("\/");
    var id = int.parse('${uriArr[5].replaceAll(new RegExp(r'[^0-9]'), '')}');
    return id;
  }

  String typeConversation(String url) {
    List<String> uriArr = url.toString().trim().split("/");

    print(uriArr.toString());
    return uriArr[4];
  }

  Widget renderWidget(BuildContext context, provider) {
    print("renderWidget");
    RoutersManager().setRoute("Loggedin");
    DataCache().setUserData(DataUser.fromJson(
        Provider.of<CheckLogin>(context, listen: false).getUserData));
    TargetAPIs()
        .getDataTarget(
            Provider.of<CheckLogin>(context, listen: false).getUserData['uid'])
        .then((value) {
      print("TestData:${value.level}");
      DataCache().setUserTargetLogModel(value);
      FunctionService().implProviderFunction();
      provider.reloadWithLogin();
    });

    return HomePage();
  }

  void callbackToTargetScreen() {
    navigator.currentState?.popUntil((route) {
      if (route.settings.name != TargetScreen.routeName) {
        navigator.currentState?.pushNamed(TargetScreen.routeName);
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ScreenUtilInit(
          designSize: Size(360, 690),
          builder: () => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => LocaleProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CheckLogin(),
              ),
              ChangeNotifierProvider(
                create: (_) => TargetProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => TextTalk(),
              ),
              ChangeNotifierProvider(
                create: (_) => AllListTalkCourse(),
              ),
              ChangeNotifierProvider(
                create: (_) => MiniPLayProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => VideoProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CountHeartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => StaticsticalProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => QuizVideoProvider(),
              ),
              ChangeNotifierProvider<DialogProvider>(
                create: (_) => DialogProvider(),
              ),
              ChangeNotifierProvider<SocketProvider>(
                create: (_) => SocketProvider(),
              ),
              ChangeNotifierProvider<QuizProvider>(
                create: (_) => QuizProvider(),
              ),
              ChangeNotifierProvider<UserProvider>(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(mode: ThemeMode.light),
              ),
              ChangeNotifierProvider<HomeProvider>(
                create: (_) => HomeProvider(),
              ),
              ChangeNotifierProvider<ChannelProvider>(
                create: (_) => ChannelProvider(),
              ),
            ],
            child: Consumer<LocaleProvider>(
                builder: (context, provider, snapshot) {
              provider.initData();
              getFirstUseFnc(context);
              getFutureDataFnc(context);

              return OverlaySupport.global(
                child: Consumer<ThemeProvider>(
                  builder: (ctx, themeObject, _) => MaterialApp(
                    themeMode: themeObject.mode,
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Colors.blue[600],
                      brightness: Brightness.light,
                      backgroundColor: Colors.grey[100],
                      fontFamily: 'Roboto',
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    darkTheme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Colors.blue[300],
                      brightness: Brightness.dark,
                      backgroundColor: Colors.grey[850],
                      fontFamily: 'Roboto',
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    // home: SettingScreen(),
                    navigatorKey: navigator,
                    locale: provider.locale,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      // GlobalWidgetsLocalizations.delegate,
                      // GlobalCupertinoLocalizations.delegate,
                      S.delegate
                    ],
                    supportedLocales: all,
                    debugShowCheckedModeBanner: false,
                    title: 'Pho English',
                    // theme: ThemeData(
                    //   fontFamily: 'Tahoma',
                    //   primarySwatch: Colors.blue,
                    //   textTheme: Theme.of(context).textTheme.copyWith(
                    //         headline1: const TextStyle(
                    //           fontSize: 20,
                    //           color: Colors.black,
                    //         ),
                    //         bodyText1: const TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.black,
                    //         ),
                    //         subtitle1: const TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    // ),
                    builder: (context, widget) {
                      return MediaQuery(
                        //Setting font does not change with system font size
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: hasInternet == false
                            ? widget!
                            : RoutersManager().routeFAB == ""
                                ? Stack(
                                    children: [
                                      widget!,
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      widget!,
                                      //Hiển thị view bottom điểm danh nổi trên màn hình
                                      // FABMenuCustom(
                                      //   callbackTarget: callbackToTargetScreen,
                                      // ),
                                    ],
                                  ),
                      );
                    },
                    home: Consumer<CheckLogin>(
                      builder: (context, checkLoginProvider, wiget) =>
                          (checkLoginProvider.getIsFirstUse == 0
                              ? const PageListLanguage()
                              : (checkLoginProvider.getUserData.isNotEmpty
                                  ? ScopedModel<DataUser>(
                                      model: DataUser.fromJson(
                                        checkLoginProvider.getUserData,
                                      ),
                                      child: renderWidget(context, provider),
                                    )
                                  : const LoginAccountScreen())),
                    ),
                    routes: {
                      HomePage.routeName: (ctx) => HomePage(),
                      TargetScreen.routeName: (ctx) => TargetScreen(),
                      Profile.routeName: (ctx) => Profile(),
                      changeName.routeName: (ctx) => changeName(),
                      confirmEmail.routeName: (ctx) => confirmEmail(),
                      changePassword.routeName: (ctx) => changePassword(),
                      // SettingScreen.routeName: (ctx) => SettingScreen(),
                      RegisterAccountScreen.routeName: (ctx) =>
                          RegisterAccountScreen(),
                      ForgotAccountScreen.routeName: (ctx) =>
                          ForgotAccountScreen(),
                      NotificationScreen.routeName: (ctx) =>
                          NotificationScreen(),
                      VipWidget.routeName: (ctx) => VipWidget(),
                      EndGameQuiz.routeName: (ctx) => EndGameQuiz(),
                      InsideTableScreen.routeName: (ctx) => InsideTableScreen(),
                    },
                  ),
                ),
              );
            }),
          ),
        ),
        onWillPop: () async {
          activeDialog(context, "Bạn có muốn thoát ứng dụng không?");
          return false;
        });
  }

  static final all = [
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('ru'),
    Locale('zh'),
    Locale('vi'),
    Locale('ja'),
    Locale('pt'),
    Locale('id'),
    Locale('th'),
    Locale('tr'),
    Locale('ms'),
    Locale('ar'),
    Locale('it'),
    Locale('de'),
    Locale('el'),
    Locale('nl'),
    Locale('pl'),
    Locale('ko'),
    Locale('kk'),
    Locale('bn'),
    Locale('ro'),
    Locale('uk'),
    Locale('uz'),
    Locale('af'),
    Locale('az'),
    Locale('ur'),
    Locale('bs'),
    Locale('bg'),
    Locale('hr'),
    Locale('cs'),
    Locale('da'),
    Locale('fi'),
    Locale('ht'),
    Locale('cre'),
    Locale('he'),
    Locale('hu'),
    Locale('lv'),
    Locale('no'),
    Locale('sr'),
    Locale('sk'),
    Locale('sl'),
    Locale('zh_Hant_TW'),
    Locale('fr'),
  ];
}

test(dynamic u) {
  return u;
}
