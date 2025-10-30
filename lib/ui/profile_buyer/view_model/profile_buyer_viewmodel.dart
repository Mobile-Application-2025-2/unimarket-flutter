import 'package:flutter/foundation.dart';

class ProfileBuyerViewModel extends ChangeNotifier {
  String displayName = 'User Name Buyer';

  void setDisplayName(String name) {
    displayName = name;
    notifyListeners();
  }

  void logout() {
    // TODO: integrate real logout later
    notifyListeners();
  }
}


