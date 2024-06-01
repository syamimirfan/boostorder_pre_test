import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boostorder_pre_test/components/input_field.dart';
import 'package:boostorder_pre_test/components/navigation.dart';
import 'package:boostorder_pre_test/view/add_cart.dart';
import '../api_services/product.dart';
import '../model/cart_model.dart';

class CartCategory extends StatefulWidget {
  const CartCategory({Key? key}) : super(key: key);

  @override
  State<CartCategory> createState() => _CartCategoryState();
}

class _CartCategoryState extends State<CartCategory> {
  //declarations
  final Product productService = Product();
  List products = [];
  List filteredProducts = [];
  List<int> counters = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

//getting all product
  Future<void> fetchAllProducts() async {
    try {
      List fetchedProducts = await productService.getProducts();
      setState(() {
        products = fetchedProducts;
        filteredProducts = products;
        counters = List.filled(products.length, 1);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

//filter all products for search
  void filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = products
          .where((product) => product['name']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            const Text('Categories Name', style: TextStyle(fontSize: 16, color: Colors.white,)),
            const SizedBox(width: 30),
            Image.asset('assets/BOLogo.png', width: 100, height: 100),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: Colors.white,),
          onPressed: () {},
        ),
      ),
      //Products 
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search, color: Colors.blue),
                          ),
                          onChanged: filterProducts,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart, color: Color(0xFFFFE02B), size: 35),
                            onPressed: () {
                              nextScreen(context, const AddCart());
                            },
                          ),
                          Positioned(
                            right: 0,
                            child: Consumer<CartModel>(
                              builder: (context, cart, child) {
                                return Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '${cart.itemCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  //for the search bar
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'Product not exist',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              bool isInCart = Provider.of<CartModel>(context).isInCart(product);

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        leading: Image.network(
                                          product['images'][0]['src'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['sku'] ?? 'SKU',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              '${product['stock_quantity']} In stock',
                                              style: const TextStyle(fontSize: 12, color: Colors.green),
                                            ),
                                            const SizedBox(width: 24, height: 4),
                                            Text(
                                              product['name'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 24, height: 4),
                                            Text(
                                              'RM ${product['regular_price']}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_rounded, color: Color(0xFFFFE02B)),
                                              onPressed: () {
                                                setState(() {
                                                  if (counters[index] > 1) {
                                                    counters[index]--;
                                                  }
                                                });
                                              },
                                            ),
                                            Text(
                                              '${counters[index]}',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_rounded, color: Color(0xFFFFE02B)),
                                              onPressed: () {
                                                setState(() {
                                                  if (counters[index] < 99) {
                                                    counters[index]++;
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 0.5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: isInCart
                                                ? null
                                                : () {
                                                    Provider.of<CartModel>(context, listen: false)
                                                        .addItem(product, counters[index]);
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isInCart ? Colors.grey : const Color(0xFFFFE02B),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Add to Cart",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
