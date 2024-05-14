import 'package:flutter/material.dart';
import 'package:restraunt_management_app/Constants/category_utils.dart';
import 'package:restraunt_management_app/Widgets/category_card.dart';

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    final screenWidth=screenSize.width;
    final screenHeight=screenSize.height;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
      //color: CustomColor.bgLight2,
      child: Column(
        children: [
          SizedBox(height: 20,),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 900
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      for(int i=0;i<categoryUtils.length;i++)
                        CategoryCard(category: categoryUtils[i])
                    ],
                  ),
                ],
              ),
            )
          ),

          SizedBox(height: 50,),
        ],
      ),

    );
  }
}
