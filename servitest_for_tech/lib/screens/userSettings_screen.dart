import 'package:flutter/material.dart';

class UserSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Center(
        child: Text('User settings will be displayed here.'),
      ),
    );
  }
}