import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier{
  late Location _location;
  Location get location => _location;
  late LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;
  late BitmapDescriptor _pinLocationIcon;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon ;
  late Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;

  final MarkerId markerId = MarkerId("1");

  bool locationServiceActive=true;

  LocationProvider(){
    _location = new Location();
  }

  initalization() async{
    await getUserLocation();
    await setCustomMapPin();

  }

  getUserLocation() async {
    late bool _serviceEnabled;
    late PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled){
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation){
      _locationPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
      );
      print(_locationPosition);

      _markers = <MarkerId, Marker>{};
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      ),
        icon: pinLocationIcon,
        draggable: true,
        onDragEnd: ((newPosition){
          _locationPosition = LatLng(
            newPosition.latitude,
            newPosition.longitude,
          );

          notifyListeners();
        })
      );
      _markers[markerId] = marker;
      notifyListeners();
    });
  }
  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
          devicePixelRatio:  2.5,
      ), 'assets/images/destination_marker.png'
    );
  }
}