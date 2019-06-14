import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Google maps in flutter",
      home: GoogleOfficeMap(),
    );
  }
}

class GoogleOfficeMap extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<GoogleOfficeMap> {
  GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  locations.Locations googleOffices;
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(title: office.name, snippet: office.address),
          
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps sample app"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushOffices,
          )
        ],
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(0.0, 0.0),
          zoom: 2.0,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }

  void _pushOffices() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles =
          googleOffices.offices.map((locations.Office office) {
        return ListTile(
          title: Text(office.name),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(office.image),
            backgroundColor: Colors.transparent,
          ),
          onTap: () {
            _showOffice(LatLng(office.lat, office.lng));
          },
        );
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text("Google Offices"),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  // Widget _buildOfficeList(){
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(8.0),
  //     itemBuilder: (BuildContext _context,int i) {
  //       if(i.isOdd){
  //         return Divider();
  //       }
  //       final int index = i ~/ 2;
  //       return _buildRow(googleOffices.offices[index].name,index);
  //     },
  //   );
  // }

  // Widget _buildRow(String name,int index){
  //   return ListTile(
  //     title: Text(name),
  //     onTap: _showOffice(googleOffices.offices),);
  // }

  void _showOffice(LatLng officeLocation) {
    mapController.moveCamera(CameraUpdate.newLatLngZoom(officeLocation, 17.0));
    // mapController.animateCamera(CameraUpdate.newLatLngZoom(officeLocation, 17.0));
    Navigator.of(context).pop();
  }
}
