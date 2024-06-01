import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boostorder_pre_test/components/navigation.dart';
import '../model/cart_model.dart';

class AddCart extends StatefulWidget {
  const AddCart({Key? key}) : super(key: key);

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            const Text(
              "Cart",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 125),
            Image.asset(
              "assets/BOLogo.png",
              width: 100,
              height: 100,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: Colors.white),
          onPressed: () {
            nextScreenPop(context);
          },
        ),
      ),
      // Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? const Center(
                child: Text(
                  'Product not Added',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final product = cart.items[index];
                        final unit = cart.getCounter(product['id']);
                        final priceString = product['regular_price']?.toString() ?? '0.0';
                        final double price = double.tryParse(priceString) ?? 0.0;
                        final totalPrice = price * unit;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['sku']?.toString() ?? 'SKU',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${product['stock_quantity']?.toString() ?? '0'} In stock',
                                      style: const TextStyle(fontSize: 12, color: Colors.green),
                                    ),
                                    const SizedBox(width: 24, height: 4),
                                    Text(
                                      product['name']?.toString() ?? 'Product Name',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 24, height: 4),
                                    Text(
                                      'RM ${price.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Image.network(
                                  product['images'][0]['src']?.toString() ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFE02B)),
                                  ),
                                  onPressed: () {
                                    cart.removeItem(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Remove",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const Text("Unit"),
                                        Text("$unit"),
                                      ],
                                    ),
                                    const SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Total"),
                                        Text("RM ${totalPrice.toStringAsFixed(2)}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                            const SizedBox(height: 4),
                          ],
                        );
                      },
                    ),
                  ),
                  // Checkout
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total (${cart.totalUnits})"),
                            Text(
                              "RM${cart.items.fold<double>(0.0, (sum, item) {
                                try {
                                  final priceString = item['regular_price']?.toString() ?? '0.0';
                                  final double price = double.tryParse(priceString) ?? 0.0;
                                  return sum + price * cart.getCounter(item['id']);
                                } catch (e) {
                                  return sum; // If parsing fails, just return the current sum
                                }
                              }).toStringAsFixed(2)}",
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE02B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
