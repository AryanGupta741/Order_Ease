import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Provider/cart_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_button.dart';

class ProductRating extends StatefulWidget {
  const ProductRating({Key? key}) : super(key: key);

  @override
  State<ProductRating> createState() => _ProductRatingState();
}

class _ProductRatingState extends State<ProductRating> {
  late List<double> _ratings;
  late List<String?> _comments;

  Future<void> submitRatings(List<Map<String, dynamic>> cart) async {
    final url = 'http://localhost:3000/api/rate'; // Your API endpoint for rating products

    for (int i = 0; i < cart.length; i++) {
      final item = cart[i];
      final productId = item['_id']; // Assuming the product ID is stored under the key '_id'

      final body = jsonEncode({
        'productId': productId,
        'rating': _ratings[i],
        'comment': _comments[i],
      });

      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status for item $productId: ${response.statusCode}');
      if (response.statusCode != 200) {
        // Handle errors appropriately in production
        print('Error submitting rating for item $productId: ${response.body}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize ratings and comments for each item in the cart
    _ratings = List.generate(Provider.of<CartProvider>(context, listen: false).cart.length, (index) => 1);
    _comments = List.filled(_ratings.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Products'),
        backgroundColor: Colors.teal,
      ),
      body: cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/emptycart.jpeg', // Provide the path to your empty cart image
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'No items for feedback',
              style: TextStyle(fontSize: 18, color: Colors.teal),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          final productName = product['name']; // Assuming the product name is stored under the key 'name'

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: Text(productName),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product['imageurls'][0]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Rating: ', style: TextStyle(color: Colors.teal)),
                          IconButton(
                            icon: Icon(_ratings[index] >= 1 ? Icons.star : Icons.star_border, color: Colors.teal),
                            onPressed: () {
                              setState(() => _ratings[index] = 1);
                            },
                          ),
                          IconButton(
                            icon: Icon(_ratings[index] >= 2 ? Icons.star : Icons.star_border, color: Colors.teal),
                            onPressed: () {
                              setState(() => _ratings[index] = 2);
                            },
                          ),
                          IconButton(
                            icon: Icon(_ratings[index] >= 3 ? Icons.star : Icons.star_border, color: Colors.teal),
                            onPressed: () {
                              setState(() => _ratings[index] = 3);
                            },
                          ),
                          IconButton(
                            icon: Icon(_ratings[index] >= 4 ? Icons.star : Icons.star_border, color: Colors.teal),
                            onPressed: () {
                              setState(() => _ratings[index] = 4);
                            },
                          ),
                          IconButton(
                            icon: Icon(_ratings[index] >= 5 ? Icons.star : Icons.star_border, color: Colors.teal),
                            onPressed: () {
                              setState(() => _ratings[index] = 5);
                            },
                          ),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Optional comment',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _comments[index] = value.isNotEmpty ? value : null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          onTap: () {
            submitRatings(cart);
            cart.clear();
            Navigator.pop(context);
          },
          text: 'Submit Feedback',
          color: Colors.teal,
        ),
      ),
    );
  }

}
