import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Provider/cart_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_card.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.searchItem}) : super(key: key);

  final String searchItem; // Category to be fetched

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, dynamic>> _foods = [];
  bool _isFetchingData = false; // Flag for data fetching state
  String? _errorMessage; // Store error message for display

  Future<void> _fetchData() async {
    setState(() {
      _isFetchingData = true; // Set state to indicate data fetching
      _errorMessage = null; // Clear any previous error message
    });

    final String searchItem = widget.searchItem;
    final url = Uri.parse('http://localhost:3000/get-item/$searchItem');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _foods = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Error fetching data: $error";
      });
    } finally {
      setState(() {
        _isFetchingData = false; // Reset data fetching state
      });
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
      appBar: AppBar(title: Text("Search Item "),backgroundColor: Colors.teal,),
      body: _isFetchingData
          ? Center(child: CircularProgressIndicator()) // Show progress indicator
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!)) // Display error message
          : _foods.isEmpty
          ? Center(child: Text('No items found in this category'))
          : GridView.builder(
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
    );
  }
}
