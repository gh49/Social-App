import 'package:flutter/material.dart';
import 'package:social_app_g/shared/network/local/cache_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(CacheHelper.getData(key: 'uID').toString()),
      ),
    );
  }
}
