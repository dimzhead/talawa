import 'package:flutter/material.dart';
import 'package:talawa/utils/uidata.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:talawa/views/pages/chat.dart';

class Groups extends StatefulWidget {
  Groups({Key key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Organization $index'),
                leading: CircleAvatar(
                  child: Image.asset(UIData.talawaLogo),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: Chat(),
                  );
                },
              ),
            );
          }),
    );
  }
}
