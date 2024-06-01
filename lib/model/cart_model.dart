import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartModel extends ChangeNotifier {

  final List<Map<String, dynamic>> _items = [];
  final Map<int, int> _counters = {};

  List<Map<String, dynamic>> get items => _items;

  int get itemCount => _items.length;

  CartModel() {
    loadItems();
  }

  int get totalUnits {
    int total = 0;
    _counters.forEach((productId, count) {
      total += count;
    });
    return total;
  }

  void addItem(Map<String, dynamic> product, int unit) {
    final productId = product['id'];
    _items.add(product);
    _counters[productId] = unit; // Set the counter for the added product
    notifyListeners();
  }

  void removeItem(int index) {
    final removedProduct = _items.removeAt(index); // Remove the product from the list
    final removedProductId = removedProduct['id']; // Get the ID of the removed product
    _counters[removedProductId] = 0; // Reset the counter for the removed product
    notifyListeners(); // Notify listeners about the change
  }

  int getCounter(int productId) {
    return _counters[productId] ?? 1;
  }

  bool isInCart(Map<String, dynamic> product) {
    final productId = product['id'];
    return _items.any((item) => item['id'] == productId);
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart_items', jsonEncode(_items));
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartItems = prefs.getString('cart_items');
    if (cartItems != null) {
      _items.addAll(List<Map<String, dynamic>>.from(jsonDecode(cartItems)));
      notifyListeners();
    }
  }
}
