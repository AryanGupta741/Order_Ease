import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Features/Admin/add_food.dart';
import 'package:restraunt_management_app/Provider/cart_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_card.dart';
class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Map<String, dynamic>> _foods = [];

  Future<void> _fetchData() async {
    // Replace with the actual endpoint that returns saved food data
    final url = Uri.parse('http://localhost:3000/admin/get-products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _foods = data.cast<Map<String, dynamic>>(); // Convert to list of maps
      });
    } else {
      print('Error fetching data: ${response.statusCode}');
      // Handle errors appropriately (e.g., show an error message)
    }
  }

  Future<void> _deleteItem(String foodId) async {
    // Replace with the actual endpoint that deletes a food item
    final url = Uri.parse('http://localhost:3000/admin/delete-products/$foodId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Item deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Food item deleted'),
          duration: Duration(seconds: 2),
        ),
      );
      _foods.removeWhere((food) => food['_id'] == foodId); // Remove locally
      setState(() {}); // Update UI
    } else {
      print('Error deleting item: ${response.statusCode}');
      // Handle deletion errors appropriately (e.g., show error message)
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data on screen initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _foods.isEmpty
            ? Center(
          child: Text('No saved posts yet'),
        )
            : SingleChildScrollView(
              child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // This will make two cards appear in one row
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
          ),
          itemCount: _foods.length, // Use _foods.length instead of foods.length
          itemBuilder: (context, index) {
              final food = _foods[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCard(
                  imageUrl: (food['imageurls'] != null && food['imageurls'].isNotEmpty) ? food['imageurls'][0] : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0u1fuEEb5gSmGykuLt7FoFXyR_1O-_u1rSehjwOfAxQ&s',
                  categoryName: food['category'],
                  itemName: food['name'],
                  price: food['price'],
                  description: food['description'],
                  quantity: food['quantity'],
                  id: food['_id'],
                  currency: '₹',

                  onTap: () {
                    CartProvider cartProvider= Provider.of(context, listen: false);
                    bool alreadyExists = cartProvider.itemAlreadyExists(food);

                    if (alreadyExists) {
                      cartProvider.removeProduct(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item already exists in cart'),
                        ),
                      );
                    } else {
                      cartProvider.addProduct(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item added to cart successfully'),
                        ),
                      );
                    }
                  },
                ),
              );
          },
        ),
            ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
          onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFood()));},//navigateToAddProduct,
          tooltip: 'Add a Product',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}

