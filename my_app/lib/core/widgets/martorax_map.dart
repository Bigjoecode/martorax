import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Asaba hub coordinates (Ogbogonogo market) used as the default map center.
const LatLng kAsabaCenter = LatLng(6.2054, 6.7291);

/// A dark-themed Google Map matching the MartoraX palette, with sensible
/// defaults. Renders a real map once a Google Maps API key is configured in
/// android/key.properties (MAPS_API_KEY=...); until then the tiles area shows
/// blank but the app still builds and runs.
class MartoraxMap extends StatefulWidget {
  final LatLng initialTarget;
  final double initialZoom;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final void Function(GoogleMapController controller)? onMapCreated;
  final bool myLocationButton;

  const MartoraxMap({
    super.key,
    this.initialTarget = kAsabaCenter,
    this.initialZoom = 14,
    this.markers = const {},
    this.polylines = const {},
    this.onMapCreated,
    this.myLocationButton = false,
  });

  @override
  State<MartoraxMap> createState() => _MartoraxMapState();
}

class _MartoraxMapState extends State<MartoraxMap> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialTarget,
        zoom: widget.initialZoom,
      ),
      markers: widget.markers,
      polylines: widget.polylines,
      style: _darkMapStyle,
      myLocationButtonEnabled: widget.myLocationButton,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onMapCreated: (c) {
        _controller = c;
        widget.onMapCreated?.call(c);
      },
    );
  }
}

/// Dark map styling tuned to the app's deep-slate / emerald look.
const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0d1b2a"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#0d1b2a"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#334155"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#162032"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#0f3d2e"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1e2d3d"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#24344a"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2b3b50"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#162032"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#07101a"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#4e6d70"}]}
]
''';
