import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

class G_map extends StatefulWidget {
  @override
  State<G_map> createState() => G_mapState();
}

class G_mapState extends State<G_map> {
 static double latitude=0.0;
 static double longitude=0.0;
List<Marker> markers = [];
final Set<Polyline> polyline = {};
List<LatLng> RouteCoords;
GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: 'AIzaSyC_BSom_6lacjKLraZzlvVyDSFM8zhnqi8');
 // initState(){
 //   determinePosition();
 //   super.initState();
 // }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();
    markers.add(
      Marker(
       markerId: MarkerId('mymarker'),
       draggable: false,
        onTap: ()=>{
         print('Marker tapped')
        },
        position: LatLng(23.2804204,77.3598988)
      )
    );
    markers.add(Marker(
      markerId: MarkerId('new market'),
      draggable: false,
      onTap: () => {
        print('2nd marker tapped')
      },
      position: LatLng(28.644800,77.216721)
    ));
    getRoute();
    polyline.add(
      Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
        points: RouteCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap
      )
    );
  }
 void determinePosition() async {
var getPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
setState(() {
  latitude = getPosition.latitude;
  longitude = getPosition.longitude;
});
print('latitude = ${getPosition.latitude}, longitude = ${getPosition.longitude}');
}
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.2804204,77.3598988),
    zoom: 17.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 19.151926040649414);

   getRoute() async{
    RouteCoords =  await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(
            23.2804204,
            77.3598988),
        destination: LatLng(28.644800, 77.216721),
        mode: RouteMode.driving
     );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: 400.0,
        width: double.infinity,
        child: GoogleMap(
          mapType: MapType.normal,
          polylines: polyline,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(markers),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}