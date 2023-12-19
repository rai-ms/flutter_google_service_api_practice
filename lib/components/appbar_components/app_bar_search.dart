import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map_practice/constants/app_url.dart';
import 'package:flutter_map_practice/constants/appcolor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MyAppBarWithSearchLocation extends StatefulWidget {
  const MyAppBarWithSearchLocation({super.key});

  @override
  State<MyAppBarWithSearchLocation> createState() => _MyAppBarWithSearchLocationState();
}

class _MyAppBarWithSearchLocationState extends State<MyAppBarWithSearchLocation> {
  var controllerText = TextEditingController();

  var uuid = Uuid();
  String _sessionToken = "12344";

  List<dynamic> searchList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerText.addListener(() {
      onChanged();
    });
  }

  onChanged()
  {
     if(_sessionToken == null)
       {
         _sessionToken = uuid.v4();
       }

     getSuggestion(controllerText.text);
  }

  getSuggestion(String searchText) async
  {
    String placesAPIKEY = "AIzaSyDVln3Rih9F2WqASEONO7ER-HfPpOc3hbE";
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = '$baseURL?input=$searchText&key=$placesAPIKEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    // var responses = await _client.get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText"
    //     "&types=establishment&language=en&components=country:in&key=$placesAPIKEY&sessiontoken=19");

    if(response.statusCode == 200)
      {
        searchList = jsonDecode(response.body.toString())['predictions'];
        print(response.body.toString());
      }
    else
      {
        throw Exception('Error Occured');
      }

  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.searchBarBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(flex: 1 ,child: SizedBox()),
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
                        setState(() { });
                      },
                      icon:const Icon(Icons.search)
                  )
              ),
            ],
          ),

        ],
      ),
    );
  }
}