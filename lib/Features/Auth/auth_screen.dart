import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restraunt_management_app/Features/Admin/admin_screen.dart';
import 'package:restraunt_management_app/Features/Home/home.dart';
import 'package:restraunt_management_app/Provider/user_provider.dart';
import 'package:restraunt_management_app/Widgets/custom_snackbar.dart';
import 'package:restraunt_management_app/Widgets/custom_textfield.dart';

import '../../Widgets/custom_button.dart';
class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  String _selectedTableNumber='Find your table?';
  String userType = 'user';
  List<String> UserType = ['user', 'admin'];
  final List<String> _tableNumbers = [
    'Find your table?',
    'TBN_Q=TBID?A1',
    'TBN_Q=TBID?A2',
    'TBN_Q=TBID?A3',
    'TBN_Q=TBID?B1',
    'TBN_Q=TBID?B2',
    'TBN_Q=TBID?C1',
  ];

  Future<void> sendData(
      String name, String email, String userType, String table) async {
    var url = Uri.parse('http://localhost:3000/api/sendData');
    var body = jsonEncode(
        {'name': name, 'email': email, 'userType': userType, 'table': table});
    var response = await http.post(url,
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void showPasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          cursorColor: Colors.teal,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.teal),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal, // Orange border when focused
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text.trim();
              if (password == '1234') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              } else {
                // Handle incorrect password (e.g., show an error message)
                CustomSnackbar.show(context, 'Incorrect Password');
                Navigator.pop(context); // Close the dialog
                print('Incorrect password');
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(
                'assets/la1.json',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your gateway to deliciousness!',
              style: TextStyle(
                color: Color.fromARGB(255, 120, 0, 141),
                fontFamily: 'Raleway',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            // labelText: 'Name',
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            // labelText: 'Mobile Number',
                            hintText: 'Mobile Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: userType,
                          decoration: InputDecoration(
                            hintText: 'User Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          items: UserType.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              userType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedTableNumber,
                          decoration: InputDecoration(
                            // labelText: 'Table Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: const Icon(Icons.restaurant),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          items: _tableNumbers.map((tableNumber) {
                            return DropdownMenuItem<String>(
                              value: tableNumber,
                              child: Text(tableNumber),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTableNumber = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a table number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String name = _nameController.text;
                              String mobile=_mobileController.text;
                              if(userType=='admin') showPasswordDialog(context);
                              else{
                                sendData(name,mobile,userType,_selectedTableNumber);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                                Provider.of<UserProvider>(context,listen: false).addUser(name);
                                Provider.of<UserProvider>(context,listen: false).addTable(_selectedTableNumber);

                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 25,
                            ),
                          ),
                          child: const Text(
                            'Continue...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
            const Text(
              '© 2024 OrderEase. All rights reserved.',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Raleway',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
