import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_practice/constants/app_text.dart';
import 'package:flutter_map_practice/constants/app_url.dart';
import 'package:flutter_map_practice/constants/appcolor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../appbar_components/app_bar_search.dart';

class StackCombineHomePage extends StatefulWidget {
  const StackCombineHomePage({super.key});

  @override
  State<StackCombineHomePage> createState() => _StackCombineHomePageState();
}

class _StackCombineHomePageState extends State<StackCombineHomePage> {

  MapType _mapType = MapType.normal;

  // Initial camera position
  static CameraPosition _initialCameraPosition = const CameraPosition(
      target: LatLng(28.6061, 77.3619), // Appinventiv Noida
      zoom: 16,
      tilt: 50.0
  );
  Color backgroundColor = Colors.greenAccent;

  gotoHome() async
  {
    List<Location> locations = await locationFromAddress(AppText.homeLocationAddress);
    GoogleMapController controller = await AppUrl.controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(locations.last.latitude,locations.last.longitude), zoom: 18)
    ));
  }

  // latlongtoAddr() async
  // {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
  // }

  void normalOnTap()
  {
    if(_mapType != MapType.normal)
    {
      _mapType = MapType.normal;
    }
  }
  void hybridOnTap()
  {
    if(_mapType != MapType.hybrid)
    {
      _mapType = MapType.hybrid;
    }
  }

  void locateMe() async
  {
    GoogleMapController _cont = await AppUrl.controller.future;
    getCurrentLocation().then((value){
      _markers.add(Marker(markerId: MarkerId("2"), infoWindow:InfoWindow(title:  "I'm here"), position: LatLng(value.latitude, value.longitude)));
      _cont.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:  LatLng(value.latitude, value.longitude), zoom: 18)));
    });

    setState(() {});
  }

  Future<Position> getCurrentLocation() async
  {
    await Geolocator.requestPermission().then((value){}).onError((error, stackTrace){ print("Error Occur");});
    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = [
    const Marker(markerId: MarkerId(AppText.markId), position: LatLng(28.6061, 77.3619), infoWindow: InfoWindow(title: AppText.workLocation),),
    const Marker(markerId: MarkerId(AppText.markId), position: LatLng(28.6061, 77.4619), infoWindow: InfoWindow(title: AppText.myLocation),),
    const Marker(markerId: MarkerId(AppText.markId), position: LatLng(28.2007, 79.3652), infoWindow: InfoWindow(title: AppText.myHomeLocation),),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            compassEnabled: true,
            mapType: _mapType,
            markers: Set<Marker>.of(_markers),
            // myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller){
              AppUrl.controller.complete(controller);
            },
          ),
        ),
        Positioned(
          bottom: 300,
          right: 10,
          child: Column(
            children: [
              buttonCall(AppText.normal, AppColor.buttonColorHybridNormalHome, normalOnTap),
              const SizedBox(height: 10,),
              buttonCall(AppText.hybrid, AppColor.buttonColorHybridNormalHome, hybridOnTap),
              const SizedBox(height: 10,),
              buttonCall(AppText.home, AppColor.buttonColorHybridNormalHome, gotoHome),
              const SizedBox(height: 10,),
              buttonCall(AppText.me, AppColor.buttonColorHybridNormalHome, locateMe),
            ],
          ),
        ),
        Positioned(
            top: 10,
            child: SizedBox(height:60,width:width - 20,child: const MyAppBarWithSearchLocation())),
      ],
    );
  }

  Widget buttonCall(String name, Color color, VoidCallback voidCallback)
  {
    return InkWell(
      onTap: (){
        voidCallback();
        setState(() {

        });
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
            border: Border.all(color: backgroundColor, width: 2)
        ),
        child: Center(child: Text(name)),
      ),
    );
  }
}
