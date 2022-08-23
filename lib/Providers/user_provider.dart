import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _avatarUser = DataCache().getUserData().avatar.isEmpty
      ? null
      : (DataCache().getUserData().avatar.contains('http')
          ? DataCache().getUserData().avatar
          : 'https://img.phoenglish.com/images/user_avatars/${DataCache().getUserData().avatar}');

  void setAvatarUser(String? avatarUser) {
    _avatarUser = avatarUser;
    notifyListeners();
  }

  String? get avatarUser => _avatarUser;
}
