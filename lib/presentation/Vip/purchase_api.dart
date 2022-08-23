// // import 'package:flutter/services.dart';
// // import 'package:purchases_flutter/purchases_flutter.dart';

// // class PurchaseApi {
// //   static const _apiKey = 'IDeTcxFBDgPclEJQtWocRNjXdmmJMRnW';
// //   static Future init() async {
// //     await Purchases.setDebugLogsEnabled(true);
// //     await Purchases.setup(_apiKey);
// //   }

// //   static Future<List<Offering>> fetchOffers() async {
// //     try {
// //       final offerings = await Purchases.getOfferings();
// //       final current = offerings.current;

// //       return current == null ? [] : [current];
// //     } on PlatformException catch (e) {
// //       return [];
// //     }
// //   }

// //   static Future<bool> purchasePackage(Package package) async {
// //     try {
// //       await Purchases.purchasePackage(package);
// //       return true;
// //     } catch (e) {
// //       return false;
// //     }
// //   }
// // }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';

// export 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart'
//     show
//         IAPError,
//         InAppPurchaseException,
//         ProductDetails,
//         ProductDetailsResponse,
//         PurchaseDetails,
//         PurchaseParam,
//         PurchaseVerificationData,
//         PurchaseStatus;

// class InAppPurchase implements InAppPurchasePlatformAdditionProvider {
//   InAppPurchase._();

//   static InAppPurchase? _instance;

//   static InAppPurchase get instance => _getOrCreateInstance();

//   static InAppPurchase _getOrCreateInstance() {
//     if (_instance != null) {
//       return _instance!;
//     }

//     if (defaultTargetPlatform == TargetPlatform.android) {
//       InAppPurchaseAndroidPlatform.registerPlatform();
//     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//       InAppPurchaseIosPlatform.registerPlatform();
//     }

//     _instance = InAppPurchase._();
//     return _instance!;
//   }

//   @override
//   T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() {
//     return InAppPurchasePlatformAddition.instance as T;
//   }

//   Stream<List<PurchaseDetails>> get purchaseStream =>
//       InAppPurchasePlatform.instance.purchaseStream;

//   Future<bool> isAvailable() => InAppPurchasePlatform.instance.isAvailable();

//   Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) =>
//       InAppPurchasePlatform.instance.queryProductDetails(identifiers);

//   Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) =>
//       InAppPurchasePlatform.instance.buyNonConsumable(
//         purchaseParam: purchaseParam,
//       );

//   Future<bool> buyConsumable({
//     required PurchaseParam purchaseParam,
//     bool autoConsume = true,
//   }) =>
//       InAppPurchasePlatform.instance.buyConsumable(
//         purchaseParam: purchaseParam,
//         autoConsume: autoConsume,
//       );

//   Future<void> completePurchase(PurchaseDetails purchase) =>
//       InAppPurchasePlatform.instance.completePurchase(purchase);

//   Future<void> restorePurchases({String? applicationUserName}) =>
//       InAppPurchasePlatform.instance.restorePurchases(
//         applicationUserName: applicationUserName,
//       );
// }
