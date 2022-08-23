import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Text(
          S.of(context).PrivacyPolicy,
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
                'This Privacy Policy document contains types of information that Pho English Corporation (“Pho English”, “we”, “us”) collects, records, maintains and discloses through the Pho English app. If you have additional questions or require more information about our Privacy Policy, contact us through email at.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Types of personal information collected',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Pho English collects the minimum personal information necessary for the implementation of contracts for service provision, user identification, service improvement, development of new services, membership registration, and consultation.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The user agrees to allow Pho English to collect the essential data necessary to perform essential functions of the service and the optional personal information needed to provide more specialized services.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The user is not restricted from using the service even if said user does not agree to the collection of the selected personal information, however the user would not be able to make use of specialized services.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Information from social media platforms',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English receives nicknames, social media IDs, email addresses and profile images from the social media platform chosen to use social logins to sign up for the service.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English can collect the user’s personal information through social media platforms according to the policy and terms and conditions of each platform and the user’s consent agreements',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'User-generated content',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English stores content generated by users, including voice recording through speaking practices and the scores from “Listening Quizzes.” These data can be accessed on the app by users to review and keep track of their learning progress, and the data can be removed upon request',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Tech specs',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'In the case of mobile services, information such as mobile models, mobile network operator information, hardware ID, Advertising ID, and service use can be collected automatically, but specific individuals cannot be distinguished or identified through this information',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'When dealing with service related inquiries or the infringement of the user’s right, Pho English may collect user’s email address and phone number.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Purpose of collecting and using personal information',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The company uses the information collected for the following purposes:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To help users make good use of the service',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To identify users and prevent fraudulent use of the service',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To prepare statistical data on the service use',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To survey and analyze necessary service improvements',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To draw and send gifts, such as campaigns and events, via email.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To confirm the user’s identity when a report is made or a question is asked to the company',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- In order to inform of important notices as required',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To communicate advertising information, such as event',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- To monitor and analyze user behavior in relation to the usage of the app.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Personal information collection method',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The company collects personal information for service provision through the following methods:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Collecting directly from users during Pho English membership registration and usage',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Collecting through the Generated Information Collection Tool',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Collecting via written form, fax, telephone, message board, email',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Lawful Basis of Processing',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English processes personal data on the following lawful bases:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- For the performance of a contract, such as to provide our service and respond to requests from users.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Legitimate interests, such as to analyze user behavior in relation to the usage of the app',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Consent, such as to provide you with updates or to notify you of competitions.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Sharing and personal information',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'In principle, the company does not provide or share the user’s personal information to outside entities without the user’s prior consent. Exceptions shall be made in the following cases:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- In the case of the user agreeing to it beforehand',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- In the case of compliance with the compliance of the law',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The company entrusts its system operations needed to provide services to NAVER Cloud.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Personal information handling and processing',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Information collection and its data processing are carried out using computers and/or IT enabled tools, following organizational procedures and modes strictly related to the purposes indicated. In addition to Pho English, in some cases, the Data may be accessible to persons in charge involved with the operation of the application, such as administration, sales, marketing, legal and system administration personnel.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The data is processed at the Pho English is operating offices and in any other places where the parties involved in the processing are located.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Data transfer outside the EU',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English stores user data in the Republic of Korea, and transfers personal information collected within the EU to other third countries (i.e. any country not part of the EU) only pursuant to legitimate transfer mechanisms. Users can inquire with Pho English to learn which legitimate transfer mechanism applies to which specific service.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'User rights and execution practices',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Users may exercise certain rights regarding their data processed by the Pho English.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Withdraw their consent at any time. Users have the right to withdraw consent where they have previously given their consent to the processing of their personal information.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Lodge a complaint. Users have the right to bring a claim before their competent data protection authority.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Object to processing of their data. Users have the right to object to the processing of their data if the processing is carried out on a legal basis other than consent. Where personal information is processed for a public interest, in the exercise of an official authority vested in the Pho English or for the purposes of the legitimate interests pursued by the Pho English, Users may object to such processing by providing a ground related to their particular situation to justify the objection',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Access their data. Users have the right to learn if data is being processed by the Pho English, obtain disclosure regarding certain aspects of the processing and obtain a copy of the data undergoing processing.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Verify and seek rectification. Users have the right to verify the accuracy of their data and ask for it to be updated or corrected. Should the user request a correction of an error on the user’s personal information, the incorrect information will not be used until the correction is completed.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Restrict the processing of their data. Users have the right, under certain circumstances, to restrict the processing of their data. In this case, the Pho English will not process their data for any purpose other than storing it.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Have their personal information deleted or otherwise removed. Users have the right, under certain circumstances, to obtain the erasure of their data from the Pho English. Users may request account and data erasure below.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Receive their data and have the right to data portability. Users have the right to receive their data in a structured, commonly used and machine-readable format and, if technically feasible, to have it transmitted to another controller. This provision is applicable provided that the data is processed by automated means and that the processing is based on the user’s consent. Users may download the information shared through Pho English’s services below.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'How to exercise these rights',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Any requests to exercise user rights can be directed to the Data Protection Officer through the contact details provided in this document.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Personal information retention and period of use',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English may be allowed to retain personal information for a longer period whenever the User has given consent to such processing, as long as such consent is not withdrawn. Furthermore, Pho English may be obliged to retain personal information for a longer period whenever required to do so for the performance of a legal obligation or upon order of an authority.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'In principle, the company destroys the user’s personal information without delay when the purpose of collecting and using personal information is achieved',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'However, if it is necessary to preserve the personal information, the personal information can be kept for a certain period of time as follows:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Records of contracts or withdrawal of subscriptions, etc.: Storage for 5 years',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Records of payment and supply of goods: Storage for 5 years',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Records of consumer complaints or dispute handling: storage for three years',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Nickname and profile image for CS processing of withdrawal members: 3 months',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English collects the user’s IP address at the initial launch of the application on a device, for the purpose of determining the display language of the application served to the user, based on the geo-location detected from the IP address.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Information destruction procedure',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Information entered by the user for service use, etc. shall be destroyed after the purpose of service has been achieved and stored for a certain period in accordance with the internal policy and related statutes.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'The personal information is not used for anything other than the purpose of storage unless it is provided by law.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Personal information printed on paper is shredded with a shredder, and personal information stored in electronic file form is deleted using a technical method that does not allow records to be restored.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Technical Management Protection of Personal Information',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Questions, comments and requests regarding this policy should be addressed to the Data Protection Officer as follows.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'melysoftvn @gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'MELYSOFT, Location No. 832, Building HH03A Thanh Ha Urban Area . Ha Dong Districtm, HN, Vietnam, 100000',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'When handling the personal information of its users, Pho English seeks the following technical and administrative measures to ensure safety in order to prevent personal information from being lost, stolen, leaked, tampered with or damaged.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- The users personal information is stored and managed through an encryption communication system (SSL) and the password is stored and managed one way so that it cannot be decoded.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- In order to prevent users’ personal information from being leaked or damaged by hacking or computer viruses, the system is being installed in areas with restricted access from outside entities.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- In case of personal information corruption, we frequently back up data, prevent users personal information or data from being leaked or damaged by using the latest vaccine program, and secure transmission of personal information on the network through the cryptographic communication system (SSL).',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- Using an intrusion prevention system, we control unauthorized access from outside entities and try to equip all possible technical devices to ensure security systematically.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- By minimizing employees handling personal information, we reduce the risk of personal information leakage',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '- We provide regular training or campaigns for employees handling personal information on their privacy obligations and security.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Revisions to the Privacy Policy',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English version of this Privacy Policy is a translation based on the original Vietnamese version of the Privacy Policy with modifications to comply with the European Unions General Data Protection Regulation. Between these two versions, the original Vietnamese version of the Privacy Policy shall prevail in the event of a conflict being resolved in Vietnam.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Personal information handling and processing',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'We may update this Privacy Policy from time to time. We recommend that you review the Privacy Policy each time you visit the Platform to stay informed of our privacy practices.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Pho English version of the Privacy Policy is a translation based on the original Vietnam version of the Privacy Policy. If there is any conflict between these two versions, the original Vietnam version of the Privacy Policy shall prevail',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Executed on May 26, 2020.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context)
              //             =>
              //                 DeleteAccount())
              //     );
              //   },
              //   child: Text(
              //     'Delete Account',
              //     style: TextStyle(
              //         fontSize: 16,
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'Data portability request',
              //     style: TextStyle(
              //         fontSize: 16,
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'Read the previous Privacy policy',
              //     style: TextStyle(
              //         fontSize: 16,
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
            ]),
      ),
    );
  }
}
