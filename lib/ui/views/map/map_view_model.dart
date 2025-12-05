import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/viewmodels/base_view_model.dart';

class MapViewModel extends BaseViewModel {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  GoogleMapController? get mapController => _mapController;
  Set<Polyline> get polylines => _polylines;
  Set<Marker> get markers => _markers;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void animateToLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(location),
      );
    }
  }

  void animateToLocationWithZoom(LatLng location, double zoom) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, zoom),
      );
    }
  }

  Future<void> showDirections(LatLng userLocation, LatLng festivalLocation) async {
    // Create a polyline between user location and festival location
    _polylines = {
      Polyline(
        polylineId: const PolylineId('directions'),
        points: [userLocation, festivalLocation],
        color: const Color(0xFF8B5CF6), // Purple color for directions
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    // Add user location marker
    _markers = {
      Marker(
        markerId: const MarkerId('user_location'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
      Marker(
        markerId: const MarkerId('festival_destination'),
        position: festivalLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Festival Location'),
      ),
    };

    // Animate camera to show both locations
    if (_mapController != null) {
      final bounds = _calculateBounds([userLocation, festivalLocation]);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    }

    notifyListeners();
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void clearDirections() {
    _polylines.clear();
    _markers.clear();
    notifyListeners();
  }
}
