import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talawa/controllers/activity_controller.dart';
import 'package:talawa/controllers/auth_controller.dart';
import 'package:talawa/controllers/note_controller.dart';
import 'package:talawa/controllers/organisation_controller.dart';
import 'package:talawa/model/activity.dart';
import 'package:talawa/utils/uidata.dart';
import 'package:talawa/views/pages/newsfeed.dart';
import 'package:talawa/views/pages/organizations.dart';
import 'package:talawa/views/widgets/common_drawer.dart';
import 'package:intl/intl.dart';
import 'package:talawa/controllers/user_controller.dart';
import 'package:talawa/model/user.dart';
import 'package:talawa/enums/connectivity_status.dart';


import 'package:talawa/views/pages/events.dart';
import 'package:talawa/views/pages/groups.dart';

import 'package:talawa/views/pages/addEventPage.dart';


import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // PageController pageController = PageController(initialPage: 3);
  // int currentIndex = 0;
  PersistentTabController _controller = PersistentTabController(initialIndex: 1);
  // AnimationController controller;

  @override
  void initState() {
    super.initState();
    // Provider.of<NoteController>(context, listen: false).initializeSocket(
    //     Provider.of<AuthController>(context, listen: false).currentUserId);
  }
  void dispose() {
      _controller.dispose();
      super.dispose();
    }

  _showSnackBar() {
    print("Show SnackBar Here");
    final snackBar = new SnackBar(content: new Text("Device Disconnected"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return CircularProgressIndicator();
  }

  List<Widget> _buildScreens() {
    return [
          NewsFeed(),
          Groups(),
          Organizations(),
          Events(),
          ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        // isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.group),
        title: ("Groups"),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        // isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.business),
        title: ("Organizations"),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        // isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: ("events"),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        // isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("profile"),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        // isTranslucent: false,
      ),
    ];
  }
  

  @override
  Widget build(BuildContext context) {
    var connectionStatus =
        Provider.of<ConnectivityStatus>(context, listen: true);
    if (connectionStatus == ConnectivityStatus.Offline) {
      _showSnackBar();
    }
    return PersistentTabView(
      backgroundColor: UIData.quitoThemeColor,
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      // showElevation: true,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      iconSize: 26.0,
      navBarStyle: NavBarStyle.style4,
      onItemSelected: (index) {
      },
    ); 
  }

}






