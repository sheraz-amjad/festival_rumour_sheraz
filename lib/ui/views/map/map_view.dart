import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/backbutton.dart';
import 'map_view_model.dart';

class MapView extends BaseView<MapViewModel> {
  final VoidCallback? onBack;
  const MapView({super.key, this.onBack});

  @override
  MapViewModel createViewModel() => MapViewModel();

  @override
  Widget buildView(BuildContext context, MapViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Google Maps
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.8688, 151.2093),
                zoom: 11.0,
              ),
              markers: _buildMarkers(viewModel)..addAll(viewModel.markers),
              polylines: _buildPolylines()..addAll(viewModel.polylines),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                viewModel.setMapController(controller);
              },
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Stack(
                    children: [
                      // Map content area
                      Container(),

                      // Overlay with code icon and text
                      // _buildOverlay(context),

                      // Direction button
                      _buildDirectionButton(context, viewModel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          CustomBackButton(onTap: onBack ?? () => Navigator.pop(context)),
          const SizedBox(width: AppDimensions.spaceM),
          const ResponsiveTextWidget(
            'Location',
            textType: TextType.body,
            color: AppColors.white,
            fontSize: AppDimensions.textL,
            fontWeight: FontWeight.w600,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Handle share action
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.grey800.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: const Icon(
                Icons.share,
                color: AppColors.white,
                size: AppDimensions.iconM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned(
      left: 50,
      top: 100,
      child: Container(
        width: AppDimensions.imageXXL,
        height: AppDimensions.imageXXL,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey600.withOpacity(0.3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const ResponsiveTextWidget(
                  '</>',
                  textType: TextType.body,
                  color: AppColors.black,
                  fontSize: AppDimensions.textXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              const ResponsiveTextWidget(
                'Code with joy',
                textType: TextType.body,
                color: AppColors.white,
                fontSize: AppDimensions.textM,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton(BuildContext context, MapViewModel viewModel) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () => _requestLocationAndShowDirections(context, viewModel),
        backgroundColor: AppColors.buttonYellow,
        child: const Icon(
          Icons.directions,
          color: AppColors.black,
          size: AppDimensions.iconL,
        ),
      ),
    );
  }

  Future<void> _requestLocationAndShowDirections(
    BuildContext context,
    MapViewModel viewModel,
  ) async {
    try {
      // Request location permission
      final permission = await Permission.location.request();

      if (permission.isGranted) {
        // Get current location
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final userLocation = LatLng(position.latitude, position.longitude);

        // Get festival location (you can make this dynamic)
        final festivalLocation = const LatLng(
          -33.9068,
          151.1553,
        ); // Marrickville festival location

        // Show directions
        await viewModel.showDirections(userLocation, festivalLocation);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: ResponsiveTextWidget(
                'Directions shown to festival location',
              ),
              backgroundColor: AppColors.buttonYellow,
            ),
          );
        }
      } else {
        // Show permission denied message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: ResponsiveTextWidget(
                'Location permission is required to show directions',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ResponsiveTextWidget('Error getting location: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Set<Marker> _buildMarkers(MapViewModel viewModel) {
    return {
      // Festival locations with special markers
      Marker(
        markerId: const MarkerId('festival1'),
        position: const LatLng(-33.9068, 151.1553),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: 'Marrickville Festival',
          snippet: 'Music & Arts Festival',
        ),
        onTap: () {
          viewModel.animateToLocationWithZoom(
            const LatLng(-33.9068, 151.1553),
            15.5,
          );
        },
      ),
      // Marker(
      //   markerId: const MarkerId('festival2'),
      //   position: const LatLng(-33.7967, 151.1834), // Chatswood Festival
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   infoWindow: const InfoWindow(
      //     title: 'Chatswood Festival',
      //     snippet: 'Cultural Festival',
      //   ),
      // ),
      // Marker(
      //   markerId: const MarkerId('festival3'),
      //   position: const LatLng(-33.7772, 151.1177), // Macquarie Park Festival
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   infoWindow: const InfoWindow(
      //     title: 'Macquarie Park Festival',
      //     snippet: 'Tech & Music Festival',
      //   ),
      // ),
      // Marker(
      //   markerId: const MarkerId('festival4'),
      //   position: const LatLng(-33.8151, 151.1036), // North Ryde Festival
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   infoWindow: const InfoWindow(
      //     title: 'North Ryde Festival',
      //     snippet: 'Community Festival',
      //   ),
      // ),
      // Marker(
      //   markerId: const MarkerId('festival5'),
      //   position: const LatLng(-33.8772, 151.1026), // Burwood Festival
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   infoWindow: const InfoWindow(
      //     title: 'Burwood Festival',
      //     snippet: 'Food & Music Festival',
      //   ),
      // ),
      // Marker(
      //   markerId: const MarkerId('festival6'),
      //   position: const LatLng(-33.9233, 151.1853), // Mascot Festival
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   infoWindow: const InfoWindow(
      //     title: 'Mascot Festival',
      //     snippet: 'Local Community Festival',
      //   ),
      // ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      // This will be populated when directions are shown
    };
  }
}
