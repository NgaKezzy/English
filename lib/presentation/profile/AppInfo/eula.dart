import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';

class EULA extends StatefulWidget {
  const EULA({Key? key}) : super(key: key);

  @override
  _EULAState createState() => _EULAState();
}

class _EULAState extends State<EULA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            S.of(context).TermsOfUse,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Article 1 (Purpose)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'These Terms and Conditions are designed to establish the rights, obligations and responsibilities and procedures between the company and its users in the use of "Pho English" provided by Melysoft (hereinafter referred to as "Pho English" provided by Melysoft (hereinafter referred to as "Pho English"). "Company") and related additional services.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 2 (Definition)',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The terms used in these Terms and Conditions are defined as follows:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '2.1 "Pho English" refers to an application that helps members learn a foreign language using publicly available online video, audio, and text images. (Depending on the context hereinafter referred to as "Pho English" or "Service").',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '2.2 "Member" means a user who enters into a service contract with the Company in accordance with these Terms and Conditions and uses the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '2.3 "Content" refers to all content (including, without limitation, text, audio, video and network services) that the Company makes available to Members in respect of its Services.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '2.4 "Public Content" means the text, audio, video or images contained in Content Provided by the Company that are released online for free or with advertising.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 3 (Publishing and amendment of terms and conditions)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '3.1 The "Company" will post the Terms and Conditions and Privacy Policy on the front page of its Services for easy access by Members.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '3.2 The Company may amend these Terms and Conditions as necessary, insofar as they do not violate the relevant statutes, such as the "Act on Regulation of Terms and Conditions" and the "Act on Regulations of Terms and Conditions". Promoting the Use of Information and Communication Networks and Protecting Information.”',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '3.3 The Company or the Members may terminate the service contract if the Members do not agree with the application of the revised Terms and Conditions. In this case, the Company will notify the Member of the reason for termination and the date of termination by email.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 4 (Interpretation of Terms and Conditions)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '4.1 The Company may have additional terms or policies for paid services and individual services (hereinafter referred to as "Additional Terms and Conditions") and Additional Terms and Conditions. These additions shall prevail where they conflict with these Terms and Conditions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '4.2 Matters or interpretations not covered by these Terms and Conditions will be subject to the Additional Terms and Conditions and related statutes or business practices.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 5 (Concluding contract)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '5.1 The Service Use Agreement is signed when the person who wants to become a Member (hereinafter referred to as the "Registrant") agrees to these Terms and Conditions, registers to become a Member and then the Company accept.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '5.2 Candidates must provide correct information when registering as a member. In addition, there may be restrictions on the use of the Service if false information is registered and any disadvantage or liability arising from such registration shall be with the applicant.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '5.3 In the event that the previous Subscriber has lost his/her membership, used a fake name or someone else\'s name, or other reasons why the service contract may not be approved, the approval of the translation contract service may be refused.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '5.4 The Company may refuse to accept the service contract due to the user\'s capacity or any other business or technical reason. The company will notify the candidate of the results.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 6 (Account)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.1 In order for a Member to use the Service, a service account (the "Account") must be opened, providing accurate, complete and up-to-date information if it changes.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.2 The Company allows Members to login using their social media platforms such as Facebook, Google, Apple. rather than allowing Members to register directly to prevent recklessly creating accounts in a dishonest manner. Account information is only visible to the member who created the account and is not disclosed to any other member of our services.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.3 This Service only supports one account per Member.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.4 The Company prohibits the following:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '① The act of impersonating another person by choosing or using their name',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② Acts of infringing upon a party\'s rights by using the name of a person or group other than themselves without proper authorization',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '③ Acts of insulting others or using vulgar or obscene names',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.5 Account management responsibility rests with the Member himself and the Member must not notify account information or allow the use of his/her account to third parties.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.6 If a Member realizes that his/her Account has been stolen or is being used by a third party, he/she must immediately notify the Company and follow the Company\'s instructions. The Company shall not be liable for any disadvantage arising from failure to notify the Company or follow instructions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '6.7 The Company shall not be liable for any loss incurred to the Member as a result of unauthorized theft of the Account. However, the Member may be liable for any damage caused to the Company or others as a result of unauthorized Account theft. However, this is not the case where Members are not guilty.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 7 (Content of Service)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The Pho English service provided by the Company to the Member is as follows:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '① Watch video: Video, image, text, audio, link, etc. can be provided.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '② Interactive function: Can provide voice recording, puzzle solving',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 8 (Change of Service)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '8.1 The Company may change all or part of the Services provided due to operational and technical needs, and will not provide any separate compensation to the Member unless otherwise provided in the Terms and Conditions. Terms and Conditions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '8.2 When changing the Service, the reason, date and details of the change will be posted on the notice board seven days before the change. However, if it is difficult to communicate the reason or the change in detail, the reason will be provided.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 9 (Notice to Members)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '9.1 The Company shall notify the Member via email registered by the Member when registering to use the service, unless otherwise provided for in these Terms and Conditions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '9.2 The method of notification provided for in Article 9.1 may be replaced if the notice concerns all Members and the Company informs the Member by posting a notice in the form of a notification message in the service or on notice board for at least seven days. However, this is not the case if the notification has a change that adversely affects the rights and obligations of the Member.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '9.3 Members must always update their email address and related information in order to receive notices from the Company. The Company shall not be liable for any disadvantages arising from the failure of the Members to do so.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 10 (Suspending the Service)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '10.1 The Company may suspend its Services for technical or business reasons, such as repair, inspection, replacement or disconnection of communication facilities such as computers or servers . In this case, in principle, an advance notice will be made, but if there is an unavoidable reason, an old post-event notice will be given.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 11 (Members Termination of Terms and Conditions, Termination Request)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '11.1 The Member may terminate the service contract at any time through the customer center within the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '11.2 Upon termination, information relating to the Service including the academic history recorded in the Member\'s Account will be deleted. Therefore, the Member must take appropriate action regarding the above information prior to termination. The Company shall not bear any responsibility for any damage caused to the Member if the Member fails to take such action.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '11.3 Members may request a suspension of their use of the Services following a specific process, such as a call center and email notification.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 12 (Termination of Terms and Conditions, Restrictions on Use)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '12.1 The Company may terminate the service contract performed with the Member without prior notice in the following cases:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '① In the event of a Member\'s death',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② In the event of stealing someone else\'s personal information or mobile device and using the Service',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '③ In the event of a threat or impediment to the provision of the Service through means such as making unauthorized changes to the Company\'s client program or hacking into a server',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '④ In case of inconvenience to other Members\' normal use of the Service',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑤ In the event of smearing or discrediting the Company or hindering business operations through means of spreading false information, fraud, etc.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑥ In the case of impersonating a system operator, operator or employee of the Company',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑦ In the event of spam activity related to the Service',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑧ In the event that a Member acts in breach of other obligations or regulations under these Terms and fails to remedy his or her actions for a substantial period of time despite being asked by the Company to do so.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '12.2 The Company may impose restrictions on the use of the Service in lieu of termination of Membership if the above reasons exist.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 13 (Posting advertisements)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The Company may post advertisements within the Service. Advertising may be from the Company or from third parties that cooperate with the Company.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 14 (Obligation of the Company)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '14.1 The Company is committed to providing the Service continuously and smoothly.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '14.2 The Company will establish a security system to protect Members\' personal information, including credit information, and will disclose and comply with the Privacy Policy.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '14.3 The Company will listen to the opinions and complaints of Members related to the use of the Service and will handle it if it deems it justifiable. The processed results will be notified to the Member via bulletin board or email.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 15 (Rights and Obligations of Members)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '15.1 The Company offers its Services free of charge. However, Services may be paid in accordance with Company policy. Additional functionalities (e.g. items) provided in the Service may be subject to a charge.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '15.2 The Member shall not have any rights to the Content made available by the Company through the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '15.3 Members may not use the Content for any purpose other than receiving the Services without the Company\'s consent and may incur all civil and criminal charges, especially if they do so. the following behaviours. However, the scope of use of the Public Content is subject to the extent of permission set forth by the copyright holder of the Public Content.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '① Unauthorized act of producing Content as separate video files etc.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② Unauthorized posting of content on the Internet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '③ Unauthorized actions in providing Content to third parties',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '④ Commercial conduct that undermines the interests of this Service or its affiliates providing Content',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑤ All other piracy of the Content',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '15.4 Members shall not gain unauthorized access to the Service servers and networks (for example, accessing the Services servers and networks using automated means or accessing the Services systems to collect Content). ) nor interfere with the provision of the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '15.5 Members are strictly prohibited from the following:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '① Providing false information to the Company or stealing information from others',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② Infringement of intellectual property rights, such as those of the Company or other third parties',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '③ Damage the reputation of the Company and other third parties, or hinder business operations',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '④ Disassembling, modifying, and imitating the Service through any changes',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑤ Defaming or collecting personal information of other Members',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑥ The use of the Service for commercial purposes without the consent of the Company',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑦ Disclosure of sexually explicit or violent information',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑧ Impersonate the Company in connection with the Service or spread false information',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑨ Other illegal or improper acts, such as those prohibited under Article 44 Clause 7 of the 「Information Network Promotion and Information Protection Act」',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 16 (“User Content”)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '16.1 "User Content" refers to any content (including, but not limited to, text, image or video files) uploaded by Members within the Service while using the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '16.2 User Content may not contain the following:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '① Content that defames or slanders others (including the Company and those appearing in the Content) without any basis',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② Contrasting content, such as abusive language, pornography, and violent content',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '③ Content that infringes the intellectual property rights, including copyrights, of others (including the Company and those appearing in the Content)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '④ Content that continues to cause fear or anxiety without any reason',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '⑤ Content contrary to fine customs and other social order',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '16.3 If Members violate Article 19.2, the following actions may be taken:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '① User Content that has been repeatedly reported or found to be in violation of Article 19.2 may automatically be temporarily removed. However, Members that have created content may lift this measure by demonstrating that their content did not constitute a violation of Article 19.2.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '② The Company may restrict the use of the Service to Members who are found to be in violation of Article 19.2 or have been reported more than a certain number of times. According to the provisions of Article 12, the Company may suspend the account and terminate the service contract.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '16.4 The Company does not guarantee the legality, accuracy or integrity of User Content.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '16.5 The Company may use User Content to promote or improve its Services and may edit, modify or copy User Content for these purposes.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 17 (Copyright ownership and restrictions on copyright use)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '17.1 The rights to the intellectual property rights of things manufactured and provided by the Company, such as the Company\'s trademarks, logos, Services and advertising, shall belong to the Company.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '17.2 Members may not use information obtained by using the Service for profit through reproduction, transmission, publication, distribution, broadcasting or other means, or permitting third parties to used without the prior consent of the Company.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 18 (Warranty and Disclaimer)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '18.1 The Company may suspend its Services for technical or business reasons, such as repair, inspection, replacement or disconnection of communication facilities such as computers or servers . In this case, in principle, an advance notice will be made, but if there is an unavoidable reason, an old post-event notice will be given.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '18.2 Suspension of the Service will be notified by posting a notice on a notice board within the Service or on the Service website.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '18.3 In the event that the Service cannot be provided due to a natural disaster or a corresponding force majeure event, the Company shall be relieved of its responsibility to provide the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '18.4 In the case of Public Content, its use may be restricted in some countries due to restrictions imposed by the original author. Use of Public Content in the Service may be discontinued for reasons such as the original author changing privacy settings.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '18.5 The Company makes no promises as to the accuracy, reliability or suitability of the Content, Public Content and User Content. It also does not guarantee the quality of third-party products or other information purchased or obtained as a result of advertising, information, or other recommendations through the Service.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 19 (Termination of Service)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '19.1 The Company may terminate the Service for regulatory reasons and will notify the Member through the means specified in Article 3.3 three months prior to the date of termination.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '19.2 During the period between the date of notice of termination and the date of termination of the Service, the Service may be partially limited.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Article 20 (Obligation to Protect Personal Information)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'The Company strives to protect personal information, including Member registration information, as provided in accordance with relevant regulations. In this regard, the Company complies with the relevant regulations and its Privacy Policy and publishes this information through its website so that it can be accessed by members at all times.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]),
        ));
  }
}
