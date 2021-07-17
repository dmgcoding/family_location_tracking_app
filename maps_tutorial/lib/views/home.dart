import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_tutorial/models/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  static late LatLng _initialPosition;
  List<User> users = [];
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    users = Users.users;
    _initialPosition = LatLng(users.first.latitude, users.first.longtitude);
  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 120);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addMarkers() {
    users.forEach((user) async {
      Uint8List iconData = await getBytesFromAsset(user.img);
      LatLng position = LatLng(user.latitude, user.longtitude);
      MarkerId markerId = MarkerId(user.markerId);
      Marker marker = Marker(
        markerId: markerId,
        onTap: () async {
          //update the camera position
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 0,
              target: position,
              zoom: 18,
            ),
          ));
        },
        position: position,
        infoWindow: InfoWindow(
          title: "${user.name}",
          snippet: "this is the snippet",
          onTap: () {
            //
          },
        ),
        icon: BitmapDescriptor.fromBytes(iconData),
      );
      setState(() {
        _markers[markerId] = marker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text("Map is loading"),
              ),
            )
          : Container(
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  googleMap(),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Container(
                        width: width,
                        height: 120,
                        color: Colors.transparent,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return profileCard(users[index]);
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  GoogleMap googleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 16,
      ),
      mapType: MapType.satellite,
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _controller.complete(controller);
        });
        //create the markers when map is created
        addMarkers();
      },
      markers: Set.of(_markers.values),
    );
  }

  Column profileCard(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            //on tap zoom on/ change the camera position to the relevant user marker
            final markerId = user.markerId;
            final marker = _markers[MarkerId(markerId)];

            if (marker != null) {
              marker.onTap!.call();
            }
          },
          child: Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.pink,
                  width: 4,
                  style: BorderStyle.solid,
                ),
                image: DecorationImage(image: AssetImage(user.img))),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "${user.name}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
