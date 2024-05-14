import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String user = ''; // Initialize the user variable
  String table_number='';

  void addUser(String name) {
    user += name; // Append the new name to the user string
    notifyListeners();
  }
  void addTable(String table_number) {
    table_number += table_number; // Append the new name to the user string
    notifyListeners();
  }

  void removeUser(String name) {
    user = user.replaceAll(name, ''); // Remove the specified name from the user string
    notifyListeners();
  }
  void removeTable(String name) {
    table_number = table_number.replaceAll(table_number, ''); // Remove the specified name from the user string
    notifyListeners();
  }
}
