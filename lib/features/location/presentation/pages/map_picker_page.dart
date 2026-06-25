import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../../core/services/location_service.dart';
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
///
/// Pengguna dapat menyentuh peta untuk menempatkan pin, memperbesar untuk
/// presisi, lalu mengonfirmasi titik tersebut.
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

  @override
  void initState() {
    super.initState();
    _picked = (widget.initialLatitude != null && widget.initialLongitude != null)
        ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
        : _defaultLatLng;
  }

  void _onTap(LatLng position) {
    setState(() => _picked = position);
  }

  Future<void> _goToMyLocation() async {
    try {
      final position = await sl<LocationService>().getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      setState(() => _picked = target);
      await _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 17));
    } catch (_) {
      Fluttertoast.showToast(msg: 'Tidak dapat mengambil lokasi saat ini.');
    }
  }

  Future<void> _confirm() async {
    setState(() => _resolving = true);
    String? address;
    try {
      address = await sl<GeocodingService>()
          .getAddress(_picked.latitude, _picked.longitude);
    } catch (_) {
      address = null;
    }
    if (!mounted) return;
    Navigator.of(context).pop(
      MapPickerResult(
        latitude: _picked.latitude,
        longitude: _picked.longitude,
        address: address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!EnvConfig.hasMapsApiKey) {
      return _MissingApiKeyView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi di Peta'),
        actions: [
          IconButton(
            tooltip: 'Ganti tipe peta',
            icon: const Icon(Icons.layers),
            onPressed: () => setState(() {
              _mapType = _mapType == MapType.normal
                  ? MapType.hybrid
                  : MapType.normal;
            }),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _picked, zoom: 16),
            mapType: _mapType,
            onMapCreated: (controller) => _controller = controller,
            onTap: _onTap,
            markers: {
              Marker(
                markerId: const MarkerId('picked'),
                position: _picked,
                draggable: true,
                onDragEnd: _onTap,
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _PickedInfoCard(
              latitude: _picked.latitude,
              longitude: _picked.longitude,
              resolving: _resolving,
              onConfirm: _resolving ? null : _confirm,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        tooltip: 'Ke lokasi saya',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

class _PickedInfoCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final bool resolving;
  final VoidCallback? onConfirm;

  const _PickedInfoCard({
    required this.latitude,
    required this.longitude,
    required this.resolving,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Titik terpilih',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onConfirm,
              icon: resolving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(resolving ? 'Memproses...' : 'Gunakan Lokasi Ini'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingApiKeyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi di Peta')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Google Maps API key belum dikonfigurasi.\n'
                'Isi MAPS_API_KEY pada file .env untuk menggunakan peta.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
