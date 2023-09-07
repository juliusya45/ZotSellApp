import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zot_sell/screens/navigation_screens/settings.dart';

import '../../classes/app_listings.dart';
import '../../classes/zotuser.dart';
import 'home.dart';

class Nav extends StatefulWidget {
  const Nav({super.key, required this.allListings, required this.zotuser});

  //Declaring a list that holds all of the AppListings
  final List<AppListings> allListings;
  final Zotuser zotuser;

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  void onItemTap(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

  List<Widget> widgetOptions = 
  <Widget>[
    Home(allListings: widget.allListings, zotuser: widget.zotuser,),
    Settings()
  ];

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              haptic: true,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              curve: Curves.easeInExpo,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  backgroundColor: Colors.green[300]?.withOpacity(.3),
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  backgroundColor: Colors.blue[300]?.withOpacity(.3),
                  icon: LineIcons.plusCircle,
                  text: 'Add Listing',
                ),
                GButton(
                  icon: LineIcons.cog,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
    );
}
}