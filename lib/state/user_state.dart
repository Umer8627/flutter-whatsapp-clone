import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';

import '../utills/snippets.dart';

class UserState extends ChangeNotifier {
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  setUserModel(String id) async {
    var senderUser = Hive.box('senderUser');
    _userModel = await AuthRepo.instance.getUserDetail(id);
    senderModel = userModel;
    senderUser.put(_userModel!.uid, _userModel!.toMap());
    if (kDebugMode) {
      print('sender user ${senderUser.values.first}');
    }
    notifyListeners();
  }
}
