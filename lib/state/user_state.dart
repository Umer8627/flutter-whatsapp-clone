import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';

class UserState extends ChangeNotifier {
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  setUserModel(String id) async {
    _userModel = await AuthRepo.instance.getUserDetail(id);
    log(_userModel!.toMap().toString());
    notifyListeners();
  }
}
