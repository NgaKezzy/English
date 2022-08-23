import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class OpenSourceCopyright extends StatefulWidget {
  const OpenSourceCopyright({Key? key}) : super(key: key);

  @override
  _OpenSourceCopyrightState createState() => _OpenSourceCopyrightState();
}

class _OpenSourceCopyrightState extends State<OpenSourceCopyright> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          title: Text(
            S.of(context).OpenSourceCopyright,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Article 1. Introduction',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "These MelySoft Terms of Use are the agreement between You and Mely regarding the use of your MelySoft Account and/or Mely's products and services ('Services').",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "By using Mely's Services, You are deemed to have agreed to these Terms; Therefore, Please read these Terms carefully, especially those that disclaim or limit Mely's liability. If You do not agree to any of these terms, please stop accessing, downloading, or attempting to use any Mely Services.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The Services provided to You may be provided by Mely itself and/or its Subsidiaries, Mely Affiliates ("Affiliates"), as the case may be; in the event a Service is provided by an Affiliate with Mely, these Terms of Use shall also apply between You and the Affiliate providing such Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely Services are varied and for specific services (which You choose to use) additional terms of service may apply and/or separate terms of use may be required (including including age requirement to use the Service); in this case, the additional terms and or separate terms of use of such Services will become part of Your agreement with Mely if You use such Services.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 2. Concepts And Definitions',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '"Terms of Use": means these MelySoft Terms of Use and their amendments and supplements from time to time.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '"MelySoft": means the MelySoft account registered and managed by You to use the Service(s) of Mely and/or the Company associated with Mely.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '"Personal Information": is information intended to identify a specific individual as specified in clause 4.4, Article 4 of these Terms of Use.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '"Data": means the content/information created/generated in the process of You joining and using the Services of Mely and/or the Company Affiliated with Mely through logging in with MelySoft and hosted by the server system. (server) of Mely recorded.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 3. Age Requirements',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "To create a MelySoft account on your own and use Mely's Services, You must ensure that, You are at least fifteen (15) years of age. In case You are under the legal age, You need to get permission from Your legal representative (maybe a parent or legal guardian) to register and use a MelySoft account; You need to ask your legal representative to read and agree to these terms.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Where You are the legal representative and You allow your child/guardian to create and use a MelySoft account and/or Mely Services, You must abide by these terms and be responsible for the following: for the actions, activities of Your child/guardian in such Services',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely Services may have different age requirements for use in order to comply with Vietnamese law, for example: services for all ages, services for people over twelve ( 12) years of age or older and the service is for those who are eighteen (18) years of age or older and/or the age requirement for using the service (e.g. players under the age of eighteen (18) are not may play G1 video games for more than 180 minutes 24 hours a day); Therefore, in order to use these services, You need to consider the recommendations regarding the age of service, the length of time allowed to use the service and ensure that You or Your child/guardian is of age. as recommended by the service provided. Mely reserves the right to refuse to provide services to You at any time if You or Your child/guardian have not met the age requirements or used the service for more than the prescribed time.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 4. Registration of MelySoft',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'To register and initialize MelySoft, you need to create "Username" and "Password" on Melys system',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The choice of Username is your right; However, the Username of the User you choose must ensure:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Do not duplicate the previously registered Usernames; Mely will have a notification when the Username you choose is duplicated;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Not identical or related to (i) the name of the country; (ii) names of great people, national heroes; (iii) names of leaders of the Party and State in different periods;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '- Do not contain characters, content related to religion, politics, pornography, content that violates the law and/or fine customs of Vietnamese people;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '- Do not contain offensive, provocative, or disruptive characters or content to any organization or individual;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '- Do not contain misleading characters and content that MelySoft account is an administrator account, or created by Mely and/or Affiliates to administer and/or support users.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  'Password is the "key" to login to Your account; Therefore, You are responsible for storing and keeping Your password information confidential and not sharing password information with anyone. In any event, if You notice or suspect that your account has been logged in against Your will, You may (i) immediately change your password and/or (ii) notify Mely and carry out necessary procedures to temporarily lock your account to minimize damage to You in accordance with Melys customer complaint support process. Melytheo here reserves and waives any liability for any damages (if any) You should have if Your password is exposed in any way.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  'In accordance with Vietnamese law, You need to provide the following information to be able to use the Services of Mely and/or the Mely Affiliates:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '- First and last name;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '- Date of birth;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Number of ID card/Citizen identification card/Passport, date of issue, place of issue;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Address;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Electronic mail (email);',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Contact phone number (if any).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In case You are under fourteen (14) years old and do not have an ID card/Citizen Identification Card/Passport, your legal representative must decide on the registration of personal information of the representative himself. according to your law to express your consent and be responsible before the law for this registration.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Failure to provide, incomplete or inaccurate information above may limit your access to, use of the Service, or ensure Your legitimate rights and interests. In some specific cases, Mely may temporarily suspend the provision of Services to You without prior notice until fully and accurately receive the above information in accordance with regulations.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In order to ensure that the Personal Information provided by You is always up to date, accurate and complete, Melys system allows You to update Personal Information at any time, at Your discretion. From time to time, the type of information is updated and depends on the availability of services, technical systems and Melys policies; The update of this Personal Information may be effective immediately or subject to a time-out period (if a time-out is applicable), Mely will notify You specifically when You update information. You should note that, when receiving and dealing with any complaint, claim or request for support from You, Mely will base on Your Personal Information which was last updated and recorded. on Melys system (in case of time-out period, the information updated by You may not be recorded until the time-out period has ended) to identify the MelySoft account holder, the Personal Information that you previously provided will no longer be valid.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The registration and initialization of a MelySoft account, from time to time, can be done by using other social networking accounts, OTT such as Facebook, Google, Yahoo, Zalo accounts... However, you should note that, in the event that You lose, have your account revoked or have any problems logging in to your social media account, which OTT used to create your MelySoft account, You will also not be able to log into your MelySoft account; In this case, you need to contact the social network management units and businesses, OTT for assistance in handling.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Your use of social network accounts, OTT to register and initialize MelySoft as specified in Clause 4.8 above does not waive Your obligation to provide information as prescribed in this Article.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 5. Use of MelySoft',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The use of MelySoft must fully comply with the provisions of these Terms of Use, the specific provisions of the specific Services that You choose to use.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'You are responsible for all activities and actions taken from/by Your MelySoft account, including taking reasonable steps to secure Your MelySoft account.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Your use of MelySoft account must ensure (i) compliance with the provisions of Vietnamese law; (ii) not violate the Prohibited Acts (as set forth in Article 7 below); (iii) respect the rights of others, including privacy, intellectual property rights; (iv) not abuse or harm others (or threaten or encourage such abuse or harm) – eg: disinformation, fraud, defamation, bullying , trouble; (v) not to harm, interfere with or disrupt the Services.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In order to ensure compliance with the provisions of clause 5.3 above, Mely may apply necessary technical measures to limit and warn infringing content (for example, word filters) and may immediately Remove Your infringing content without prior notice.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In the event that You violate any provision of these Terms of Use, especially the Prohibited Practices and/or the provisions of Clause 5.3 above, Mely reserves the right to immediately block Your MelySoft account. and cease providing any and all of the Services to You without compensation or liability to You.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In case You do not log in and use your MelySoft account within six (6) consecutive months (from the last login), Mely has the right (but has no obligation) to lock your MelySoft account, Your Data; this means that (i) You will not be able to use any of the Services where You sign in with your MelySoft account; and (ii) all virtual units, virtual items, bonus points, etc. in such Services will be removed. In this event You agree that Mely will not have to indemnify or bear any liability to You.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 6. Collection, Use and Protection of Customer Information',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In accordance with the laws of Vietnam and in order to optimize the Services provided to You, Mely will collect and store (i) all of Your Personal Information; (ii) Your information and actions in the process of using MelySoft and/or the Services (eg: login time, logout time, IP address, login location); (iii) payment related information; (iv) the information and content that You send, receive and share in the process of using MelySoft and/or the Service (for example, log chat, log information posted by You); (v) information about the device You use to use Melys services; and (vi) other information, from time to time and in accordance with the provisions of Vietnamese law and/or competent State agencies.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In accordance with Vietnamese law, all Personal Information and Your Data will be stored for a minimum of two (2) years from the time You provide the information and/or create the data. The actual storage time of Your Personal Information and Data may be longer, depending on Melys infrastructure capabilities and responsiveness.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'You hereby irrevocably agree and agree that Mely has the right to use the above information to send You messages, emails, phone calls and/or contact You at any time. how Mely chooses to use to (i) support, provide the best Services for You (for example: account verification messages, password recovery support...); (ii) maintain and improve the Service; (iii) develop new services, (iv) send you information and content for the purpose of advertising and promoting the services of Mely and/or Mely Affiliates; (v) analyze and measure the effectiveness of the Services that You use; (vi) contact You directly for the purpose of customer care, information verification and other purposes.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely will provide, share Your Personal Information, Data and/or other information that Mely stores in the following cases:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'With your consent (for example: You use MelySoft to log in, use services outside MelyGroup and You agree to provide Your Personal Information to the units and organizations that provide those services) ;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'At the request of the Court and/or a competent State agency; or Mely proactively provide it to the competent State Authority in case your use of MelySoft account and/or Service shows signs of breaking the law.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Mely will take necessary technical measures to keep Your information secure, including but not limited to (i) encrypting the information to an appropriate standard; (ii) setting up firewall systems to prevent unauthorized access; (iii) use server services, server locations at units and enterprises with high security standards.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 7. Prohibited Acts',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Abuse of using MelySoft account and/or Service for the purpose of:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Against the State of the Socialist Republic of Vietnam; causing harm to national security, social order and safety; undermining the great national unity bloc; propaganda war, terrorism; causing hatred and conflicts among ethnic groups, ethnic groups and religions;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Propaganda, incitement to violence, lewdness, debauchery, crimes, social evils, superstition, destruction of the nations fine customs and traditions;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Disclosing state secrets, military secrets, security, economic, foreign affairs and other secrets prescribed by law;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Disseminating information that distorts, slanders or offends the reputation of the organization, the honor and dignity of individuals;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Advertising, propagating, trading in prohibited goods and services; disseminating journalistic, literary, artistic, prohibited publications and/or advertising other products or services without Melys approval;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Forging organizations and individuals and spreading fake information, untruthful information infringing upon the legitimate rights and interests of organizations and individuals;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Post or share content that infringes the intellectual property rights of any organization or individual;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Committing or aiming to commit other illegal acts.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Interfere with the lawful provision and access of information, and the provision and use of the Services by others.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Obstructing the operation, infiltrating or attempting to gain unauthorized access to Melys server system.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Unauthorized use of other peoples passwords or cryptographic keys; unauthorized sharing of private information, personal information of others.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Create links to illegal websites and applications that violate the law; create, install, and distribute malware and computer viruses; illegally infiltrate, gain control of information systems, create attack tools on the Internet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Buy and sell virtual units, virtual items, reward points between users of the Service;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Buy, sell, exchange (including gift, give) MelySoft account;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Performing acts (aimed at) to defraud and appropriate other peoples property;',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Impersonate or mislead others that You are an employee or collaborator of Mely.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 8. Intellectual Property Rights',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Some Mely Services allow you to share content through Melys systems; with respect to such content, You represent and warrant that, You are the sole and legal owner of this content, in the event that the content(s) You share is jointly owned, You warrant that , You have been given the full permission of You by this co-owner(s).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'With respect to content shared by You through Melys systems, You hereby irrevocably agree to grant Mely and Mely Affiliates a non-exclusive, perpetual, absolutely free, and to the extent globally to (i) store, reproduce, distribute, transmit and use Your Nội dung; (ii) publish, publicly perform or publicly display Your content if You have authorized it to be visible to others; (iii) edit and create derivative works based on Your content (e.g. reformat or translate content into another language).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'With respect to the Services provided to You by Mely and/or Mely Affiliates, Mely hereby grants You a non-exclusive, non-transferable, non-transferable and non-commercialized right to use Mely Services and/or Mely Affiliates.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In addition to the right to use the Service as granted to You in accordance with Clause 8.3 above, Mely retains all intellectual property rights to trademarks, product source codes, images, sounds, music, etc. the Services together with other rights relating to the Services made available to You.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 9. Limitation of Liability and Disclaimer of Warranty',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely is committed to providing the Services to You within the limits of its expertise and reasonable care in accordance with the law.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'To enhance the security and safety of the Service, Mely will apply one or more technical and/or software and application measures in or next to the Service; however, the application of the above measures should not be a guarantee that Your account will not be lost, hacked and Mely is completely exempt from liability under these circumstances.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely will apply necessary technical measures to assist You in getting the best experience when using the Service; however, in some unexpected cases, the Service may (i) be interrupted, (ii) have errors (bugs), (iii) lose or duplicate some information, features of the Service and/or Your MelySoft account; In this case, Mely will take all necessary measures (to the extent possible) and within a reasonable time to remedy and You agree to release Mely from all related liability.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Mely will apply necessary measures, in accordance with the law to protect and secure Your Personal Information and Data as stated in Clause 6.6, Article 6; however, You fully understand and agree that no system is ever completely secure and resistant to all attacks, hacks, cheats; Therefore, in case Melys system is hacked, hacked, cheated and Your Personal Information and Data (at risk) is exposed, Mely will immediately take necessary measures in accordance with the law. to minimize the effect on You and You agree to release Mely from any liability in connection therewith.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 10. Account-Related Support',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Any support issues related to MelySoft account will be supported through (i) website http://MelySoft.com/ or (ii) hotline number 1900561558 and strictly follow the Care and Feedback Process. Melys customer at the time of receipt of the complaint.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'All complaints related to MelySoft account and/or Services must be sent to Mely by one of the above methods and within three (3) months from the time the complaint arises; Past the above time limit, Mely has the right to refuse to receive and settle these complaints.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In order to make complaints, denunciations or reflections related to Your MelySoft account and/or the Service, Your account must be fully identified for Mely to have a basis for receiving and contacting You. In case Your account has not been fully identified or Mely has reasonable grounds to believe that the information You provide is incorrect, Mely has the right to refuse to handle Your complaints and denunciations until MelySofts account You meet all of the above requirements.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 11. Compliance with Laws and Regulations',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'You clearly understand and agree that, in addition to complying with the terms and conditions of use of your MelySoft account, You will (i) fully comply with other provisions of Vietnamese law; (ii) fully comply with the laws and regulations where You create your MelySoft account and/or access and use the Service and/or the country in which You are a national; and (iii) You will be solely responsible for any consequences of your failure to comply with any regulations where You create, access, use your MelySoft account and/or the Service and warrant that Mely will shall not bear any responsibility in connection with it.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In the event that Mely receives any claim, notice or request related to Your failure to meet the above requirements and/or Mely has a basis for reasonable speculation based on the information Mely has obtained, Mely may right to (i) stop providing the Services to You (including access to Your MelySoft account) without prior notice or liability to You and/or (ii) block all access to from the country that prohibits the use of MelySoft and/or the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 12. Applicable Law and Dispute Resolution',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'These Terms of Use are applied and interpreted in accordance with the provisions of the law of the Socialist Republic of Vietnam on all matters and aspects related to',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'In case there is any dispute or conflict between You and Mely that cannot be resolved in the spirit of negotiation and conciliation, You agree that such disputes will be brought to the Peoples Court for settlement. authority in Ho Chi Minh City – where Mely is headquartered.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 13. Remaining Terms',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The fact that one or more provisions of these Terms of Use are declared by a Court to be invalid will not affect the validity of the remaining provisions and the remaining provisions will still be binding on You and Mely. .',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Melys failure to exercise or delay in exercising any right, or remedy under these Terms of Use shall not be construed as a waiver of any right or remedy in these Terms of Use. and the exercise of part or all of a single right shall not preclude the exercise of any other right, power or remedy set forth in these Terms of Use.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 14. Effect of Application and Amendment',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'You agree that Mely has the right to amend or supplement part or all of the provisions of these Terms of Use without Your prior consent. In case You do not agree with any amendments and supplements, You have the right to terminate your use of MelySoft account and/or the Service before such amendments and supplements take effect; In case You continue to use your MelySoft account and/or the Service, it will be understood that You have agreed to all such amendments and supplements.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'These Terms of Use are effective as of May 7, 2020 and supersede all previous terms of use, MelySoft Terms of Use.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]),
        ));
  }
}
