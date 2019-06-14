import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  final double lat;
  final double lng;

  LatLng({this.lat, this.lng});

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);
}

@JsonSerializable()
class Region {
  final LatLng coords;
  final String id;
  final String name;
  final double zoom;

  Region({this.coords, this.id, this.name, this.zoom});

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toHson() => _$RegionToJson(this);
}

@JsonSerializable()
class Office {
  final String id;
  final String address;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String region;

  Office(
      {this.id,
      this.address,
      this.image,
      this.lat,
      this.lng,
      this.name,
      this.phone,
      this.region});

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> tojson() => _$OfficeToJson(this);
}

@JsonSerializable()
class Locations {
  final List<Office> offices;
  final List<Region> regions;

  Locations(this.offices, this.regions);

  factory Locations.fromJson(Map<String,dynamic> json) => _$LocationsFromJson(json);
  Map<String,dynamic> toJson() => _$LocationsToJson(this);
}

Future<Locations> getGoogleOffices() async{
  const googleLocationsURL = 'https://about.google/static/data/locations.json';
  final response = await http.get(googleLocationsURL);
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code:${response.statusCode}'
      '${response.reasonPhrase}',
      uri: Uri.parse(googleLocationsURL),
    );
  }
}
