import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FAQ extends StatefulWidget {
  const FAQ({
    Key? key,
  }) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  late List<DataFAQ> data;
  @override
  void didChangeDependencies() {
    data = <DataFAQ>[
      DataFAQ(
        'Common question',
        <DataFAQ>[
          DataFAQ(
            'Video is blue',
            <DataFAQ>[
              DataFAQ(
                  'Close here, due to Chrome Web View, some devices have blue video problem at Pho English'),
              DataFAQ(
                  'If you encounter this problem, follow these steps and check if the problem persists'),
              DataFAQ(
                  'If you encounter this problem, follow these steps and check if the problem persists'),
              DataFAQ(
                  '1. Please remove the Chrome app and reinstall it. If you can\'t delete, please re-initialize the settings and update.'),
              DataFAQ('*How to reset Chrome settings and update:'),
              DataFAQ('- Go to Chrome on Google Play(URL:'),
              DataFAQ('- Click the Uninstall button'),
              DataFAQ(
                  '- If you see the message Do you want to uninstall all updates for this Android system app?, tap OK..'),
              DataFAQ('-Tap the Update button when the uninstall is complete.'),
              DataFAQ('2. Power off the device and restart it.'),
              DataFAQ('3. Open Pho English again.'),
              DataFAQ(
                  'Since this is an issue caused by Chrome, follow the steps above to fix it.'),
              DataFAQ(
                  'Team Pho English is also looking for other solutions to fix the problem'),
            ],
          ),
          DataFAQ('Can\'t play video', <DataFAQ>[
            DataFAQ(
                'We\'re sorry for the inconvenience. If you take a moment to answer the following questions, we\'ll try to resolve the issue as quickly as possible:'),
            DataFAQ(
                '1. If you are having problems playing all the videos, please delete and reinstall the app and let us know if the problem persists.'),
            DataFAQ(
                '2. Can you watch videos as usual in Youtube app when using both Wifi and 3G/4G? And let us know if you can check out the 3 links below.'),
            DataFAQ('youtube address'),
            DataFAQ('web address Pho English'),
            DataFAQ('satic web Pho English'),
            DataFAQ(
                '3.Tell us the name of the country, the region you are in, and the name of the mobile network you are using.'),
            DataFAQ(
                'If you take some time to answer these questions and send feedback to Pho English, Pho English will quickly fix this problem..'),
          ]),
          DataFAQ(
              'When logging into Facebook, a screen is displayed asking to agree to the terms.',
              <DataFAQ>[
                DataFAQ(
                    'Pho English sincerely apologizes for this inconvenience.'),
                DataFAQ(
                    'When you proceed to log in to Facebook, what screen appears? Is there an error message on the screen?'),
                DataFAQ(
                    'If your screen appears asking to agree to the terms, try the following steps!'),
                DataFAQ('1. Visit Facebook Web'),
                DataFAQ(
                    '2. Settings > Applications and Web Sites > In the "Active Web Sites and Applications" section, press "View" (or "View and edit" if you are using a computer) Pho English application'),
                DataFAQ(
                    '3. Click the On/Off button on the right hand side of your email address to set it to ON and press the Save button.'),
                DataFAQ(
                    '4.Log in with your Facebook account on Pho English app.'),
              ]),
          DataFAQ('Poor picture or sound quality.', <DataFAQ>[
            DataFAQ(
                '1. This issue may occur because you are using an earlier version of WebView for Android. Please update to the latest version of WebView at the link below: https://play.google.com/store/apps/details?id=com.google.android.webview'),
            DataFAQ(
                '2. Please refer to the information below and if the problem persists, please report it under “Personal”'),
            DataFAQ(
                '- Make sure your device is connected to the Internet. The application cannot work without a network connection.'),
            DataFAQ(
                '- Are you just having problems playing video and audio, or is the problem with all other features of the app?'),
            DataFAQ(
                '- Let us know the device model (model) you are using. Also, when using the app, are you using a headset or any related device?'),
          ]),
          DataFAQ('Suddenly no subtitles', <DataFAQ>[
            DataFAQ(
                'If you accidentally press the wrong subtitle change button, the word EN will be displayed on the bottom left hand side of the video.'),
            DataFAQ('If you press the following button ALL EN VI OFF'),
            DataFAQ('You can customize 4 different subtitle modes.'),
          ]),
          DataFAQ('When the screen is broken or stretched', <DataFAQ>[
            DataFAQ(
                'Usually, the font size of Pho English does not follow the settings on the phone.'),
            DataFAQ(
                'If the error occurs when the font is too large, exit the application completely and open it again or power off the phone and restart.'),
            DataFAQ(
                'If your screen still shows the error after that, please go to the section. Personally, hit the `report a problem` button and send us your screenshot'),
          ]),
          DataFAQ('Youtube Unsupported Features', <DataFAQ>[
            DataFAQ(
                'Unfortunately, you will not be able to use the features that Youtube supports such as customizing the resolution, playing videos in the background, saving videos offline, etc.'),
            DataFAQ(
                'We will try to develop in-depth features not on video but in Speak for better learning efficiency!'),
          ]),
          DataFAQ('Having trouble with invite friends.', <DataFAQ>[
            DataFAQ('Note the following about invite friends:'),
            DataFAQ(
                '1.If the invitee registers to use the Pho English app through the invitation link, the key will be given to both the inviter and the recipient.'),
            DataFAQ(
                '2. At the invitation link, if you scroll down the screen below, you will see a `Copy invitation code` button. Follow the instructions below to enter the invitation code in the Personal section and you can both get the key.'),
            DataFAQ(
                '3. If this fails or if you experience any other issues, please report the problem in the Personal section and provide Pho English with the following information:'),
            DataFAQ(
                '- The email address of the person who sent the invitation'),
            DataFAQ(
                '- The email address of the person who received the invitation'),
            DataFAQ('-The invitation code you used.'),
          ]),
        ],
      ),
      DataFAQ(
        'Subscription (Pho English)',
        <DataFAQ>[
          DataFAQ('What is Pho English? ?', <DataFAQ>[
            DataFAQ('Pho English is the premium version ofPho English.'),
            DataFAQ('Pho English Plus has the following outstanding features:'),
            DataFAQ(
                '- Unlimited access to all content and functions in the app'),
            DataFAQ('-Learn English without ads.'),
            DataFAQ('- Unlimited diamonds.'),
            DataFAQ('- Store unlimited words and sentences.'),
            DataFAQ(
                'If you want to subscribe to Pho English, please click the "Start using Pho English" button in your profile.'),
            DataFAQ('You can unsubscribe at any time.'),
          ]),
          DataFAQ('I want to unsubscribe Pho English.', <DataFAQ>[
            DataFAQ(
                'Pho English is a monthly or yearly payment plan on a fixed date.'),
            DataFAQ(
                'If you cancel your subscription, you can still use Pho English Plus for the remaining subscription period, and the subscription period will end after the expiration date.'),
            DataFAQ(
                'Any fees charged prior to cancellation will not be refunded. (Please refer to the "I want a refund" section of the frequently asked questions (FAQ) section for more information).'),
            DataFAQ(
                'Payment for the Pho English Plus plan is made through the store on each device and not through the Pho English app, so the subscription won\'t be canceled even if you delete your account or delete the app itself '),
            DataFAQ(
                'If you wish to terminate your subscription, you must cancel your payment directly at the store on your device.'),
            DataFAQ('Google Play Store (Android):'),
            DataFAQ(
                'Android users can cancel Pho English Plus subscription through Google Play or Google Account Management.'),
            DataFAQ('For more information, please see the link below.'),
            DataFAQ('link ???'),
            DataFAQ('App Store (iOS/iPhone/iPad):'),
            DataFAQ(
                'iOS users can cancel their Pho English Plus subscription through the App Store.'),
            DataFAQ('For more information, please see the link below:'),
            DataFAQ('link ???'),
          ]),
          DataFAQ('Yes, but what payment method??', <DataFAQ>[
            DataFAQ(
                'Currently, Pho English Plus subscription payments can only be made via in-app payments from your device\'s store.'),
            DataFAQ('Google Play Store (Android):'),
            DataFAQ(
                'Android users will pay the Pho English Plus subscription fee at Google Play.'),
            DataFAQ(
                'Through the regular payment function of Google Play, the payment will be automatically calculated on the fixed date of every month.'),
            DataFAQ('For more information, please see the link below.'),
            DataFAQ('link ????'),
            DataFAQ('App Store (iOS/iPhone/iPad):'),
            DataFAQ(
                'iOS users will pay the Pho English Plus subscription fee at the App Store.'),
            DataFAQ('App Store subscriptions automatically charge you for'),
            DataFAQ(
                'payment method you have fixed on a fixed date every month.'),
            DataFAQ('For more information, please see the link below.'),
            DataFAQ('Link ???'),
          ]),
          DataFAQ('I want a refund.', <DataFAQ>[
            DataFAQ(
                'If you want a refund of your Pho English Plus subscription, you must request it at the store on your device.'),
            DataFAQ(
                'We currently only support in-app payments made through your device\'s store. Therefore, each store\'s return policies should be followed when making a refund. Pho English cannot participate in or modify individual policies.'),
            DataFAQ(
                'If a user wants a refund, they must request a refund through the platform operator, which may charge a small fee'),
            DataFAQ(
                'Pho English does not issue refunds for purchases across individual platforms, unless required by law.'),
            DataFAQ('Google Play Store (Android):'),
            DataFAQ(
                'If you sign up for Pho English Plus through Google Play, Google will handle the refund, not Pho English.'),
            DataFAQ(
                'Please apply for a refund following the instructions in the link below.'),
            DataFAQ('link ???'),
            DataFAQ('iTunes/Apple (iOS/iPhone/iPad):'),
            DataFAQ(
                'If you sign up for Pho English Plus with your Apple ID, Apple will do the refund, not Pho English.'),
            DataFAQ(
                'Please apply for a refund following the instructions in the link below.'),
            DataFAQ('link ???'),
          ]),
          DataFAQ('I want to change the payment method.', <DataFAQ>[
            DataFAQ(
                'Hiện tại, việc thanh toán đăng ký Pho English Plus chỉ có thể được thực hiện thông qua thanh toán trong ứng dụng có sẵn trong cửa hàng trên thiết bị của bạn.'),
            DataFAQ(
                'You can change the internal payment method on your Google or Apple account.'),
            DataFAQ('Google Play Store (Android):'),
            DataFAQ(
                'Android users can modify payment method in Google account.'),
            DataFAQ('For more information, see the link below.'),
            DataFAQ('link ??'),
            DataFAQ('App Store (iOS/iPhone/iPad):'),
            DataFAQ(
                'iPhone/iPad users can modify the payment method in their Apple account.'),
            DataFAQ('For more information, see the link below.'),
            DataFAQ('link ???'),
          ]),
          DataFAQ('TI can\'t pay.', <DataFAQ>[
            DataFAQ(
                'Currently, Pho English Plus subscription payments can only be made through in-app payments available in your device\'s store.'),
            DataFAQ(
                'You can make in-app payments after registering a payment method with Google or Apple.'),
            DataFAQ('Google Play (Android):'),
            DataFAQ(
                'Người dùng Android cần đăng ký phương thức thanh toán vào tài khoản Google của họ.'),
            DataFAQ('For more information, please see the link below.'),
            DataFAQ('link ???'),
            DataFAQ('App Store (iOS/iPhone/iPad):'),
            DataFAQ(
                'iPhone/iPad users need to register a payment method to their Apple account.'),
            DataFAQ('For more information, please see the link below.'),
            DataFAQ('link???'),
          ]),
          DataFAQ('I want to use Pho English on multiple devices.', <DataFAQ>[
            DataFAQ(
                'Accounts with a Pho English Plus subscription can only log in from two devices at the same time.'),
            DataFAQ(
                'However, there is no limit to the number of devices using a regular account that does not subscribe to Pho English Plus.'),
          ]),
          DataFAQ(
              'I logged in on a new device and didn\'t see my Pho English subscription.',
              <DataFAQ>[
                DataFAQ(
                    'If you are unable to use Pho English Plus after logging in from a new device, please follow these instructions to restore your purchase.'),
                DataFAQ(
                    '1.Click the "Personal" tab at the bottom right of the apps menu.'),
                DataFAQ(
                    '2. Press the "Settings" button (pulley) at the top right of the "Personal" screen.'),
                DataFAQ(
                    '3. Tap "Restore" next to "Paid Restore" under language settings.'),
                DataFAQ(
                    '4. Further instructions will be provided depending on your purchase details.'),
                DataFAQ(
                    'The "Paid Restore" function follows your purchase history at the device store. Paid recovery is only possible when the old and new devices share the same operating system.'),
                DataFAQ(
                    'If the new device\'s operating system is different from the old one, the "Paid restore" function cannot be used".'),
                DataFAQ(
                    'If the new device\'s operating system cannot download the Pho English Plus registration information, please try to log in with a different account.'),
              ]),
          DataFAQ(
              'My Pho English subscriptions don\'t appear in my Google Play Store/ App Store after I change devices.',
              <DataFAQ>[
                DataFAQ(
                    'Since each operating system uses a different store, if you change to a different operating system you will not see the subscription/pay history in the store on your new device.'),
                DataFAQ(
                    'You can find the details of your purchase at the store where you paid.'),
                DataFAQ(
                    'If you changed your device to iOS after paying for your Pho English Plus subscription from an Android device, you can view and manage your payment history from your Google account, not your new iOS device.'),
                DataFAQ(
                    'If you changed your device to Android after paying for your Pho English Plus subscription from an iOS device, you can view and manage your payment history from your Apple account, not the new Android device'),
              ]),
          DataFAQ(
              'I deleted Pho English/deleted Pho English account but payment is still in progress.',
              <DataFAQ>[
                DataFAQ(
                    'Currently, Pho English Plus subscription payments can only be made by in-app billing through your device\'s store.'),
                DataFAQ(
                    'Regardless of whether you delete the app, or delete your account, you must unsubscribe through your Google or Apple account.'),
                DataFAQ(
                    'Please refer to "I want to unsubscribe from Pho English Plus" in the frequently asked questions (FAQ) section for more information.'),
              ]),
          DataFAQ('I want free Pho English', <DataFAQ>[
            DataFAQ(
                'Pho English is still providing new free learning content every day.'),
            DataFAQ(
                'For video content, all content uploaded within 3 days is free.'),
            DataFAQ(
                'Nội dung miễn phí sau khi được phát hành 3 ngày sẽ trở thành nội dung dành riêng cho người đăng ký Pho English Plus, trừ khi bạn xem nội dung đó trong thời gian nội dung đó trong thời hạn 3 ngày nói trên.'),
            DataFAQ(
                'Any video content you learn within the 3-day period will continue to be made available to you.'),
            DataFAQ(
                'As for the content of speaking practice (Speak), there is a difference for each course'),
            DataFAQ(
                'Some courses may be exclusive to Pho English Plus subscribers only.'),
            DataFAQ(
                'You will continue to use any courses you have taken while the course is available for free'),
            DataFAQ(
                'If you subscribe to Pho English Plus, all content will be free and unrestricted'),
            DataFAQ(
                'For more information about Pho English Plus, please refer to "What is Pho English Plus?" in the frequently asked questions (FAQ) section'),
          ]),
        ],
      ),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          title: Text(
            'FAQ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 16),
            child: Row(children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.grey,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              ),
            ]),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  )),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) => DataPopUp(data[index]),
          itemCount: data.length,
        )
        //
        //   ],
        // ),
        );
  }
}

class DataFAQ {
  DataFAQ(this.title, [this.children = const <DataFAQ>[]]);

  final String title;
  final List<DataFAQ> children;
}

class DataPopUp extends StatelessWidget {
  const DataPopUp(this.popup);
  final DataFAQ popup;
  @override
  Widget _buildTiles(DataFAQ root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<DataFAQ>(root),
      title: Text(
        root.title,
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}
