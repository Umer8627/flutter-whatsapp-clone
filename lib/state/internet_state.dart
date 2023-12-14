import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';


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
