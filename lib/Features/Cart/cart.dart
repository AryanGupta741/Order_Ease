import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Features/Payment/payment.dart';
import 'package:restraunt_management_app/Provider/cart_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_button.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  double calculateTotalAmount(List<Map<String, dynamic>> cart) {
    double totalAmount = 0;
    for (final cartItem in cart) {
      totalAmount += cartItem['quantity'] * cartItem['price'];
    }
    return totalAmount;
  }

  Future<void> saveDailyIncome(DateTime date, double income) async {
    final url = 'http://localhost:3000/api/save_daily_income';

    // Extract date part from DateTime object
    final dateOnly = DateTime(date.year, date.month, date.day);

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'date': dateOnly.toIso8601String(), // Use only the date part
        'income': income,
      }),
    );

    if (response.statusCode == 200) {
      print('Daily income saved successfully');
    } else {
      print('Failed to save daily income: ${response.reasonPhrase}');
    }
  }

  Future<void> sendData(List<Map<String, dynamic>> cart) async {
    const url = 'http://localhost:3000/api/add-to-cart';

    for (final cartItem in cart) {
      final body = jsonEncode(cartItem);
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(
          'Response status for item ${cartItem['name']}: ${response.statusCode}');
      if (response.statusCode != 200) {
        // Handle errors appropriately in production (e.g., show error messages to user)
        print('Error saving item: ${response.body}');
      }
    }
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    final dateTime = DateTime.now(); // Capture current date and time
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: cart.isNotEmpty // Check if the cart is not empty
              ? Column(
            children: [
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              cartItem['imageurls'][0] as String),
                        ),
                        title: Text(
                          cartItem['name'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        subtitle: Text(
                          '${cartItem['quantity']} x ${cartItem['price']}', // Display quantity and price
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                    listen: false)
                                    .decrementQuantity(cartItem);
                              },
                              icon: Icon(Icons.remove, color: Colors.red),
                            ),
                            Text(
                              cartItem['quantity'].toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                    listen: false)
                                    .incrementQuantity(cartItem);
                              },
                              icon: Icon(Icons.add, color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                    listen: false)
                                    .removeProduct(cartItem);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${calculateTotalAmount(cart).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Proceed to pay',
                onTap: () {
                  sendData(cart);
                  saveDailyIncome(dateTime, calculateTotalAmount(cart));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Payment()));
                },
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Image.asset(
                  'assets/emptycart.jpeg',
                  height: 200,
                  width: 200,
                ),
                Text(
                  'Your cart is empty!',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
