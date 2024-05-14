import 'package:flutter/material.dart';

import '../Constants/nav_items.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({Key? key, required this.onNavItemTap, this.width = 250.0}) : super(key: key);
  final Function(int) onNavItemTap;
  final double width; // Added a parameter to control width

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black12,
      child: SizedBox( // Wrap with SizedBox for explicit width control
        width: width, // Set width based on the provided parameter
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.cancel, color: Colors.orange)),
              ),
            ),
            for (int i = 0; i < navIcons.length; i++)
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                onTap: () {
                  onNavItemTap(i);
                },
                leading: Icon(navIcons[i], color: Colors.white),
                title: Text(navItems[i]),
              )
          ],
        ),
      ),
    );
  }
}
