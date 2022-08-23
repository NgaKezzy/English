import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';

class ChannelProvider with ChangeNotifier {
  List<Category> _allCate = [];
  List<Category> _subscribedChannel = [];
  bool _isLoading = true;
  int _pageGetCate = 1;

  List<Category> get allCate => _allCate;
  List<Category> get subscribedChannel => _subscribedChannel;
  bool get isLoading => _isLoading;
  int get pageGetCate => _pageGetCate;

  void set pageGetCate(int page) {
    _pageGetCate = page;
    notifyListeners();
  }

  void set allCate(List<Category> cate) {
    _allCate.addAll(cate);
    notifyListeners();
  }

  void set subscribedChannel(List<Category> cate) {
    _subscribedChannel.addAll(cate);
    notifyListeners();
  }

  void set isLoading(bool isLoad) {
    _isLoading = isLoad;
    notifyListeners();
  }

  Future<void> addSubscribedChannel(
      BuildContext context, Category channel, String lang) async {
    int status = await TalkAPIs().followDataSubChannel(
      DataCache().userCache!.uid,
      channel,
      lang,
    );
    if (status == 1) {
      Utils().showNotificationBottom(
        true,
        S.of(context).Successfulchannelregistration,
      );
      int index = _allCate.indexWhere((element) => element.id == channel.id);
      _subscribedChannel.add(_allCate[index]);
      _allCate.removeAt(index);
      notifyListeners();
    } else {
      Utils()
          .showNotificationBottom(false, S.of(context).Thischannelissubscribed);
    }
  }
}
