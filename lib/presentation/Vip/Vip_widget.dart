import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/home_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/constant/constant_var.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/config/config_app.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Vip/Item_Data_vip.dart';
import 'package:app_learn_english/presentation/Vip/Item_content_vip.dart';
import 'package:app_learn_english/presentation/Vip/Item_sub_vip.dart';
import 'package:app_learn_english/presentation/profile/vip/api_vip.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/loading_circle.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class VipWidget extends StatefulWidget {
  static const routeName = '/upgradevip';
  @override
  State<StatefulWidget> createState() {
    return _VipWidget();
  }
}

class _VipWidget extends State<VipWidget> {
  int _isVip = DataCache().userCache!.isVip;
  bool _isLoadingProduct = true;

  // khai báo in app
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // khai báo product id
  final List<String> _productIDs = [
    // ConstantsIAP.packageIAP[0]['package'],
    // ConstantsIAP.packageIAP[1]['package'],
    // ConstantsIAP.packageIAP[2]['package'],
    // ConstantsIAP.packageIAP[3]['package'],
    // ConstantsIAP.packageIAP[4]['package'],
    // ConstantsIAP.packageIAP[5]['package'],
  ];

  bool _available = true;
  //Danh sách list in app product ở đây
  List<ProductDetails> _products = [];

