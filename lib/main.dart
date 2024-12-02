import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListPage(),
    );
  }
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
}

class ProductListPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final List<Product> products = [
    Product(name: 'Pizza ', price: 10.0),
    Product(name: 'Burgur', price: 20.0),
    Product(name: 'Sandwich ', price: 30.0),
    Product(name: 'Juice ', price: 40.0),
    Product(name: 'Softdrinks', price: 50),
    Product(name: 'Roll', price: 35)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => CartPage());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            tileColor: Colors.blueAccent,
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: ElevatedButton(
              onPressed: () {
                cartController.addToCart(product);
              },
              child: const Text('Add to Cart'),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty'),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        cartController.removeFromCart(product);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${cartController.totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }
}
