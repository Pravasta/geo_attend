import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';

/// Hasil pemilihan titik pada peta.
class MapPickerResult {
  final double latitude;
  final double longitude;
  final String? address;

  const MapPickerResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

/// Halaman pemilihan titik lokasi menggunakan Google Maps.
class MapPickerPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  // Titik default (Monas, Jakarta) bila tidak ada koordinat awal.
  static const LatLng _defaultLatLng = LatLng(-6.175392, 106.827153);

  GoogleMapController? _controller;
  late LatLng _picked;
  MapType _mapType = MapType.normal;
  bool _resolving = false;
  String? _address;
  int _addrToken = 0;

  @override
  void initState() {
    super.initState();
    _picked =
        (widget.initialLatitude != null && widget.initialLongitude != null)
            ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
            : _defaultLatLng;
    _resolveAddress();
  }

  void _onPick(LatLng position) {
    setState(() => _picked = position);
    _resolveAddress();
  }

  /// Reverse geocoding reaktif untuk titik terpilih (latest-wins).
  Future<void> _resolveAddress() async {
    final token = ++_addrToken;
    setState(() {
      _resolving = true;
      _address = null;
    });
    String? address;
    try {
      address = await sl<GeocodingService>()
          .getAddress(_picked.latitude, _picked.longitude);
    } catch (_) {
      address = null;
    }
    if (!mounted || token != _addrToken) return;
    setState(() {
      _address = address;
      _resolving = false;
    });
  }

  Future<void> _goToMyLocation() async {
    try {
      final position = await sl<LocationService>().getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      await _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 17));
      _onPick(target);
    } catch (_) {
      Fluttertoast.showToast(msg: 'Tidak dapat mengambil lokasi saat ini.');
    }
  }

  void _confirm() {
    Navigator.of(context).pop(
      MapPickerResult(
        latitude: _picked.latitude,
        longitude: _picked.longitude,
        address: _address,
      ),
    );
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!EnvConfig.hasMapsApiKey) {
      return _MissingApiKeyView(
        onUseGps: () => Navigator.of(context).pop(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _picked, zoom: 16),
            mapType: _mapType,
            onMapCreated: (controller) => _controller = controller,
            onTap: _onPick,
            markers: {
              Marker(
                markerId: const MarkerId('picked'),
                position: _picked,
                draggable: true,
                onDragEnd: _onPick,
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            padding: const EdgeInsets.only(bottom: 220),
          ),
          // Tombol back & ganti tipe peta (mengambang).
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MapCircleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _MapCircleButton(
                    icon: Icons.layers,
                    onTap: _toggleMapType,
                  ),
                ],
              ),
            ),
          ),
          // Tombol "ke lokasi saya" di atas kartu bawah.
          Positioned(
            right: 14,
            bottom: 210,
            child: _MapCircleButton(
              icon: Icons.my_location,
              iconColor: AppColors.primary,
              onTap: _goToMyLocation,
            ),
          ),
          // Kartu bawah (bottom sheet) info titik + konfirmasi.
          Align(
            alignment: Alignment.bottomCenter,
            child: _PickedSheet(
              latitude: _picked.latitude,
              longitude: _picked.longitude,
              address: _address,
              resolving: _resolving,
              onConfirm: _confirm,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _MapCircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
  }
}

class _PickedSheet extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final bool resolving;
  final VoidCallback onConfirm;

  const _PickedSheet({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.resolving,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(color: Color(0x22000000), blurRadius: 24, offset: Offset(0, -6)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E6F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.place, size: 20, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Koordinat terpilih',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                resolving
                    ? 'Mengambil alamat…'
                    : (address ?? 'Alamat tidak tersedia'),
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              AppButton(
                label: 'Gunakan Lokasi Ini',
                icon: Icons.check,
                onPressed: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingApiKeyView extends StatelessWidget {
  final VoidCallback onUseGps;

  const _MissingApiKeyView({required this.onUseGps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih di Peta')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.key,
                    size: 52, color: Color(0xFFE65100)),
              ),
              const SizedBox(height: 18),
              Text(
                'Peta belum tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Google Maps API Key belum dikonfigurasi. Anda tetap dapat '
                'menggunakan fitur Ambil Koordinat (GPS) tanpa peta.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              AppButton.secondary(
                label: 'Gunakan GPS Saja',
                icon: Icons.gps_fixed,
                expand: false,
                onPressed: onUseGps,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
