import 'package:flutter/material.dart';
import 'package:restraunt_management_app/Features/Home/home.dart';
import 'package:restraunt_management_app/Widgets/custom_button.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Payment done',style: TextStyle(
                fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10),
            CustomButton(text: 'Back to Home', onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
            })
          ],
        ),
      ),
    );
  }
}
