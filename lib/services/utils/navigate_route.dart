import 'package:flutter/material.dart';
import 'package:flutter_map_practice/services/utils/route_name.dart';

import '../../pages/homepage.dart';

class NavigateRoutes
{
  static Route<dynamic> generateRoute(RouteSettings routeSettings)
  {
    switch (routeSettings.name)
    {
      case RouteName.HomePage:
        return MaterialPageRoute(builder: (context) => const MyHomePage());
      default:
        return MaterialPageRoute(builder: (context) => Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text("Page Not Found 404!", textAlign: TextAlign.center,),
          ),
        )
      );
    }
  }
}