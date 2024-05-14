import 'package:flutter/material.dart';
import 'package:restraunt_management_app/Widgets/detailed_page.dart';

class CustomCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String description;
  final String categoryName;
  final String itemName;
  final int quantity;
  final int price;
  final String currency;
  final VoidCallback onTap; // Callback function for handling cart icon tap

  const CustomCard({
    Key? key,
    required this.imageUrl,
    required this.categoryName,
    required this.itemName,
    required this.price,
    required this.currency,
    required this.onTap,
    required this.description,
    required this.quantity, required this.id, // Pass the callback function
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(
              productId: widget.id,
              imageurl: widget.imageUrl,
              name: widget.itemName,
              description: widget.description,
              price: widget.price,
              quantity: widget.quantity,
              category: widget.categoryName,
              onTap: widget.onTap,
          )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Color.fromARGB(255, 245, 245, 245),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isAdded = !isAdded;
                        });
                        widget.onTap(); // Call the onTap callback
                      },
                      child: Icon(
                        isAdded
                            ? Icons.shopping_cart_rounded
                            : Icons.shopping_cart_outlined,
                        color: isAdded ? Colors.teal : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(137, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.eco_rounded,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '100 % Veg',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          '${widget.currency}${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
