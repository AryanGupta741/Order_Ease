import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Features/Admin/add_food.dart';
import 'package:restraunt_management_app/Provider/user_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_button.dart';
class OrderedFood extends StatefulWidget {
  const OrderedFood({Key? key}) : super(key: key);

  @override
  State<OrderedFood> createState() => _OrderedFoodState();
}

class _OrderedFoodState extends State<OrderedFood> {
  List<Map<String, dynamic>> _foods = [];

  Future<void> _fetchData() async {
    // Replace with the actual endpoint that returns saved food data
    final url = Uri.parse('http://localhost:3000/admin/get-order');
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
    final url = Uri.parse('http://localhost:3000/admin/delete-ordered-item/$foodId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Item deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Food item served'),
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
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final table = Provider.of<UserProvider>(context, listen: false).table_number;
    return Scaffold(
        body: _foods.isEmpty
            ? Center(
          child: Text('No saved posts yet'),
        )
            : ListView.builder(
          itemCount: _foods.length,
          itemBuilder: (context, index) {
            final food = _foods[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to left
                      children: [
                        Text(
                          food['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items horizontally
                          children: [
                            Center(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(food['imageurls'][0]),
                                // Use the first image URL
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('Category : ${food['category']}'),
                        SizedBox(height: 10),
                        Text('Quantity : ₹ ${food['quantity']}'),
                        SizedBox(height: 10),
                        Text('Customer name : ${user}'),
                        SizedBox(height: 10),
                        Text('Table number :  ${table}'),
                        SizedBox(height: 10,),
                        CustomButton(
                            text: 'Food Served',
                            onTap: (){
                              _deleteItem(food['_id']);
                            }
                        )
                      ],
                    ),

                  ),
                ),
              ),
            );
          },
        ),

    );
  }
}


