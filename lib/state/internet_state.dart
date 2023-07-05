import 'dart:async';
import 'dart:isolate';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';

import '../models/user_model.dart';
import '../utills/snippets.dart';

class InternetState extends ChangeNotifier {
  bool isInternet = false;
  checkInternetConnection() {
    Connectivity().onConnectivityChanged.listen((connectionState) {
      if (connectionState == ConnectivityResult.none) {
        isInternet = false;
        notifyListeners();
      } else {
        isInternet = true;
        notifyListeners();
      }
    });
  }
}
