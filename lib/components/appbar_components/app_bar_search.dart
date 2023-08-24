import 'package:flutter/material.dart';
import 'package:flutter_map_practice/constants/app_url.dart';
import 'package:flutter_map_practice/constants/appcolor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyAppBarWithSearchLocation extends StatefulWidget {
  const MyAppBarWithSearchLocation({super.key});

  @override
  State<MyAppBarWithSearchLocation> createState() => _MyAppBarWithSearchLocationState();
}

class _MyAppBarWithSearchLocationState extends State<MyAppBarWithSearchLocation> {
  var controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.searchBarBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38, width: 2),
      ),
      child: Row(
        children: [
          Expanded(flex: 1 ,child: SizedBox()),
          Expanded(
            flex: 8,
            child: TextField(
              controller: controllerText,
              decoration: const InputDecoration(
                hintText: "Search here",
                border:InputBorder.none,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: ()async{
                    List<Location> locations = await locationFromAddress(controllerText.text.toString());
                    GoogleMapController controller = await AppUrl.controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(locations.last.latitude,locations.last.longitude), zoom: 18)
                    ));
                    locations.clear();
                    setState(() {

                    });
                  },
                  icon:const Icon(Icons.search)
              )
          ),
        ],
      ),
    );
  }
}