  // Danh sách list in app đã mua ở đây
  List<PurchaseDetails> _purchases = [];

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  DataUser userFake = DataCache().getUserData();

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        setState(() {
          _purchases.addAll(purchaseDetailsList);
          _listenToPurchaseUpdated(purchaseDetailsList);
        });
      },
      onDone: () {
        _subscription!.cancel();
      },
      onError: (error) {
        _subscription!.cancel();
      },
    );

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isLoadingProduct) {
      if (context.read<HomeProvider>().configApp != null) {
        context.read<HomeProvider>().configApp!.inapps!.forEach((element) {
          String packageID = element.package!;
          if (Platform.isIOS) {
            packageID = packageID.replaceAll('com.lovepho', 'ios.lovepho');
            packageID = packageID.replaceAll('most.', 'ios.most.');
            _productIDs.add(packageID);
          } else {
            _productIDs.add(packageID);
          }
          print("packageID:${packageID}");
        });
      }
      print("start inapp isavailable");
      _available = await _inAppPurchase.isAvailable();
      if (_available) {
        print('store đã gọi được');
        ProductDetailsResponse response =
            await _inAppPurchase.queryProductDetails(_productIDs.toSet());
        setState(() {
          _products = response.productDetails;
        });
        print("ListProduct:${_products.length}");
      }
      print("en inapp isavailable");
    }

    setState(() {
      _isLoadingProduct = false;
    });

    super.didChangeDependencies();
  }

  void logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear().then((value) => {
          printYellow("CLEAR OK "),
          SocialNetworks().facebookLogout(),
          SocialNetworks().googleLogout(),
          DataOffline().clearCache(),
          RoutersManager().clearRoute(),
          Provider.of<LocaleProvider>(context, listen: false)
              .reloadWithLogout(),
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginAccountScreen(),
            ),
            (route) => false,
          ),
        });
    var staticsticalProvider = Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    staticsticalProvider.clear();
    print('Đây là count: ${prefs.getInt('Heart_Global')}');
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('đang chờ mua');
          break;
        case PurchaseStatus.purchased:
          print("purchaseDetails.productID:${purchaseDetails.productID}");
          if (purchaseDetails.productID == 'most.basic' ||
              purchaseDetails.productID == 'most.best' ||
              purchaseDetails.productID == 'most.popular' ||
              purchaseDetails.productID == 'ios.most.basic' ||
              purchaseDetails.productID == 'ios.most.best' ||
              purchaseDetails.productID == 'ios.most.popular') {
            if (_isVip == 0 || _isVip == 3 || _isVip == 2) {
              await DataCache().setIsVip(1);
              print('Đã mua xong và setVip');
              setState(() {
                _isVip = DataCache().userCache!.isVip;
              });
              Utils().showNotificationBottom(
                  true, S.of(context).msgScriptionVipSuccess);
            }
          } else {
            DataUser user = DataCache().getUserData();
            int numberHeart = await UserAPIs().addAndDivHeart(
                username: user.username,
                uid: user.uid,
                typeAction: ConfigHeart.mua_kim_cuong,
                package_inapp: purchaseDetails.productID,
                sign: generateMd5(
                    '${user.uid}${user.username}12@##\$534534S\$CTYERER'));
            context.read<CountHeartProvider>().setCountHeart(numberHeart);

            Utils().showNotificationBottom(true,
                S.of(context).msgInappSuccess + "$numberHeart" + " Diamon.");
          }

          break;
        case PurchaseStatus.restored:
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (!valid) {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
          break;
        case PurchaseStatus.error:
          print('Lỗi trong quá trình mua');
          print(purchaseDetails.error!);
          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  void _subscribe({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    userFake.uid == 0
        ? logOut(context)
        : _inAppPurchase.buyConsumable(
            purchaseParam: purchaseParam,
          );
  }

  Widget buildButtonVip() {
    print('Vip là: $_isVip');
    if (_isVip == 2) {
      return MaterialButton(
        onPressed: () async {
          await DataCache().setIsVip(3);
          setState(() {
            _isVip = DataCache().userCache!.isVip;
          });
          activeDialog(context, S.of(context).CanceledVIPtrial);
        },
        child: Text(
          S.of(context).Canceltrial,
          style: TextStyle(color: Colors.white, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    } else if (_isVip == 0) {
      return MaterialButton(
        onPressed: () async {
          userFake.uid == 0
              ? logOut(context)
              : await DataCache().setIsVip(2).then((value) => {
                    setState(() {
                      _isVip = DataCache().userCache!.isVip;
                    }),
                    activeDialog(context, S.of(context).YouaretryingVIP),
                  });
        },
        child: Text(
          S.of(context).StartTrial,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return MaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 60,
          child: Center(
            child: Text(
              S.of(context).YouHaveExpired,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  String checkExperied(name, context) {
    ConfigApp? configApp = Provider.of<HomeProvider>(context).configApp;

    var product = null;
    configApp!.inapps!.forEach((element) {
      String packageID = element.package!;
      if (Platform.isIOS) {
        packageID = packageID.replaceAll('com.lovepho', 'ios.lovepho');
        packageID = packageID.replaceAll('most.', 'ios.most.');
      }
      if (packageID == name) {
        product = element;
      }
    });
    return product.month!.toString() + ' Months';
  }

  Widget buildButton(BuildContext context, ProductDetails? productDetails) {
    return MaterialButton(
      onPressed: productDetails != null
          ? () => _subscribe(product: productDetails)
          : () {},
      child: Text(
        S.of(context).Choose,
        style: TextStyle(color: Colors.white, fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.read<ThemeProvider>();

    double width = MediaQuery.of(context).size.width;
    List<String> detail = [
      '*${S.of(context).YouCanSignUpForA7Day}',
      '*${S.of(context).YouCanCancel}',
      '*${S.of(context).WhenCanceling}',
      '*${S.of(context).IfYouDo}',
    ];
    List<List<String>> gioiThieu = [
      [
        '${S.of(context).UnlimitedHearts}',
        'assets/icons-svg/icon_unlimited_hearts.png'
      ],
      ['${S.of(context).Disableads}', 'assets/icons-svg/icon_disable_ad.png'],
      [
        '${S.of(context).UnlimitedSamples}',
        'assets/icons-svg/icon_unlimited_reviews.png'
      ],
      [
        '${S.of(context).WatchAllVIPVideos}',
        'assets/icons-svg/icon_vip_video.png'
            'assets/icons-svg/icon_vip_video.png'
      ],
    ];
    return _isLoadingProduct
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(45, 48, 57, 1)
                    : Colors.white,
                title: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).Shop,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                leadingWidth: 50,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/new_ui/more/Iconly-Arrow-Left.svg',
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(right: 0, left: 0),
                decoration: BoxDecoration(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Color.fromRGBO(24, 26, 33, 1)
                      : Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: TabBar(
                          labelColor: const Color.fromRGBO(96, 203, 124, 1),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: const Color.fromRGBO(96, 203, 124, 1),
                          unselectedLabelColor:
                              themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                          unselectedLabelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Tab(
                              text: S.of(context).Diamond,
                            ),
                            Tab(
                              text: S.of(context).BuyVip,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  width: width,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // for (var langDataVip in DataCache().getVipConfigData()!.data)
                                      for (var i = 0;
                                          // i < DataCache().getVipConfigData()!.data.length;
                                          i < _productIDs.length - 3;
                                          i++)
                                        ItemDataVipWidget(
                                          productDetails: (_products.isEmpty ||
                                                  _products.length <= 3)
                                              ? null
                                              : _products[i],
                                          listPurchaseDetails: _purchases,
                                          onPressed: _subscribe,
                                          productIds: _productIDs[i],
                                        )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: _buildBenefit(S
                                      .of(context)
                                      .CreateAnOnlineClassWithFriends),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: _buildBenefit(S.of(context).BuyVip),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      _buildBoxBuyVIP(
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? checkExperied(
                                                _products[3].id, context)
                                            : checkExperied('', context),
                                        ConstantsIAP.packageIAP[0]['stone']
                                            .toString(),
                                        'Most Basic',
                                        const Color.fromRGBO(96, 203, 124, 1),
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? _products[3]
                                            : null,
                                      ),
                                      _buildBoxBuyVIP(
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? checkExperied(
                                                _products[4].id, context)
                                            : checkExperied('', context),
                                        ConstantsIAP.packageIAP[1]['stone']
                                            .toString(),
                                        'Most Popular',
                                        Colors.blue,
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? _products[4]
                                            : null,
                                      ),
                                      _buildBoxBuyVIP(
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? checkExperied(
                                                _products[5].id, context)
                                            : checkExperied('', context),
                                        ConstantsIAP.packageIAP[2]['stone']
                                            .toString(),
                                        'Most Best',
                                        Colors.orange,
                                        (_products.isNotEmpty &&
                                                _products.length > 3)
                                            ? _products[5]
                                            : null,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  for (var i = 0; i < gioiThieu.length; i++)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildBenefit(gioiThieu[i][0]),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          const Color.fromRGBO(214, 182, 88, 1),
                                          const Color.fromRGBO(
                                              241, 207, 106, 1),
                                        ],
                                      ),
                                    ),
                                    width:
                                        ResponsiveWidget.isSmallScreen(context)
                                            ? width / 1.2
                                            : width / 1,
                                    child: buildButtonVip(),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var sub in detail)
                                        ItemSubVipWidget(
                                          subContent: sub,
                                        )
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      S.of(context).ContinuedLimitedAccess,
                                      style: TextStyle(
                                          color: themeProvider.mode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildBenefit(String benefit) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(96, 203, 124, 1),
            ),
            padding: const EdgeInsets.all(2),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            benefit,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBoxBuyVIP(String hsd, String price, String titlePack,
      Color color, ProductDetails? products) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withOpacity(0.4),
            ),
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      titlePack,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hsd,
                        style: TextStyle(
                          color: context.read<ThemeProvider>().mode ==
                                  ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    products != null ? products.price : '0 đ',
                    style: TextStyle(
                      color:
                          context.read<ThemeProvider>().mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(width: 10),
                  // SvgPicture.asset(
                  //   'assets/new_ui/more/ic_ruby.svg',
                  // )
                ],
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: color,
                ),
                width: 95,
                height: 45,
                child: buildButton(context, products != null ? products : null),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
