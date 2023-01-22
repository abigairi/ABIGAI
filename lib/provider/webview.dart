import 'package:flutter/cupertino.dart';

class WebViewProvider with ChangeNotifier {
  String currentUrl = "https://abigail1.pythonanywhere.com/";

  changeUrl({String? oldUrl}) {
    currentUrl = oldUrl!;
    notifyListeners();
  }
}
