import 'dart:io';

import 'package:app_learn_english/constant/constant_var.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/VipModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ItemDataVipWidget extends StatelessWidget {
  final ProductDetails? productDetails;
  final List<PurchaseDetails?>? listPurchaseDetails;
  final Function onPressed;
  final String productIds;
  ItemDataVipWidget({
    Key? key,
    required this.productDetails,
    required this.listPurchaseDetails,
    required this.onPressed,
    required this.productIds,
  });

  Widget buildButton(BuildContext context) {
    return MaterialButton(
      onPressed: (productDetails != null)
          ? () => onPressed(product: productDetails)
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          width: width,
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 150,
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: productDetails == null
                        ? checkColor(productIds)
                        : checkColor(productDetails!.id),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      productDetails == null
                          ? checkTitle(productIds, context)
                          : checkTitle(productDetails!.id, context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                      Row(
                        children: [
                          Text(
                            productDetails == null
                                ? checkDescription(productIds, context)
                                : checkDescription(productDetails!.id, context),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/new_ui/more/ic_ruby.svg',
                          )
                        ],
                      ),
                      // Text(
                      //   // data.name.toString(),
                      //   'Save: ${productDetails != null ? checkSale(productDetails!.id, productDetails!.price, context) : 0} ',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
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
            children: [
              Text(
                productDetails == null ? '0' : '${productDetails!.price}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: productDetails == null
                      ? checkColor(productIds)
                      : checkColor(productDetails!.id),
                ),
                width: 95,
                height: 45,
                child: buildButton(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color checkColor(name) {
    if (Platform.isIOS) {
      switch (name) {
        case 'ios.lovepho.1':
          return Colors.green;
        case 'ios.lovepho.2':
          return Colors.deepOrangeAccent;
        case 'ios.lovepho.3':
          return Colors.blue;
        default:
          break;
      }
    } else {
      switch (name) {
        case 'com.lovepho.1':
          return Colors.green;
        case 'com.lovepho.2':
          return Colors.deepOrangeAccent;
        case 'com.lovepho.3':
          return Colors.blue;
        default:
          break;
      }
    }

    return Colors.blue;
  }

  String checkAva(name) {
    switch (name) {
      case 'com.lovepho.1':
        return 'assets/icons-svg/most_basic.png';
      case 'com.lovepho.2':
        return 'assets/icons-svg/most_popular.png';
      case 'com.lovepho.3':
        return 'assets/icons-svg/best_value.png';
      default:
        break;
    }
    return 'assets/icons-svg/best-value.png';
  }

  String checkTitle(name, context) {
    if (Platform.isIOS) {
      switch (name) {
        case 'ios.lovepho.1':
          return 'Most Basic';
        case 'ios.lovepho.2':
          return 'Most Popular';
        case 'ios.lovepho.3':
          return 'Best Value';
        default:
          break;
      }
    } else {
      switch (name) {
        case 'com.lovepho.1':
          return 'Most Basic';
        case 'com.lovepho.2':
          return 'Most Popular';
        case 'com.lovepho.3':
          return 'Best Value';
        default:
          break;
      }
    }

    return 'Colors.blue';
  }

  String checkDescription(name, context) {
    if (Platform.isIOS) {
      switch (name) {
        case 'ios.lovepho.1':
          return '10';
        case 'ios.lovepho.2':
          return '52';
        case 'ios.lovepho.3':
          return '105';
        default:
          break;
      }
    } else {
      switch (name) {
        case 'com.lovepho.1':
          return '10';
        case 'com.lovepho.2':
          return '52';
        case 'com.lovepho.3':
          return '105';
        default:
          break;
      }
    }
    return 'Colors.blue';
  }

  String checkSale(name, price, context) {
    if (Platform.isIOS) {
      switch (name) {
        case 'ios.lovepho.1':
          return '';
        case 'ios.lovepho.2':
          return '~0.2\$';
        case 'ios.lovepho.3':
          return '~0.5\$';
        default:
          break;
      }
    } else {
      switch (name) {
        case 'com.lovepho.1':
          return '';
        case 'com.lovepho.2':
          return '~0.2\$';
        case 'com.lovepho.3':
          return '~0.5\$';
        default:
          break;
      }
    }

    return '';
  }
}
