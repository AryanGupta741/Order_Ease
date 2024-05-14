import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.imageurl,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.onTap,
    required this.productId,
  }) : super(key: key);

  final String productId;
  final String imageurl;
  final String category;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final VoidCallback onTap;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> ratings = [];

  @override
  void initState() {
    super.initState();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    final url = 'http://localhost:3000/api/get-ratings/${widget.productId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          ratings = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load ratings');
      }
    } catch (error) {
      throw Exception('Error fetching ratings: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 2,
              ),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  widget.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.food_bank,
                          color: Colors.teal,
                        ),
                        Text(
                          widget.category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              '${_calculateAverageRating().toStringAsFixed(1)} Rating',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.comment,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${ratings.length} Reviews',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.eco,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '100% Veg',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Text(
                          'About Items',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2A977D),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text('Total Price'),
                                  Text(
                                    '\u20B9 ${widget.price}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2A977D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Color(0xff2A977D),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(7),
                                    topLeft: Radius.circular(7),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.shopping_basket_outlined, color: Colors.white),
                                        Text(
                                          widget.quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: widget.onTap,
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              // Show ratings and comments if available
              if (ratings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2A977D),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4, // Add elevation for shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: ratings.length,
                                itemBuilder: (context, index) {
                                  final rating = ratings[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Icon(Icons.person,color: Colors.white,), // Placeholder user icon
                                    ),
                                    title: Row(
                                      children: List.generate(
                                        rating['rating'], // Use rating to generate star icons
                                            (index) => Icon(Icons.star, color: Colors.orange),
                                      ),
                                    ),
                                    subtitle: Text(
                                      rating['comment'] != null ?rating['comment']! : '-',
                                    ),

                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 60,)
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAverageRating() {
    double totalRating = 0;
    for (var rating in ratings) {
      totalRating += rating['rating'];
    }
    return totalRating / ratings.length;
  }
}
