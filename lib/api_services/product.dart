import 'dart:convert';

import 'package:boostorder_pre_test/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
   
   final String authHeader = 'Basic ${base64Encode(utf8.encode('consumer_key:consumer_secret'))}';
   
   Future<List> getProducts() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('products')) {
      // If products exist in local storage, return them
      List<String> productsJson = prefs.getStringList('products')!;
      return productsJson.map((jsonString) => json.decode(jsonString)).toList();
    }

    int page = 1;
    int totalPages;
    List fetchedProducts = [];

    do {
      final response = await http.get(
        Uri.parse('${Utils.url}?page=$page'),
        headers: {
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200) {
        List pageProducts = json.decode(response.body);
        fetchedProducts.addAll(pageProducts);

        totalPages = int.parse(response.headers['X-WP-TotalPages']!);
        page++;
      } else {
        throw Exception('Failed to load products');
      }
    } while (page <= totalPages);

    // Save fetched products to local storage
    List<String> productsJson = fetchedProducts.map((product) => json.encode(product)).toList();
    await prefs.setStringList('products', productsJson);

    return fetchedProducts;
  }
   
}