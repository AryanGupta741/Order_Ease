import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> cart = [];

  void addProduct(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }

  void decrementQuantity(Map<String, dynamic> item) {
    if (item['quantity'] > 1) {
      item['quantity']--;
      notifyListeners(); // Notify listeners (Cart widget) about cart data changes
    }
  }

  void incrementQuantity(Map<String, dynamic> item) {
    item['quantity']++;
    notifyListeners(); // Notify listeners (Cart widget) about cart data changes
  }

  // Method to check if an item already exists in the cart
  bool itemAlreadyExists(Map<String, dynamic> product) {
    return cart.any((item) => item['name'] == product['name']);
  }
}
