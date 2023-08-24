import 'package:flutter/material.dart';
import 'package:flutter_map_practice/constants/app_url.dart';
import '../components/appbar_components/app_bar_search.dart';
import '../components/homepage_components/homepage_stack_combine.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Center(
          child: StackCombineHomePage()

        ),
      ),
    );
  }
}